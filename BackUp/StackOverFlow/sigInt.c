#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

void signal_handler(int signum) {
	printf("Teste\n");
	// return ;
}

int main() {
	char a[100];

	for (int i = 0; i < 100; i++) {
		a[i] = '1';
	}

	signal(SIGINT,signal_handler);
	while(1) {
		printf("IGNORE CTRL+C + String: %s\n",a);
		fflush(stdout);
		fgets(a,100,stdin);
		sleep(1);
	}
	return 0;
}
