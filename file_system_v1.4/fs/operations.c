#include "operations.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

pthread_mutex_t open_lock = PTHREAD_MUTEX_INITIALIZER;

int tfs_init() {
    state_init();

    /* create root inode */
    int root = inode_create(T_DIRECTORY);
    if (root != ROOT_DIR_INUM) {
        return -1;
    }

    return 0;
}

int tfs_destroy() {
    pthread_mutex_destroy(&open_lock);
    state_destroy();
    return 0;
}

static bool valid_pathname(char const *name) {
    return name != NULL && strlen(name) > 1 && name[0] == '/';
}


int tfs_lookup(char const *name) {
    if (!valid_pathname(name)) {
        return -1;
    }

    // skip the initial '/' character
    name++;

    return find_in_dir(ROOT_DIR_INUM, name);
}

int tfs_open(char const *name, int flags) {
    int inum;
    size_t offset;

    
    MUTEX_LOCK(&open_lock);

    /* Checks if the path name is valid */
    if (!valid_pathname(name)) {
        MUTEX_UNLOCK(&open_lock);
        return -1;
    }

    /* Get file associated inum */
    inum = tfs_lookup(name);
    if (inum >= 0) {
        /* The file already exists */
        inode_t *inode = inode_get(inum);
        if (inode == NULL) {
            MUTEX_UNLOCK(&open_lock);
            return -1;
        }

        READ_LOCK(&inode->lock);
        
        /* Trucate (if requested) */
        if (flags & TFS_O_TRUNC) {
            if (inode->i_size > 0) {
                if (data_block_free(inode->i_data_block[0]) == -1) {
                    RW_UNLOCK(&inode->lock);
                    MUTEX_UNLOCK(&open_lock);
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
        RW_UNLOCK(&inode->lock);
    } else if (flags & TFS_O_CREAT) {
        /* The file doesn't exist; the flags specify that it should be created*/
        /* Create inode */
        inum = inode_create(T_FILE);
        if (inum == -1) {
            MUTEX_UNLOCK(&open_lock);
            return -1;
        }
        /* Add entry in the root directory */
        if (add_dir_entry(ROOT_DIR_INUM, inum, name + 1) == -1) {
            inode_delete(inum);
            MUTEX_UNLOCK(&open_lock);
            return -1;
        }
        offset = 0;
    } else {
        MUTEX_UNLOCK(&open_lock);
        return -1;
    }

    /* Finally, add entry to the open file table and
     * return the corresponding handle */
    MUTEX_UNLOCK(&open_lock);
    return add_to_open_file_table(inum, offset);

    /* Note: for simplification, if file was created with TFS_O_CREAT and there
     * is an error adding an entry to the open file table, the file is not
     * opened but it remains created */
}


int tfs_close(int fhandle) { return remove_from_open_file_table(fhandle); }

void *inode_get_block(inode_t *inode, int index) {
    void *block;

    if (index >= (BLOCK_SIZE / sizeof(int)) + INODE_INITIAL_DATA_BLOCKS) {
        return NULL;
    }

    if (index < INODE_INITIAL_DATA_BLOCKS) {
        block = data_block_get(inode->i_data_block[index]);
    } else {
        int *extended_block = data_block_get(inode->i_data_block[INODE_INITIAL_DATA_BLOCKS]);
        if (extended_block != NULL) {
            block = data_block_get(extended_block[index - INODE_INITIAL_DATA_BLOCKS]);
        } else {
            return NULL;
        }
    }

    return block;
}

int inode_block_alloc(inode_t *inode) {
    int next_ref = inode->block_count;
    int *extended_block;


    /* Normal Alloc type */
    if (next_ref <= INODE_INITIAL_DATA_BLOCKS) {
        inode->i_data_block[next_ref] = data_block_alloc();
    }

    /* Extended Alloc type */
    if (INODE_INITIAL_DATA_BLOCKS <= next_ref && next_ref < (BLOCK_SIZE / sizeof(int)) + INODE_INITIAL_DATA_BLOCKS) {
        extended_block = data_block_get(inode->i_data_block[INODE_INITIAL_DATA_BLOCKS]);
        if (extended_block == NULL) {
            return -1;
        } else {
            extended_block[next_ref - INODE_INITIAL_DATA_BLOCKS] = data_block_alloc();
        }
    }

    if (next_ref >= (BLOCK_SIZE / sizeof(int)) + INODE_INITIAL_DATA_BLOCKS) {
        return -2;
    }

    inode->block_count += 1;
    return 0;
}

int check_max_size_reached(inode_t *inode, size_t remain) {
    return (BLOCK_SIZE * BLOCK_SIZE + INODE_INITIAL_DATA_BLOCKS * BLOCK_SIZE <= inode->i_size + remain);
}

ssize_t tfs_write(int fhandle, void const *buffer, size_t to_write) {
    size_t remain;
    ssize_t ret = 0;


    open_file_entry_t *file = get_open_file_entry(fhandle);
    if (file == NULL) {
        return -1;
    }
    /* From the open file table entry, we get the inode */
    inode_t *inode = inode_get(file->of_inumber);
    if (inode == NULL) {
        return -1;
    }

    /* check locks */
    
    WRITE_LOCK(&inode->lock);


    /* Get offset */
    size_t start_block = (size_t)floor((double)file->of_offset / BLOCK_SIZE);
    size_t start_index = file->of_offset - (start_block * BLOCK_SIZE);
    size_t bytes_count;
    void *block;


    remain = to_write;

    while (remain > 0) {

        if (remain < BLOCK_SIZE) {
            if (remain + start_index > BLOCK_SIZE) {
                bytes_count = BLOCK_SIZE - start_index;
            }
            else {
                bytes_count = remain;
            }
        }
        else {
            bytes_count = BLOCK_SIZE;
        }

        if (check_max_size_reached(inode, remain) == 1) {
            break;
        }
        if ((int)(inode->block_count - 1) < (int)start_block) {
            int retValue = inode_block_alloc(inode);
            if (retValue == -1) {
                RW_UNLOCK(&inode->lock);
                return -1;
            }
            if (retValue == -2) {
                RW_UNLOCK(&inode->lock);
                return (ssize_t) (to_write - remain);
            }
        }

        block = inode_get_block(inode, (int)start_block);
        memcpy(block + start_index, buffer + (to_write - remain), (size_t)bytes_count);
        ret += (ssize_t)bytes_count;
        remain -= bytes_count;
        start_index = 0;
        inode->i_size += bytes_count;
        start_block++;
    }

    file->of_offset += (to_write - remain);
    // TO DO 
    RW_UNLOCK(&inode->lock);
    return (ssize_t)(to_write - remain);
}

ssize_t tfs_read(int fhandle, void *buffer, size_t len) {

    open_file_entry_t *file = get_open_file_entry(fhandle);
    size_t total_bytes_read = 0;
    if (file == NULL) {
        return -1;
    }
    void *block; // Loop throw all blocks

    /* From the open file table entry, we get the inode */
    inode_t *inode = inode_get(file->of_inumber);
    if (inode == NULL) {
        return -1;
    }

    /* check if lock is ok */

    READ_LOCK(&inode->lock);
    MUTEX_LOCK(&file->lock);

    /* offsets */
    size_t start_block = (size_t)floor((double)file->of_offset / BLOCK_SIZE);
    size_t start_index = file->of_offset - (start_block * BLOCK_SIZE);

    /* Determine how many bytes to read */
    size_t remain = len;
    if (remain + file->of_offset > inode->i_size) {
        remain = inode->i_size - file->of_offset;
    }
    while (remain > 0) {
        size_t bytes_read;
        if (remain < BLOCK_SIZE) {
            if (remain + start_index > BLOCK_SIZE) {
                bytes_read = BLOCK_SIZE - start_index;
            }
            else {
                bytes_read = remain;
            }
        }
        else{
            bytes_read = BLOCK_SIZE;
        }

        if (check_max_size_reached(inode, remain) == 1) {
            break;
        }

        block = inode_get_block(inode,(int)start_block);
        memcpy(buffer + total_bytes_read,block + start_index,bytes_read);
        remain -= bytes_read;
        total_bytes_read += bytes_read;
        start_index = 0;
        start_block++;
    }
    file->of_offset += total_bytes_read;
    MUTEX_UNLOCK(&file->lock);
    RW_UNLOCK(&inode->lock);
    return (ssize_t)total_bytes_read;
}



int tfs_close_files(int tfs_file_handle, FILE* ext_file) {
    if (tfs_close(tfs_file_handle)) {
        return -1;
    }
    if (fclose(ext_file)) {
        return -1;
    }
    return 0;
}

int tfs_copy_to_external_fs(char const *source_path, char const *dest_path) {
    int tfs_file_handle;
    ssize_t bytes_read;
    ssize_t remain;
    FILE *ext_file;
    open_file_entry_t *tfs_file;
    char buffer[BUFFER_SIZE];
    /* Open TFS file and get handle */
    tfs_file_handle = tfs_open(source_path, 0);

    if (tfs_file_handle == -1) {
        return -1;
    }

    /* Open external file */
    ext_file = fopen(dest_path, "w");

    if (ext_file == NULL) {
        tfs_close(tfs_file_handle);
        return -1;
    }

    /* Get TFS open file entry */
    tfs_file = get_open_file_entry(tfs_file_handle);

    if (tfs_file == NULL) {
        tfs_close_files(tfs_file_handle, ext_file);
        return -1;
    }

    /* From the open file table entry, get the inode */
    inode_t *inode = inode_get(tfs_file->of_inumber);
    if (inode == NULL) {
        tfs_close_files(tfs_file_handle, ext_file);
        return -1;
    }

    remain = (ssize_t)inode->i_size;

    do {
        bytes_read = tfs_read(tfs_file_handle, buffer, BUFFER_SIZE);
        if (bytes_read < 0) {
            return tfs_close_files(tfs_file_handle, ext_file);
        }
        if (fwrite(buffer, sizeof(char), (unsigned) bytes_read, ext_file) == -1) {         
            tfs_close_files(tfs_file_handle, ext_file);
            return -1;
        }
        remain -= bytes_read;
    } while(remain > 0);
    if (tfs_close_files(tfs_file_handle, ext_file)) {
        return -1;
    }
    return 0;
}
