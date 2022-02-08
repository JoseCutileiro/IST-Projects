#include "tecnicofs_client_api.h"

int server_tx;
int client_rx;
int session_id;

void catchSIGPIPE(int s) {
    fprintf(stderr, "[TFS_API]: Caught pipe error: %d \n", s);
    exit(EXIT_FAILURE);
}

//FAILSAFE OK
int tfs_mount(char const *client_pipe_path, char const *server_pipe_path) {
    signal(SIGPIPE, catchSIGPIPE);

    //  Init RX pipe
    if (unlink(client_pipe_path) != 0 && errno != ENOENT) {
        fprintf(stderr, "[TFS_MOUNT]: Error while unlinking %s \n", client_pipe_path);
        return -1;
    }

    if (mkfifo(client_pipe_path, 0640) != 0) {
        fprintf(stderr, "[TFS_MOUNT]: Error while creating pipe %s \n", client_pipe_path);
        return -1;
    }

    // Connect to server
    server_tx = open(server_pipe_path, O_WRONLY);

    if (server_tx == -1) {
        fprintf(stderr, "[TFS_MOUNT]: Error opening %s \n", server_pipe_path);
        return -1;
    }

    CMD *command = create_empty_command();
    if (command == NULL) {
        fprintf(stderr, "[TFS_MOUNT]: Error while sending mount request \n");
        return -1;
    }

    char op_code = TFS_OP_CODE_MOUNT;
    command->op_code = &op_code;
    command->pipe_name = client_pipe_path;

    if (send_command(server_tx, command) == -1) {
        fprintf(stderr, "[TFS_MOUNT]: Error while sending mount request \n");
        return -1;
    }

    client_rx = open(client_pipe_path, O_RDONLY);

    if (client_rx == -1) {
        fprintf(stderr, "[TFS_MOUNT]: Error opening %s \n", client_pipe_path);
        return -1;
    }

    ssize_t ret = read_from_pipe(client_rx, &session_id, sizeof(int));
    if (ret == -1) {
        return -1;
    }

    if (session_id == -1) {
        fprintf(stderr, "[TFS_MOUNT]: The server was unable to mount this client \n");
        return -1;
    }
    
    return 0;
}

//FAILSAFE OK
int tfs_unmount() {
    CMD *command = create_empty_command();
    if (command == NULL) {
        fprintf(stderr, "[TFS_UNMOUNT]: Error while sending unmount request \n");
        return -1;
    }
    char op_code = TFS_OP_CODE_UNMOUNT;
    command->op_code = &op_code;
    command->session_id = &session_id;

    if (send_command(server_tx, command) == -1) {
        fprintf(stderr, "[TFS_UNMOUNT]: Error while sending unmount request \n");
        return -1;
    }

    int response;
    ssize_t ret = read_from_pipe(client_rx, &response, sizeof(int));
    if (ret == -1) {
        return -1;
    }

    if (response == -1) {
        fprintf(stderr, "[TFS_UNMOUNT]: A server error occurred while unmounting this client \n");
        return -1;
    }

    return 0;
}
//FAILSAFE OK
int tfs_open(char const *name, int flags) {
    CMD *command = create_empty_command();
    if (command == NULL) {
        fprintf(stderr, "[TFS_OPEN]: Error while sending open request \n");
        return -1;
    }
    char op_code = TFS_OP_CODE_OPEN;
    command->op_code = &op_code;
    command->session_id = &session_id;
    command->file_name = name;
    command->flags = &flags;

    if (send_command(server_tx, command) == -1) {
        fprintf(stderr, "[TFS_OPEN]: Error while sending open request \n");
        return -1;
    }

    int fhandle;
    ssize_t ret = read_from_pipe(client_rx, &fhandle, sizeof(int));
    if (ret == -1) {
        return -1;
    }

    if (fhandle < 0)
        fprintf(stderr, "[TFS_OPEN]: A server error occurred while trying to open the file\n");

    return fhandle;
}

//FAILSAFE OK
int tfs_close(int fhandle) {
    CMD *command = create_empty_command();
    if (command == NULL) {
        fprintf(stderr, "[TFS_CLOSE]: Error while sending close request \n");
        return -1;
    }
    char op_code = TFS_OP_CODE_CLOSE;
    command->op_code = &op_code;
    command->session_id = &session_id;
    command->file_handle = &fhandle;

    if (send_command(server_tx, command) == -1) {
        fprintf(stderr, "[TFS_CLOSE]: Error while sending close request \n");
        return -1;
    }

    int close_ret;
    ssize_t ret = read_from_pipe(client_rx, &close_ret, sizeof(int));
    if (ret == -1) {
        return -1;
    }

    if (close_ret != 0)
        fprintf(stderr, "[TFS_CLOSE]: A server error occurred while trying to close the file\n");

    return close_ret;
}

//FAILSAFE OK
ssize_t tfs_write(int fhandle, void const *buffer, size_t len) {
    CMD *command = create_empty_command();
    if (command == NULL) {
        fprintf(stderr, "[TFS_WRITE]: Error while sending write request \n");
        return -1;
    }
    char op_code = TFS_OP_CODE_WRITE;
    command->op_code = &op_code;
    command->session_id = &session_id;
    command->file_handle = &fhandle;
    command->len = &len;
    command->buffer = buffer;

    if (send_command(server_tx, command) == -1) {
        fprintf(stderr, "[TFS_WRITE]: Error while sending write request \n");
        return -1;
    }

    ssize_t write_ret;
    ssize_t ret = read_from_pipe(client_rx,&write_ret, sizeof(ssize_t));
    if (ret == -1) {
        return -1;
    }

    return write_ret;
}

//FAILSAFE OK
ssize_t tfs_read(int fhandle, void *buffer, size_t len) {
    CMD *command = create_empty_command();
    if (command == NULL) {
        fprintf(stderr, "[TFS_READ]: Error while sending read request \n");
        return -1;
    }
    char op_code = TFS_OP_CODE_READ;
    command->op_code = &op_code;
    command->session_id = &session_id;
    command->file_handle = &fhandle;
    command->len = &len;

    if (send_command(server_tx, command) == -1) {
        fprintf(stderr, "[TFS_READ]: Error while sending read request \n");
        return -1;
    }

    ssize_t r;
    ssize_t ret = read_from_pipe(client_rx, &r,sizeof(ssize_t));
    if (ret == -1) {
        return -1;
    }

    if (r == -1) {
        return -1;
    }

    ret = read_from_pipe(client_rx, buffer,(size_t)r);
    if (ret == -1) {
        return -1;
    }

    return r;
}

//FAILSAFE OK
int tfs_shutdown_after_all_closed() {
    CMD *command = create_empty_command();
    if (command == NULL) {
        fprintf(stderr, "[TFS_SHUTDOWN_AFTER_ALL_CLOSED]: Error while sending shutdown request \n");
        return -1;
    }
    char op_code = TFS_OP_CODE_SHUTDOWN_AFTER_ALL_CLOSED;
    command->op_code = &op_code;
    command->session_id = &session_id;

    if (send_command(server_tx, command) == -1) {
        fprintf(stderr, "[TFS_SHUTDOWN_AFTER_ALL_CLOSED]: Error while sending shutdown request \n");
        return -1;
    }

    int response;
    ssize_t ret = read_from_pipe(client_rx, &response, sizeof(int));
    if (ret == -1) {
        return -1;
    }

    if (response == -1) {
        return -1;
    }
    return 0;
}
