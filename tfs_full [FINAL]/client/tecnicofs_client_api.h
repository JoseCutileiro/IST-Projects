#ifndef CLIENT_API_H
#define CLIENT_API_H

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

/*
 * Establishes a session with a TecnicoFS server.
 * Input:
 * - client_pipe_path: pathname of a named pipe that will be used for
 *   the client to receive responses. This named pipe will be created (via
 * 	 mkfifo) inside tfs_mount.
 * - server_pipe_path: pathname of the named pipe where the server is listening
 *   for client requests
 * When successful, the new session's identifier (session_id) was
 * saved internally by the client; also, the client process has
 * successfully opened both named pipes (one for reading, the other one for
 * writing, respectively).
 *
 * Returns 0 if successful, -1 otherwise.
 */
int tfs_mount(char const *client_pipe_path, char const *server_pipe_path);

/*
 * Ends the currently active session.
 * After notifying the server, both named pipes are closed by the client,
 * the client named pipe is deleted (via unlink) and the client's session_id is
 * set to none.
 *
 * Returns 0 if successful, -1 otherwise.
 */
int tfs_unmount();

/*
 * Opens a file
 * Input:
 *  - name: absolute path name
 *  - flags: can be a combination (with bitwise or) of the following flags:
 *    - append mode (TFS_O_APPEND)
 *    - truncate file contents (TFS_O_TRUNC)
 *    - create file if it does not exist (TFS_O_CREAT)
 */
int tfs_open(char const *name, int flags);

/* Closes a file
 * Input:
 * 	- file handle (obtained from a previous call to tfs_open)
 * Returns 0 if successful, -1 otherwise.
 */
int tfs_close(int fhandle);

/* Writes to an open file, starting at the current offset
 * Input:
 * 	- file handle (obtained from a previous call to tfs_open)
 * 	- buffer containing the contents to write
 * 	- length of the contents (in bytes)
 *
 * Returns the number of bytes that were written (can be lower than
 * 'len' if the maximum file size is exceeded), or -1 in case of error.
 */
ssize_t tfs_write(int fhandle, void const *buffer, size_t len);

/* Reads from an open file, starting at the current offset
 * * Input:
 * 	- file handle (obtained from a previous call to tfs_open)
 * 	- destination buffer
 * 	- length of the buffer
 *
 * Returns the number of bytes that were copied from the file to the buffer
 * (can be lower than 'len' if the file size was reached), or -1 in case of
 * error.
 */
ssize_t tfs_read(int fhandle, void *buffer, size_t len);

/*
 * Orders TecnicoFS server to wait until no file is open and then shutdown
 * Returns 0 if successful, -1 otherwise.
 */
int tfs_shutdown_after_all_closed();

#endif /* CLIENT_API_H */
