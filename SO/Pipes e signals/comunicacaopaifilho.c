#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>

/* Descricão: Escrever para uma entrada da pipe
e apanhar a escrita do outro lado provocando uma leitura */

#define BUFFER_SIZE 1024

#define PIPE(fds)                           \
                if (pipe(fds) != 0) {  \
                    exit(0);           \
                }                      \

char msg[] = "Vamos usar pipes";

// Ler e escrever seguidamente
int main() {
    char buffer[BUFFER_SIZE];
    int fds[2], pid_filho;

    PIPE(fds);

    if (fork() == 0) {
        close(fds[1]);
        read(fds[0],buffer,strlen(msg));
        printf("%s\n",buffer);
        exit(0);
    }
    else {
        close(fds[0]);
        write(fds[1],msg,strlen(msg));
        pid_filho = wait();
    }
    return 0;
}