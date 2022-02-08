#include "common.h"

//FAILSAFE OK
ssize_t read_from_pipe(int rx, void* buffer, size_t size) {
    ssize_t ret;
    do {
        ret = read(rx, buffer, size);
    } while(ret == -1 && errno == EINTR); // Retry system call
    if (ret == -1) {
        fprintf(stderr, "[READ_ERROR]: %s \n", strerror(errno));
    }
    return ret;
}

//FAILSAFE OK
int send_to_pipe(int tx, void *str, size_t size) {
    size_t written = 0;
    ssize_t ret;
    while (written < size) {
        do {
            ret = write(tx, str + written, size - written);
        } while(ret == -1 && errno == EINTR); // Retry system call

        if (ret == -1) {
            fprintf(stderr, "[WRITE_ERROR]: %s \n", strerror(errno));
            return -1;
        }
        written += (size_t)ret;
    }
    return 0;
}

//FAILSAFE OK
CMD* create_empty_command() {
    CMD* command = malloc(sizeof(CMD));
    if (command == NULL) {
        fprintf(stderr, "[CREATE_COMMAND]: Could not allocate memory \n");
        exit(EXIT_FAILURE);
    }
    command->op_code = NULL;
    command->session_id = NULL;
    command->pipe_name = NULL;
    command->file_name = NULL;
    command->flags = NULL;
    command->file_handle = NULL;
    command->len = NULL;
    command->buffer = NULL;

    return command;
}

//FAILSAFE OK
ssize_t get_command_size(CMD *command) {

    if (command->op_code == NULL) {
        fprintf(stderr, "[COMMAND_UTILS]: Could not get command size \n");
        return -1;
    }

    switch (*(command->op_code))
    {
        case TFS_OP_CODE_MOUNT:
            return 1 + SIZE_OF_NAMED_PIPE;
        case TFS_OP_CODE_UNMOUNT:
            return 1 + sizeof(int);
        case TFS_OP_CODE_OPEN:
            return 1 + (size_t) sizeof(int) + SIZE_OF_NAMED_PIPE + sizeof(int);
        case TFS_OP_CODE_CLOSE:
            return 1 + (size_t) (sizeof(int) * 2);
        case TFS_OP_CODE_WRITE:
            if (command->len == NULL) {
                fprintf(stderr, "[COMMAND_UTILS]: Could not get command size \n");
                return -1;
            }
            return (ssize_t)(1 + (size_t)(sizeof(int) * 2) + sizeof(size_t) + *(command->len));
        case TFS_OP_CODE_READ:
            return 1 + ((size_t)sizeof(int) * 2) + sizeof(size_t);
        case TFS_OP_CODE_SHUTDOWN_AFTER_ALL_CLOSED:
            return 1 + sizeof(int);
        default:
            break;
    }
    fprintf(stderr, "[COMMAND_UTILS]: Could not get command size \n");
    return -1;
}

//FAILSAFE NaN
void* encode_simple(void* current, void const* param, size_t size) {
    if (param != NULL) {
        memcpy(current, param, size);
        return (current + size);
    }
    return current;
}

//FAILSAFE NaN
void* encode_string(void* current, void const* param, size_t max_size) {
    void* current_position = current;

    if (param != NULL) {
        size_t string_size = sizeof(char) * strlen((char*)param);

        memcpy(current, param, string_size);
        current_position += string_size;

        if (string_size < max_size) {
            memset(current_position, '\0', max_size - string_size);
            current_position += (max_size - string_size);
        }
    }

    return current_position;
}

//FAILSAFE OK
void* encode_command(CMD *command) {
    void* encoded_command, *current_position;
    ssize_t expected_size = get_command_size(command);

    if (expected_size == -1) {
        free(command);
        return NULL;
    }

    encoded_command = malloc((size_t)expected_size);

    if (encoded_command == NULL) {
        fprintf(stderr, "[ENCODE_COMMAND]: Could not allocate memory \n");
        exit(EXIT_FAILURE);
    }

    current_position = encoded_command;
    // Encode command by steps

    // OP_CODE
    current_position = encode_simple(current_position, command->op_code, sizeof(char));
    // SESSION ID
    current_position = encode_simple(current_position, command->session_id, sizeof(int));
    // PIPE NAME
    current_position = encode_string(current_position, command->pipe_name, SIZE_OF_NAMED_PIPE);
    // FILE NAME
    current_position = encode_string(current_position, command->file_name, MAX_FILE_NAME);
    // FLAGS
    current_position = encode_simple(current_position, command->flags, sizeof(int));
    // FILE HANDLE
    current_position = encode_simple(current_position, command->file_handle, sizeof(int));
    // LENGTH
    current_position = encode_simple(current_position, command->len, sizeof(size_t));

    if (command->len != NULL) {
        encode_simple(current_position, command->buffer, *(command->len));
    }

    free(command);

    return encoded_command;
}

//FAILSAFE OK
int send_command(int tx, CMD* command) {
    ssize_t command_size = get_command_size(command);
    if (command_size == -1) {
        free(command);
        fprintf(stderr, "[SEND_COMMAND]: Could not send command \n");
        return -1;
    }

    void *buffer = encode_command(command);

    if (buffer == NULL) {
        fprintf(stderr, "[SEND_COMMAND]: Could not send command \n");
        return -1;
    }

    if (send_to_pipe(tx, buffer, (size_t)command_size) == -1) {
        fprintf(stderr, "[SEND_COMMAND]: Could not send command \n");
        free(buffer);
        return -1;
    }

    free(buffer);
    return 0;
}
