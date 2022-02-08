#ifndef COMMON_H
#define COMMON_H

#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>
#include <errno.h>

#define SIZE_OF_NAMED_PIPE (40)

#ifndef MAX_FILE_NAME
#define MAX_FILE_NAME (40)
#endif

#define MUTEX_LOCK(lock)            \
    if (pthread_mutex_lock(lock))   \
        exit(-1);

#define MUTEX_UNLOCK(lock)            \
    if (pthread_mutex_unlock(lock))   \
        exit(-1);



/* tfs_open flags */
enum {
    TFS_O_CREAT = 0b001,
    TFS_O_TRUNC = 0b010,
    TFS_O_APPEND = 0b100,
};

/* operation codes (for client-server requests) */
enum {
    TFS_OP_CODE_MOUNT = '1',
    TFS_OP_CODE_UNMOUNT = '2',
    TFS_OP_CODE_OPEN = '3',
    TFS_OP_CODE_CLOSE = '4',
    TFS_OP_CODE_WRITE = '5',
    TFS_OP_CODE_READ = '6',
    TFS_OP_CODE_SHUTDOWN_AFTER_ALL_CLOSED = '7'
};


typedef struct command {
    char* op_code;
    int* session_id;
    char const * pipe_name;
    char const * file_name;
    int* flags;
    int* file_handle;
    size_t* len;
    void const *buffer;
} CMD;


// Pipes base functions
int send_to_pipe(int tx, void *str, size_t size);
ssize_t read_from_pipe(int rx, void* buffer, size_t size);

// Commands base functions
CMD* create_empty_command();
void* encode_simple(void* current, void const* param, size_t size);
void* encode_command(CMD* command);
int send_command(int tx, CMD* command);

#endif /* COMMON_H */
