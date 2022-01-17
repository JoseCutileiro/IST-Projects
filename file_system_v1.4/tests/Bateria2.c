#include "fs/operations.h"
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

#define NUMBER_OF_THREAD 20  // Max number of thread is 20 because you can only have 20 files on the file table
#define NUMBER_OF_CICLES 100 // Repeat the test in order to test multi threads behaviour

int file_id;
int answer;
int ourBuffer[NUMBER_OF_THREAD];

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


int main() {
    char path[10] = "/root";
    assert(tfs_init() != -1);
    int number_of_threads = NUMBER_OF_THREAD;
    pthread_t tid[NUMBER_OF_THREAD];
    int count[NUMBER_OF_THREAD];
    answer = 0;  

    // Open file and check possible errors
    file_id = tfs_open(path, TFS_O_CREAT);
    assert(file_id != -1);

    // Test multithread write
    for (int j = 0; j < NUMBER_OF_CICLES; j++){
        for (int i = 0; i < number_of_threads;i++) {
            count[i] = i;
            pthread_create(&tid[i],NULL,WriteOneByte, (void*)&count[i]);
        }
        for (int i = 0; i < number_of_threads; i++) {
            pthread_join(tid[i],NULL);
        }
    }

    // Close file 
    assert(tfs_close(file_id) == 0);
    
    // Test multithread read
    for (int j = 0; j < NUMBER_OF_CICLES; j++) {
        for (int i = 0; i < number_of_threads;i++) {
            count[i] = i;
            pthread_create(&tid[i],NULL,readFullFile, (void*)&count[i]);
        }
        for (int i = 0; i < number_of_threads; i++) {
            pthread_join(tid[i],NULL);
        }
    }

    assert(tfs_destroy() == 0);
    
    printf("\x1B[32mSuccessful test.\n \x1B[37m");

    return 0;
}


