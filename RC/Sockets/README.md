# Programação com Sockets (um cheirinho)
Learning to play with sockets on unix

# Introdução

- IPC: Um programa que comunica com outros programas
- Sockets: Permitem que esta comunicação se dê em qualquer parte do mundo com acesso \
  a rede de internet

# Aula 1: Lado do cliente
### Ver o código do tcpclient.c

Mini webrowser, sem a parte da renderização do contéudo

### O que é um socket?

É basicamente um edge point (tipo um file)
```c
/* Create a socket */
if ( (sockfd = socket(AF_INET, SOCK_STREAM,0)) < 0) {
	err_n_die("Error while creating socket!");
}

Atributos {
	AF_INET: Address family internet
	SOCK_STREAM: Stream socket
	0: USE TCP
}
/* 
Notas: SOCK_STREAM vs SOCK_DATAGRAM
SOCK DATAGRAM: Pacotes unidirecionais
SOCK STRAM: Enviar para cá e para lá
*/
```

> __Função htons__\
> Ver se é big endian ou little endian e converter como deve de ser \
> htons = "host to network, short"

### Preparar envio de mensagens
```c
sprintf(sendline, "GET / HTTP/1.1\r\n\r\n");

GET /   <-> INDEX page

using HTTP/1.1	(version)

\r\n\r\n: 	End of my message
```

Nota: 
AF_INET: Só funciona para servidores com protocolo IPV4

IPV4 vs IPV6

# Aula 2: Ver o lado do servidor

Usar sockets para aceitar ligações/pedidos de clientes

### Common.c && Common.h 

> Simplificar imports e coisas chatas tudo para um ficheiro simples
> Entre elas:
> 	err_n-die: Mensagem de erro e termianar o programa
> 	bin2hex: Converter binário para hexa

### Relembrar: Como criar um socket?

> Um socket é basicamente um ficheiro \
> pelo menos podemos imaginar algo \
> semelhante.
> É muito fácil criar um socket, \
> mas para isso temos que pedir ao SO que \
> trate da parte de alocar os recursos \
> que precisamos para isso.

Como é que isso se faz?
```c 
	if ((listenfd = socket(AF_INET, SOCK_STREAM,0)) < 0) {
		error_function(ERROR_MESSAGE);
	}
```

SOCK STREAM: Os dados não estão a ir para o próprio disco, 
			 mas estão sim a ir para um certo cliente/servidor.

### INICIALIZAR SERVIDOR
```c
	bzero(&servaddr, sizeof(servaddr));
	servaddr.sin_family = AF_INET;
	servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
	servaddr.sin_port = htons(SERVER_PORT);

/*
Um servidor não se conecta a um cliente mas aceita conexões

Eu sou um endereço de internet: AF_INET (ipv4)
INADDR_ANY: Respondo a qualquer tipo de coisa
SERVER_PORT
*/
```

### Nota interessante sobre o SERVER_PORT

> O sistema operativo é um bocado chatinho para saber quem pode usar \
> o port 80. Isto porque ficou estipulado que a maioria dos servidores \
> usa o port 80 para fazer as conexões. Por isso se quiseres fazer um \
> servidor não é recomendável usar o port 80.

### Loop no servidor: O que permite as conexões

```c 
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

		// Não esquecer: Deves verificar erros de write and close
		write(connfd, (char*)buff,strlen((char*)buff));
		close(connfd);
	}
```

### Accept
> Espera que alguém se conecte ao servidor. \
> Quando isso acontecer cria um novo socket \
> especifico para aquela comunicação

### Perspetiva do cliente:
localhost:18000
Tem uma página a dizer 'Hello from server'

### Analizar a resposta obtida (do lado do servidor):

> Código hexadecimal: Termina com 0D 0A 0D 0A \
> (\r\n\r\n) \
> \
> GET REQUEST \
> host \
> keep alive - O cliente vai continuar a fazer pedidos

```
Nota:
Quando estamos num browser ...
O cliente faz dois pedidos por default

1. GET /
2. GET /favicon

O nosso server default a única coisa que faz 
é responder  Hello from server, portanto 
quando o  favicon for carregado ele não vai
fazer nada (fica o favicon null default)
```
