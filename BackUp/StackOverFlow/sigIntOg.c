#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>

void signal_handler(int signum) {

}

int main(int argc, char *argv[]) {
	char a[100];
	signal(SIGINT, signal_handler);
	while(1) {
		printf("OLA\n");
		fflush(stdout);
		fgets(a,100,stdin);
		sleep(1);
	}
	return 0;
}
