#include "tfs_server.h"

Client clients[S];
pthread_t workers_tids[S];
int shutdown_request_session_id = -1;
int rx_channel;
pthread_mutex_t register_lock = PTHREAD_MUTEX_INITIALIZER;

// Ver SIGPIPE

#define CLOSE(pipe)                     \
    if (close(pipe) != 0)               \
        exit(EXIT_FAILURE);

// FAILSAFE OK
void* worker(void* args) {
    int session_id = *((int*) args);
    bool shutdown = false;
    int tx = -1;
    Client *local_client;

    /* Switch case vars */ 
    char pipe_name[40];
    char file_name[40];
    int flags = -1;
    int ret = -1;
    int fhandle = -1;
    size_t len;
    void* buffer;
    ssize_t read;
    ssize_t writen;
    int sucess_message = 0;

    local_client = &clients[session_id];

    while (true) {

        if (pthread_mutex_lock(&local_client->worker_lock) != 0) {
            exit(EXIT_FAILURE);
        }
        
        
        while (!local_client->has_data) {
            if (pthread_cond_wait(&local_client->work,&local_client->worker_lock) != 0) {
                exit(EXIT_FAILURE);
            }
        }

        // ========= PROTECTED ZONE =========

        // State machine 

        char OP_CODE = ((char*)local_client->consumer_productor)[0];



        switch (OP_CODE)
        {
        case TFS_OP_CODE_MOUNT:
            //char pipe_name[40];
            strcpy(pipe_name,(local_client->consumer_productor)+1);
            strcpy(local_client->pipe_name, pipe_name);
            tx = open(pipe_name, O_WRONLY);
            if (tx == -1) {
                *(local_client->pipe_name) = '\0';
                break;
            }

            if (send_to_pipe(tx, &session_id, sizeof(int)) != 0) {
                *(local_client->pipe_name) = '\0';
                CLOSE(tx);
            };

            break;

        case TFS_OP_CODE_SHUTDOWN_AFTER_ALL_CLOSED:
            shutdown = true;
            
            // Send success message
            if (session_id == shutdown_request_session_id) {
                int response = tfs_destroy_after_all_closed();
                if (send_to_pipe(tx,&response, sizeof(int)) != 0) {
                    *(local_client->pipe_name) = '\0';
                    CLOSE(tx);
                }

                // We shut everything down here
                shutdown_workers();
            }

            // Set pipe name to NULL 
            *(local_client->pipe_name) = '\0';
            if (tx != -1) {
                CLOSE(tx);
            }

            if (session_id == shutdown_request_session_id) {
                // At this point everything should be ready to exit

                CLOSE(rx_channel);
                exit(EXIT_SUCCESS);
            }

            break;

        case TFS_OP_CODE_UNMOUNT:
            if (tx == -1) {
                *(local_client->pipe_name) = '\0';
                break;
            }

            if (send_to_pipe(tx,&sucess_message, sizeof(int)) != 0){
                //ignore
            }
            // Set pipe name to NULL 
            *(local_client->pipe_name) = '\0';
            CLOSE(tx);
            break;

        case TFS_OP_CODE_OPEN:
            strcpy(file_name,(local_client->consumer_productor)+1);
            flags = ((int*)(local_client->consumer_productor+41))[0];
            ret = tfs_open(file_name,flags);
            if (send_to_pipe(tx,&ret, sizeof(int)) != 0) {
                *(local_client->pipe_name) = '\0';
                CLOSE(tx);
            }
            break;

        case TFS_OP_CODE_CLOSE:
            fhandle = ((int*)(local_client->consumer_productor+1))[0];
            ret = tfs_close(fhandle);
            if(send_to_pipe(tx,&ret, sizeof(int)) != 0) {
                *(local_client->pipe_name) = '\0';
                CLOSE(tx);
            }
            break;

        case TFS_OP_CODE_WRITE:
            fhandle = ((int*)(local_client->consumer_productor+1))[0];
            len = ((size_t *)(local_client->consumer_productor+1+sizeof(int)))[0];
            buffer = (void*) malloc((size_t)len);
            if (buffer == NULL) {
                exit(EXIT_FAILURE);
            }
            memcpy(buffer, local_client->consumer_productor+1+sizeof(int)+sizeof(size_t), len);
            writen = tfs_write(fhandle,buffer,(size_t)len);
            free(buffer);

            if (send_to_pipe(tx,&writen, sizeof(ssize_t)) == -1){
                *(local_client->pipe_name) = '\0';
                CLOSE(tx);   
            };
            break;


        case TFS_OP_CODE_READ:
            fhandle = ((int*)(local_client->consumer_productor+1))[0];
            len = ((size_t *)(local_client->consumer_productor+1+sizeof(int)))[0];
            buffer = (void *) malloc(len);
            if (buffer == NULL) {
                exit(EXIT_FAILURE);
            }
            read = tfs_read(fhandle,buffer,len);
            if (send_to_pipe(tx,&read, sizeof(ssize_t)) == -1) {
                *(local_client->pipe_name) = '\0';
                CLOSE(tx);
            }
            if (read != -1) { //TODO: CHECK THIS
                if (send_to_pipe(tx,buffer, (size_t)read) == -1) {
                    *(local_client->pipe_name) = '\0';
                    CLOSE(tx);
                }
            }
            free(buffer);

        default:
            break;
        }
        // ========= PROTECTED ZONE END =========

        local_client->has_data = false;

        if (pthread_cond_signal(&local_client->ready) != 0) {
            exit(EXIT_FAILURE);
        }
        if (pthread_mutex_unlock(&local_client->worker_lock)) {
            exit(EXIT_FAILURE);
        }

        if (shutdown) {
            break;
        }
    }
    pthread_exit(NULL);
}


// FAILSAFE OK
void dispatch_to_worker(int session_id, void* data) {
    Client *local_client = &clients[session_id];

    if (pthread_mutex_lock(&local_client->worker_lock) != 0) {
        exit(EXIT_FAILURE);
    };

    while(local_client->has_data) {
        if (pthread_cond_wait(&local_client->ready, &local_client->worker_lock) != 0) {
            exit(EXIT_FAILURE);
        }
    }

    // ========= PROTECTED ZONE =========

    memcpy(local_client->consumer_productor, data, BUFFER_SIZE);

    // ========= PROTECTED ZONE END =========    

    local_client->has_data = true;
    if(pthread_cond_signal(&local_client->work) != 0) {
        exit(EXIT_FAILURE);
    };
         
    if (pthread_mutex_unlock(&local_client->worker_lock) != 0) {
        exit(EXIT_FAILURE);
    }
}

// Search for free workers and returns session id
// FAILSAFE OK
void register_client(char *pipename) {
    char code = TFS_OP_CODE_MOUNT;
    void *dispatch_buffer;

    MUTEX_LOCK(&register_lock);

    for (int i = 0; i < S; i++) {
        if (clients[i].pipe_name[0] == '\0') {
           
            strcpy(clients[i].pipe_name, pipename);

            CMD *command = create_empty_command();
            command->op_code = &code;
            command->pipe_name = pipename;

            dispatch_buffer = encode_command(command);
            if (dispatch_buffer == NULL) {
                fprintf(stderr,"[SERVER] Could not dispatch command to worker\n");    
            }
            dispatch_to_worker(i, dispatch_buffer);
            printf("[SERVER] Client %s registered with session id %d \n", pipename, i);
            free(dispatch_buffer);
            MUTEX_UNLOCK(&register_lock);
            return;
        }
    }

    // Unable to mount (NO FREE WORKERS)
    fprintf( stderr, "[REGISTER_ERROR]: Unable to mount %s (NO FREE WORKERS) \n", pipename);
    int tx = open(pipename, O_WRONLY);
    int ret_code = -1;
    send_to_pipe(tx, &ret_code, sizeof(int));
    CLOSE(tx);

    MUTEX_UNLOCK(&register_lock);
}

// FAILSAFE OK
void initialize_workers() {
    for (int i = 0; i < S; i++) {
        Client *client = &clients[i];
        client->session_id = i;
        client->consumer_productor = malloc(BUFFER_SIZE);

        if (client->consumer_productor == NULL) {
            fprintf(stderr, "[SERVER]: Could not allocate memory for producer consumer buffer\n");
            exit(EXIT_FAILURE);
        }

        if (pthread_cond_init(&client->ready, NULL) != 0) {
            fprintf(stderr, "[SERVER]: Fail while initializing pthread cond \n");
            exit(EXIT_FAILURE);
        }

        if (pthread_cond_init(&client->work, NULL) != 0) {
            fprintf(stderr, "[SERVER]: Fail while initializing pthread cond \n");
            exit(EXIT_FAILURE);
        }

        if (pthread_mutex_init(&client->worker_lock, NULL) != 0) {
            fprintf(stderr, "[SERVER]: Fail while initializing mutex \n");
            exit(EXIT_FAILURE);
        }

        if (pthread_create(&workers_tids[i], NULL, worker, (void*)&client->session_id) != 0) {
            fprintf(stderr, "[SERVER]: Unable to create thread\n");
            exit(EXIT_FAILURE);
        }
    }
}

// FAILSAFE OK
void shutdown_workers() {
    int i;
    char shutdown_code = TFS_OP_CODE_SHUTDOWN_AFTER_ALL_CLOSED;

    for (i = 0; i < S; i++) {
        if (i != shutdown_request_session_id) {
            dispatch_to_worker(i, &shutdown_code);
        }
    }

    for (i = 0; i < S; i++) {
        if (i != shutdown_request_session_id) {
            if (pthread_join(workers_tids[i], NULL) != 0){
                fprintf(stderr,"[SERVER] Could not shutdown workers\n");
                exit(EXIT_FAILURE);
            }
            if (pthread_cond_destroy(&clients[i].ready) != 0) {
                fprintf(stderr,"[SERVER] Could not shutdown workers\n");
                exit(EXIT_FAILURE);
            }
            if (pthread_cond_destroy(&clients[i].work) != 0) {
                fprintf(stderr,"[SERVER] Could not shutdown workers\n");
                exit(EXIT_FAILURE);
            }
            if (pthread_mutex_destroy(&clients[i].worker_lock) != 0) {
                fprintf(stderr,"[SERVER] Could not shutdown workers\n");
                exit(EXIT_FAILURE);
            }
            free(clients[i].consumer_productor);
        }
    }

}

void notifySIGPIPE() {
    fprintf(stderr,"*** [SERVER] SIGPIPE detected ***\n");
    signal(SIGPIPE,notifySIGPIPE);
}

// FAILSAFE OK 
int main(int argc, char **argv) {

    signal(SIGPIPE,notifySIGPIPE);

    if (argc < 2) {
        printf("[SERVER] Please specify the pathname of the server's pipe.\n");
        return 1;
    }

    char *pipename = argv[1];
    printf("[SERVER] Starting TecnicoFS server with pipe called %s\n", pipename);

    // Unlink pipe

    if (unlink(pipename) != 0 && errno != ENOENT) {
        fprintf(stderr, "[SERVER]: Error while unlinking %s \n", pipename);
        exit(EXIT_FAILURE);
    }

    if (mkfifo(pipename, 0640) != 0) {
        fprintf(stderr, "[SERVER]: Error while creating pipe %s \n", pipename);
        exit(EXIT_FAILURE);
    }

   
    if (tfs_init() != 0) {
        fprintf(stderr, "[SERVER]: Error while initializing Tecnico fs\n");
        exit(EXIT_FAILURE);
    }

    initialize_workers();

   
    rx_channel = open(pipename, O_RDONLY);
   
    if (rx_channel == -1) {
        fprintf(stderr,"[SERVER] Could not open pipe %s\n",pipename);
        exit(EXIT_FAILURE);
    }

    while(true) {
        char OP_CODE = ' ';
        int session_id, flags, file_handle;
        size_t file_buffer_length;
        char client_pipename[SIZE_OF_NAMED_PIPE];
        char filename[MAX_FILE_NAME];
        CMD *command;
        void *dispatch_buffer, *write_buffer;

        if (read_from_pipe(rx_channel, &OP_CODE, sizeof(char)) == -1) {
            if (shutdown_request_session_id == -1 || errno != EBADF) {
                fprintf(stderr,"[SERVER] Could not read from pipe %s\n",pipename);
                exit(EXIT_FAILURE);
            } else {
                fprintf(stdout,"[SERVER] Got EBADF while reading but ignoring it since the server is shutting down \n");
            }
        }

        if (OP_CODE != ' ') {        
            switch (OP_CODE) {
                case TFS_OP_CODE_MOUNT:
                    // Mount things
                    if (read_from_pipe(rx_channel, &client_pipename, SIZE_OF_NAMED_PIPE) == -1) {
                        fprintf(stderr,"[SERVER] Could not read from pipe %s\n",pipename);
                        exit(EXIT_FAILURE);
                    }
                    register_client(client_pipename);
                    break;

                case TFS_OP_CODE_UNMOUNT:
                    // Unmount

                    if (read_from_pipe(rx_channel, &session_id, sizeof(int)) == -1) {
                        exit(EXIT_FAILURE);
                    }

                    printf("[SERVER][SESSION %d] Request to unmount\n", session_id);

                    dispatch_to_worker(session_id, &OP_CODE);
                    break;

                case TFS_OP_CODE_OPEN:
                    // Open file

                    if (read_from_pipe(rx_channel, &session_id, sizeof(int)) == -1) {
                        exit(EXIT_FAILURE);
                    };
                    if (read_from_pipe(rx_channel, &filename, MAX_FILE_NAME) == -1) {
                        exit(EXIT_FAILURE);
                    };
                    if (read_from_pipe(rx_channel, &flags, sizeof(int)) == -1) {
                        exit(EXIT_FAILURE);
                    };

                    printf("[SERVER][SESSION %d] Request to open file\n", session_id);

                    command = create_empty_command();
                    command->op_code = &OP_CODE;
                    command->file_name = filename;
                    command->flags = &flags;
                    dispatch_buffer = encode_command(command);
                    if (dispatch_buffer == NULL) {
                        exit(EXIT_FAILURE);
                    }
                    dispatch_to_worker(session_id, dispatch_buffer);
                    free(dispatch_buffer);
                    break;

                case TFS_OP_CODE_CLOSE:
                    if (read_from_pipe(rx_channel, &session_id, sizeof(int)) == -1) {
                        exit(EXIT_FAILURE);
                    }
                    if (read_from_pipe(rx_channel, &file_handle, sizeof(int)) == -1) {
                        exit(EXIT_FAILURE);
                    }

                    printf("[SERVER][SESSION %d] Request to close file\n", session_id);

                    command = create_empty_command();
                    command->op_code = &OP_CODE;
                    command->file_handle = &file_handle;
                    dispatch_buffer = encode_command(command);
                    if (dispatch_buffer == NULL) {
                        exit(EXIT_FAILURE);
                    }
                    dispatch_to_worker(session_id, dispatch_buffer);
                    free(dispatch_buffer);
                    break;

                case TFS_OP_CODE_WRITE:
                    if (read_from_pipe(rx_channel, &session_id, sizeof(int)) == -1) {
                        exit(EXIT_FAILURE);
                    }
                    if (read_from_pipe(rx_channel, &file_handle, sizeof(int)) == -1) {
                        exit(EXIT_FAILURE);
                    }
                    if (read_from_pipe(rx_channel, &file_buffer_length, sizeof(size_t)) == -1) {
                        exit(EXIT_FAILURE);
                    };
                    write_buffer = malloc(file_buffer_length);
                    if (write_buffer == NULL) {
                        exit(EXIT_FAILURE);
                    }
                    if (read_from_pipe(rx_channel, write_buffer, file_buffer_length) == -1) {
                        exit(EXIT_FAILURE);
                    }

                    printf("[SERVER][SESSION %d] Request to write to file\n", session_id);

                    command = create_empty_command();
                    command->op_code = &OP_CODE;
                    command->file_handle = &file_handle;
                    command->len = &file_buffer_length;
                    command->buffer = write_buffer;
                    dispatch_buffer = encode_command(command);
                    if (dispatch_buffer == NULL) {
                        exit(EXIT_FAILURE);
                    }
                    dispatch_to_worker(session_id, dispatch_buffer);
                    free(dispatch_buffer);
                    free(write_buffer);
                    break;

                case TFS_OP_CODE_READ:

                    if (read_from_pipe(rx_channel, &session_id, sizeof(int)) == -1) {
                        exit(EXIT_FAILURE);
                    }
                    if (read_from_pipe(rx_channel, &file_handle, sizeof(int)) == -1) {
                        exit(EXIT_FAILURE);
                    }
                    if (read_from_pipe(rx_channel, &file_buffer_length, sizeof(size_t)) == -1) {
                        exit(EXIT_FAILURE);
                    }

                    printf("[SERVER][SESSION %d] Request to read from file\n", session_id);

                    command = create_empty_command();
                    command->op_code = &OP_CODE;
                    command->file_handle = &file_handle;
                    command->len = &file_buffer_length;
                    dispatch_buffer = encode_command(command);
                    if (dispatch_buffer == NULL) {
                        exit(EXIT_FAILURE);
                    }
                    dispatch_to_worker(session_id, dispatch_buffer);
                    free(dispatch_buffer);
                    break;


                case TFS_OP_CODE_SHUTDOWN_AFTER_ALL_CLOSED:

                    if (read_from_pipe(rx_channel, &session_id, sizeof(int)) == -1) {
                        exit(EXIT_FAILURE);
                    }

                    printf("[SERVER][SESSION %d] Request to shutdown\n", session_id);

                    shutdown_request_session_id = session_id;
                    command = create_empty_command();
                    command->op_code = &OP_CODE;
                    command->session_id = &session_id;
                    dispatch_buffer = encode_command(command);
                    dispatch_to_worker(session_id, dispatch_buffer);
                    free(dispatch_buffer);
                    break;

                default:
                    break;
            }
        }
    }

    return EXIT_FAILURE;
}