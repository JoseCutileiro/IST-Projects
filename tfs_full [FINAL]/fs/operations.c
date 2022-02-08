#include "operations.h"
#include <pthread.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static pthread_mutex_t single_global_lock;
static pthread_cond_t close_cond = PTHREAD_COND_INITIALIZER;
static int open_files_count = 0;
static int destroy_call;

int tfs_init() {
    state_init();

    destroy_call = 0;

    if (pthread_mutex_init(&single_global_lock, 0) != 0)
        return -1;

    /* create root inode */
    int root = inode_create(T_DIRECTORY);
    if (root != ROOT_DIR_INUM) {
        return -1;
    }

    return 0;
}

int tfs_destroy() {
    state_destroy();
    if (pthread_mutex_destroy(&single_global_lock) != 0) {
        return -1;
    }
    return 0;
}

int tfs_destroy_after_all_closed() {
    if (pthread_mutex_lock(&single_global_lock) != 0) {
        exit(EXIT_FAILURE);
    }
    destroy_call = 1;
    while(open_files_count > 0) {
        if (pthread_cond_wait(&close_cond, &single_global_lock) != 0) {
            exit(EXIT_FAILURE);
        }
    }
    if (pthread_mutex_unlock(&single_global_lock) != 0)
        exit(EXIT_FAILURE);

    printf("[TecnicoFS]: Shutting down the file system... \n");
    tfs_destroy();
    return 0;
}


static bool valid_pathname(char const *name) {
    return name != NULL && strlen(name) > 1 && name[0] == '/';
}

int _tfs_lookup_unsynchronized(char const *name) {
    if (!valid_pathname(name)) {
        return -1;
    }

    // skip the initial '/' character
    name++;

    return find_in_dir(ROOT_DIR_INUM, name);
}

int tfs_lookup(char const *name) {
    if (pthread_mutex_lock(&single_global_lock) != 0)
        return -1;
    int ret = _tfs_lookup_unsynchronized(name);
    if (pthread_mutex_unlock(&single_global_lock) != 0)
        return -1;
    return ret;
}

static int _tfs_open_unsynchronized(char const *name, int flags) {
    int inum;
    size_t offset;

    inum = _tfs_lookup_unsynchronized(name);
    if (inum >= 0) {
        /* The file already exists */
        inode_t *inode = inode_get(inum);
        if (inode == NULL) {
            return -1;
        }

        /* Trucate (if requested) */
        if (flags & TFS_O_TRUNC) {
            if (inode->i_size > 0) {
                if (data_block_free(inode->i_data_block) == -1) {
                    return -1;
                }
                inode->i_size = 0;
            }
        }
        /* Determine initial offset */
        if (flags & TFS_O_APPEND) {
            offset = inode->i_size;
        } else {
            offset = 0;
        }
    } else if (flags & TFS_O_CREAT) {
        /* The file doesn't exist; the flags specify that it should be created*/
        /* Create inode */
        inum = inode_create(T_FILE);
        if (inum == -1) {
            return -1;
        }
        /* Add entry in the root directory */
        if (add_dir_entry(ROOT_DIR_INUM, inum, name + 1) == -1) {
            inode_delete(inum);
            return -1;
        }
        offset = 0;
    } else {
        return -1;
    }

    /* Finally, add entry to the open file table and
     * return the corresponding handle */
    return add_to_open_file_table(inum, offset);

    /* Note: for simplification, if file was created with TFS_O_CREAT and there
     * is an error adding an entry to the open file table, the file is not
     * opened but it remains created */
}

int tfs_open(char const *name, int flags) {
    if (pthread_mutex_lock(&single_global_lock) != 0)
        return -1;

    if (destroy_call) {
        return -1;
    }
    int ret = _tfs_open_unsynchronized(name, flags);

    if (ret != -1) {
        open_files_count++;
    }
    
    if (pthread_mutex_unlock(&single_global_lock) != 0)
        return -1;

    return ret;
}

int tfs_close(int fhandle) {
    if (pthread_mutex_lock(&single_global_lock) != 0)
        return -1;
    int r = remove_from_open_file_table(fhandle);
    if (r != -1) {
        open_files_count--;
    }
    
    pthread_cond_signal(&close_cond);
    if (pthread_mutex_unlock(&single_global_lock) != 0)
        return -1;

    return r;
}

static ssize_t _tfs_write_unsynchronized(int fhandle, void const *buffer,
                                         size_t to_write) {
    open_file_entry_t *file = get_open_file_entry(fhandle);
    if (file == NULL) {
        return -1;
    }

    /* From the open file table entry, we get the inode */
    inode_t *inode = inode_get(file->of_inumber);
    if (inode == NULL) {
        return -1;
    }

    /* Determine how many bytes to write */
    if (to_write + file->of_offset > BLOCK_SIZE) {
        to_write = BLOCK_SIZE - file->of_offset;
    }

    if (to_write > 0) {
        if (inode->i_size == 0) {
            /* If empty file, allocate new block */
            inode->i_data_block = data_block_alloc();
        }

        void *block = data_block_get(inode->i_data_block);
        if (block == NULL) {
            return -1;
        }

        /* Perform the actual write */
        memcpy(block + file->of_offset, buffer, to_write);

        /* The offset associated with the file handle is
         * incremented accordingly */
        file->of_offset += to_write;
        if (file->of_offset > inode->i_size) {
            inode->i_size = file->of_offset;
        }
    }

    return (ssize_t)to_write;
}

ssize_t tfs_write(int fhandle, void const *buffer, size_t to_write) {
    if (pthread_mutex_lock(&single_global_lock) != 0)
        return -1;
    ssize_t ret = _tfs_write_unsynchronized(fhandle, buffer, to_write);
    if (pthread_mutex_unlock(&single_global_lock) != 0)
        return -1;

    return ret;
}

static ssize_t _tfs_read_unsynchronized(int fhandle, void *buffer, size_t len) {
    open_file_entry_t *file = get_open_file_entry(fhandle);
    if (file == NULL) {
        return -1;
    }

    /* From the open file table entry, we get the inode */
    inode_t *inode = inode_get(file->of_inumber);
    if (inode == NULL) {
        return -1;
    }

    /* Determine how many bytes to read */
    size_t to_read = inode->i_size - file->of_offset;
    if (to_read > len) {
        to_read = len;
    }

    if (to_read > 0) {
        void *block = data_block_get(inode->i_data_block);
        if (block == NULL) {
            return -1;
        }

        /* Perform the actual read */
        memcpy(buffer, block + file->of_offset, to_read);
        /* The offset associated with the file handle is
         * incremented accordingly */
        file->of_offset += to_read;
    }

    return (ssize_t)to_read;
}

ssize_t tfs_read(int fhandle, void *buffer, size_t len) {
    if (pthread_mutex_lock(&single_global_lock) != 0)
        return -1;
    ssize_t ret = _tfs_read_unsynchronized(fhandle, buffer, len);
    if (pthread_mutex_unlock(&single_global_lock) != 0)
        return -1;

    return ret;
}
