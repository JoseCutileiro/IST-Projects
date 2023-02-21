/*
Code by Jose Cutileiro
Start date: 19/11
End Date: ??/??
*/

#include "common.h"

/*
void err_n_die(const char *fmt,...) {
	printf("ABORT ERROR: %s\n", fmt);
	exit(1);
}
*/

int main(int argc, char ** argv) {
	int sockfd, n;
	int sendbytes;
	struct sockaddr_in servaddr;
	char sendline[MAXLINE];
	char recvline[MAXLINE];

	/* Usage check */
	if (argc != 2) {
		err_n_die("Program need IP address from server.\nUsage: %s <server address>",argv[0]);		
	}

	/* Create a socket */
	if ( (sockfd = socket(AF_INET, SOCK_STREAM,0)) < 0) {
		err_n_die("Error while creating socket!");
	}
	// Zero out the address 
	bzero(&servaddr, sizeof(servaddr));
	servaddr.sin_family = AF_INET;					/* Familia de endereços do servidor */
	servaddr.sin_port = htons(SERVER_PORT_BROWSER);			/* Server port */



	printf("CONVERTENDO STRING PARA BINÁRIO...\n");
	// Converte representação string do endereço de IP para binário 
	// "1,2,3,4" - > "[1,2,3,4]"
	if (inet_pton(AF_INET, argv[1], &servaddr.sin_addr) <= 0) {
		err_n_die("inet_pton error for %s",argv[1]);
	}



	printf("FAZER CONEXÃO\n");
	// Conectar ao endereço que acabámos de traduzir
	if (connect(sockfd, (SA *) &servaddr, sizeof(servaddr)) < 0) {
		err_n_die("Can't connect to server...");
	}


	printf("A CONSTRUIR A STRING QUE VAMOS ENVIAR\n");
	/*
	Agora que estamos conectados vamos tentar contruir uma mensagem
	sendbytes = strlen(sendline): Confirmar bytes que irei enviar
	*/ 
	sprintf(sendline, "GET / HTTP/1.1\r\n\r\n");
	sendbytes = strlen(sendline);



	printf("ENVIAR PARA O SERVER...\n\n");
	/* 
	Enviar concretamente as coisas pelo server
	*/
	if (write(sockfd, sendline, sendbytes) != sendbytes) {
		err_n_die("error while writing to socket");
	}

	/*
	VER E TRATAR A RESPOSTA DO SEVIDOR
	*/

	// clean the buffer
	memset(recvline,0,MAXLINE);


	printf("RECEBER CENAS DO SERVER\n");
	while ( (n = read(sockfd,recvline,MAXLINE-1)) > 0) {
		printf("%s", recvline);
	}
	printf("\n");

	if (n < 0) {
		err_n_die("error while reading");
	}

	//sucess
	printf("SUCESSO :)");
	exit(0);
} 

