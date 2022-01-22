#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>

/* exprimentar substituição de saidas e entradas */

#define BUFFER_SIZE 1024

#define PIPE(fds)                           \
                if (pipe(fds) != 0) {  \
                    exit(0);           \
                }  

char msg[] = "Testar pipes e coisas";
char buffer[BUFFER_SIZE];

int main() {
    int fds[2], pid_filho;
    PIPE(fds);
    if (fork() == 0) {
        /* filho */
        close(0);    // Liberta stdin   
        dup(fds[0]); // pipe 0 passa para pos 0
        close(fds[0]);
        close(fds[1]);
        // Leitura
        read(0,buffer,strlen(msg));
        printf("%s\n",buffer);
        exit(0);
    }
    else {
        /* pai */ 
    write(fds[1],msg,strlen(msg));
    pid_filho = wait();
    }
}