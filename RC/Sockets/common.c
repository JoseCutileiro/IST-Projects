#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

void err_n_die(const char *fmt,...) {
	printf("ABORT ERROR: %s\n", fmt);
	exit(1);
}

char* bin2hex(const unsigned char  *input, size_t len) {
	char *result;
	char *hexdigits = "0123456789ABCDEF";

	if (input == NULL || len <= 0) {
		return  NULL;
	}

	int resultlen = (len*3) + 1;

	result = malloc(resultlen);
	bzero(result,resultlen);

	for (size_t i = 0; i < len; i++) {
		result[i*3] = hexdigits[input[i] >> 4];
		result[(i*3) + 1] = hexdigits[input[i] & 0x0F];
		result[(i*3) + 2] = ' ';
	}

	return result;
}