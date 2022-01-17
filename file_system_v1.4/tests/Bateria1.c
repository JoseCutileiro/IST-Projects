#include "fs/operations.h"
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

#define MESSAGE "=============================================\n     Sistemas operativos || 2021/2022        \n=============================================\n              .........                      \n            .'------.' |                     \n           | .-----. | |                     \n           | |GS   | | |                     \n         __| |   JC| | |;. _______________   \n        /  |*`-----'.|.' `;              //  \n       /   `---------' .;'              //   \n /|   /  .''''////////;'               //    \n|=|  .../ ######### /;/               //|    \n|/  /  / ######### //                //||    \n   /   `-----------'                // ||    \n  /________________________________//| ||    \n  `--------------------------------' | ||    \n   : | ||      | || |__LL__|| ||     | ||    \n   : | ||      | ||         | ||             \n   n | ||                   | ||             \n   M | ||                   | ||             \n     | ||                   | ||\0"
#define MESSAGE_LEN 952

#define NUMBER_OF_THREAD 20  // Max number of thread is 20 because you can only have 20 files on the file table
#define NUMBER_OF_CICLES 100 // Repeat the test in order to test multi threads behaviour

int file_id;
int answer;
int ourBuffer[NUMBER_OF_THREAD];
char copy_files[NUMBER_OF_THREAD][10];

// Function for generating random strings
static char *rand_string(char *str, size_t size, unsigned int seed)
{
    srand(seed);
    const char charset[] = "zecutileirogoncalosilvaGONCALOSILVAZECUTILEIRO";
    if (size) {
        --size;
        for (size_t n = 0; n < size; n++) {
            int key = rand() % (int) (sizeof charset - 1);
            str[n] = charset[key];
        }
        str[size] = '\0';
    }
    return str;
}

// Function for writing one byte in the current file
void* WriteOneByte(void * args) {
    char localBuffer[1] = {1};
    ssize_t bytes_writen = tfs_write(file_id,localBuffer,1);
    assert(bytes_writen == 1);

    printf("[%d]WRITE: Thread cicle OK || \n",*((int*)args));

    pthread_exit(NULL);
}

// Function for reading the test file and validate its content
void* readFullFile(void * args) {

    // Open File
    char path[11] = "/root";
    int local_file_id = tfs_open(path,0);
    assert(local_file_id != -1);

    // Read file content to buffer
    char localBuffer[NUMBER_OF_CICLES*NUMBER_OF_THREAD];
    ssize_t bytes_read = tfs_read(local_file_id,localBuffer,NUMBER_OF_THREAD*NUMBER_OF_CICLES);
    assert(bytes_read == NUMBER_OF_CICLES*NUMBER_OF_THREAD);

    // Validate buffer content
    for (int i = 0; i < NUMBER_OF_CICLES*NUMBER_OF_THREAD; i++) {
        assert(localBuffer[i] == 1);
    }

    // Close file 
    assert(tfs_close(local_file_id) != -1);

    printf("[%d]READ: Thread cicle OK | \n",*((int*)args));
    pthread_exit(NULL);
}

// Thread function for copying file (tfs_copy)
void* tfs_copy_thread(void * args) {
    char source[10] = "/source";
    char dest[10];
    rand_string(dest,10,(unsigned int)rand()%100000);
    strcpy(copy_files[*((int*)args)], dest);
    assert(tfs_copy_to_external_fs(source,dest) == 0);
    
    printf("\x1B[32m[%d] COPY_WRITE Thread OK\x1B[37m\n",*((int*)args));

    pthread_exit(NULL);
}

// Function for testing copy module
void tfs_copy_simple() {
    pthread_t tid[NUMBER_OF_THREAD];
    int count[NUMBER_OF_THREAD];
    char path[10] = "/source";
    char buffer2[971] = MESSAGE;

    // Open file
    int file_id2 = tfs_open(path,TFS_O_CREAT);
    assert(file_id2!= -1);

    // Write content to file
    ssize_t bytes_read = tfs_write(file_id2,buffer2,strlen(buffer2));
    assert(bytes_read == strlen(buffer2));

    // Launch copy function threads
    for (int i = 0; i < NUMBER_OF_THREAD;i++) {
        count[i] = i;
        pthread_create(&tid[i],NULL,tfs_copy_thread, (void*)&count[i]);
    }
    for (int i = 0; i < NUMBER_OF_THREAD; i++) {
        pthread_join(tid[i],NULL);
    }
    return ;
}

// Function for validating copied files
void validate_copy() {
    FILE *f;
    char buffer[MESSAGE_LEN];

    printf("Checking copied files... \n");
    
    for(int i = 0; i < NUMBER_OF_THREAD; i++) {
        f = fopen(copy_files[i], "r");
        size_t bytes_read = fread(&buffer, sizeof(char), MESSAGE_LEN, f);
        assert(bytes_read == MESSAGE_LEN);
        assert(strcmp(buffer, MESSAGE) == 0);
        fclose(f);

        printf("\x1B[37m[%s] \x1B[32mContent match \x1B[37m\n",copy_files[i]);
    }

    printf("\x1B[32m COPY OK \x1B[37m\n");

}


int main() {
    char path[10] = "/root";
    assert(tfs_init() != -1);
    pthread_t tid[NUMBER_OF_THREAD];
    int count[NUMBER_OF_THREAD];
    answer = 0;  

    // Open file and check possible errors
    file_id = tfs_open(path, TFS_O_CREAT);
    assert(file_id != -1);

    // Test multithread write
    for (int j = 0; j < NUMBER_OF_CICLES; j++){
        for (int i = 0; i < NUMBER_OF_THREAD;i++) {
            count[i] = i;
            pthread_create(&tid[i],NULL,WriteOneByte, (void*)&count[i]);
        }
        for (int i = 0; i < NUMBER_OF_THREAD; i++) {
            pthread_join(tid[i],NULL);
        }
    }

    // Close file 
    assert(tfs_close(file_id) == 0);
    
    // Test multithread read
    for (int j = 0; j < NUMBER_OF_CICLES; j++) {
        // FIRST CICLE: Every thread will read 1 byte from the buffer
        for (int i = 0; i < NUMBER_OF_THREAD;i++) {
            count[i] = i;
            pthread_create(&tid[i],NULL,readFullFile, (void*)&count[i]);
        }
        for (int i = 0; i < NUMBER_OF_THREAD; i++) {
            pthread_join(tid[i],NULL);
        }
    }

    tfs_copy_simple();

    validate_copy();

    assert(tfs_destroy() == 0);

    printf("\x1B[32mSuccessful test.\n \x1B[37m");

    return 0;
}