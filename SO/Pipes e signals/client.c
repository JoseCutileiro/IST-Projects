/* cliente: Usar named pipes */

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include<string.h>

#define BUFFER_SIZE 1024


#define OPEN_SERVER                                     \
             fserv = open("/tmp/servidor",O_WRONLY);    \
             if (fserv < 0) {                           \
                 exit(1);                               \
             }                                          \

#define OPEN_CLIENT                                   \
             fcli = open("/tmp/cliente",O_RDONLY);    \
             if (fcli < 0) {                          \
                 exit(1);                             \
             }                                        \

void produzMsg(char buf[]) {
    strcpy(buf,"Mensagem teste");
}

void tratarMsg(char buf[]) {
    printf("Recebido: %s\n",buf);
}

int main() {
    int fcli, fserv;
    char buf[BUFFER_SIZE];
    OPEN_SERVER;
    OPEN_CLIENT;
    produzMsg(buf);
    write(fserv,buf,strlen(buf));
    read(fcli,buf,strlen(buf));
    tratarMsg(buf);
    close(fserv);
    close(fcli);
    return 0;
}