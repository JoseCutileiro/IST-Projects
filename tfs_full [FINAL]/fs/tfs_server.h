#ifndef _SERVER_
#define _SERVER_

#include "operations.h"
#include <stdbool.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <signal.h>


/* Useful consts */
#define S 20 // Max active sessions
#define BUFFER_SIZE 2048 // Producer consumer buffer size

/* Client struct */
typedef struct client {
    int session_id;
    char pipe_name[SIZE_OF_NAMED_PIPE];
    void* consumer_productor;
    bool has_data;
    pthread_cond_t work;
    pthread_cond_t ready;
    pthread_mutex_t worker_lock;
} Client;

void shutdown_workers();

#endif