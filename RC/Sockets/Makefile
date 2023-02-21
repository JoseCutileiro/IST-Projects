CC=gcc

CFLAGS=-g
COMMON_OBJS = common.o

all: $(COMMON_OBJS) client server

common.o: common.h common.c
	$(CC) $(CFLAGS) -c common.c

client: tcpclient.c $(COMMON_OBJS)
	$(CC) $(CFLAGS) -o client tcpclient.c $(COMMON_OBJS)

server: tcpserver.c $(COMMON_OBJS)
	$(CC) $(CFLAGS) -o server tcpserver.c $(COMMON_OBJS)

clean:
	rm -rf *.o *dSYM client server