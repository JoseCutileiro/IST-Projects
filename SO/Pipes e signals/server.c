/* Server: Usar named pipes */ 

/* Só vai receber mensagem SE o servidor estiver aberto */

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define TAMMSG 1000

void trataPedido(char buf[]) {
    // Faz o que for preciso no contexto
}


int main() {
    int fcli, fserv, n;
    char buf[TAMMSG];

    // Garantir que não está lá nada por esquecimento
    unlink("/tmp/servidor");
    unlink("/tmp/cliente");

    if (mkfifo("/tmp/servidor",0777) < 0) {
        exit(1);
    }
    if (mkfifo("/tmp/cliente",0777) < 0) {
        exit(1);
    }
    
    fserv = open("/tmp/servidor",O_RDONLY);
    fcli = open("/tmp/cliente",O_WRONLY);

    for (;;) {
        n = read(fserv,buf,TAMMSG);
        if (n<=0) {
            break;
        }
        trataPedido(buf);
        n = write(fcli,buf,TAMMSG);
    }
    close(fserv);
    close(fcli);
    unlink("/tmp/servidor");
    unlink("/tmp/cliente");
}