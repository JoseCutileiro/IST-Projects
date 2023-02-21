#include "common.h"

int main(int argc, char **argv) {
	int listenfd, connfd, n;
	struct sockaddr_in servaddr;
	uint8_t buff[MAXLINE + 1];
	uint8_t recvline[MAXLINE + 1];

	if ((listenfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
		err_n_die("Could not create socket");
	}

	bzero(&servaddr, sizeof(servaddr));
	servaddr.sin_family = AF_INET;
	servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
	servaddr.sin_port = htons(SERVER_PORT);

	// Não esquecer do bind & listen
	// Eles funcionam separadamente
	// Mas geralmente não os separamos
	if ((bind(listenfd, (SA*) &servaddr , sizeof(servaddr))) < 0) {
		err_n_die("Bind error.");
	}

	if ((listen(listenfd, 10)) < 0) {
		err_n_die("Listen error");
	}

	// Loop que aceita as conexões e os pedidos:

	for (;;) {
		struct sockaddr_in addr;
		socklen_t addr_len;

		// Devolve um fd para a conexão 
		printf("waiting for a connection on port %d\n",SERVER_PORT);
		fflush(stdout);
		connfd = accept(listenfd, (SA*) NULL, NULL);

		// Reset no que recebeu (se recebeu algo antes)
		memset(recvline, 0, MAXLINE);

		// Ler a mensagem do cliente:
		while ((n = read(connfd,recvline, MAXLINE - 1)) > 0) {
			fprintf(stdout, "\n%s\n\n%s", bin2hex(recvline,n), recvline);

			// DETECT EOM (end of message)
			if (recvline[n-1] == '\n') {
				break;
			}

			memset(recvline,0, MAXLINE);
		}

		if (n < 0) {
			err_n_die("[OS ERROR]: Cannot read");
		}

		// Enviar resposta:
		snprintf((char*)buff,sizeof(buff),"HTTP/1.0 200 OK \r\n\r\nHELLO FROM SERVER");

		// Não esquecer: Dever verificar erros de write and close
		write(connfd, (char*)buff,strlen((char*)buff));
		close(connfd);
	}


} 