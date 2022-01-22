#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

/* Descrição, leitura e escrita através de pipes em ciclo,
não tem output. É apenas um exemplo introdutório */

#define BUFFER_SIZE 1024

#define PIPE(fds)                           \
                if (pipe(fds) != 0) {  \
                    exit(0);           \
                }                      \

char msg[] = "Vamos usar pipes";

// Ler e escrever seguidamente
int main() {
    char buffer[BUFFER_SIZE];
    int fds[2];

    PIPE(fds);

    for (;;) {
        write(fds[1],msg,sizeof(msg));
        read(fds[0],buffer,sizeof(buffer));
    }
    return 0;
}