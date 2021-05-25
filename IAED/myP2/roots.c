/* Projeto: Hierarchical storage system (IAED 20/21) *
 * Estudante: José Cutileiro                         *
 * Numero de estudante: 99097                        */


/* Note: This file contains aux functions */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "proj2.h"

/*** memory check ***/

void
no_memory() {
	printf(No_Mem);
	exit(-1);
}


/*********** setf ************/

int
command_split(char *command) {
	int i;
	for (i = 0; command[i] != ' '; i++);
	return i;
}

/*********** listf ***********/

/* MERGE SORT */

int
less(char *a, char *b) {
	if (strcmp(a, b) < 0)
		return True;
	return False;
}

void
merge(char **a, int l, int m, int r) {
	char **aux = (char **) malloc(sizeof(char *) * (r + 1));
	int i, j, k;
	if (!aux)
		no_memory();
	for (i = m + 1; i > l; i--)
		aux[i - 1] = a[i - 1];
	for (j = m; j < r; j++)
		aux[r + m - j] = a[j + 1];
	for (k = l; k <= r; k++)
		if (less(aux[j], aux[i]))
			a[k] = aux[j--];
		else
			a[k] = aux[i++];
	free(aux);
}

void
mergesort(char **a, int l, int r) {
	int m = (r + l) / 2;
	if (r <= l)
		return;
	mergesort(a, l, m);
	mergesort(a, m + 1, r);
	merge(a, l, m, r);
}

/* delf//main program */

/* Check if something more than the command  *
 * was written by the user. Ok if True       */
int
Command_check(char *command) {
	if (strlen(command))
		return True;
	return False;
}

/*********** Main program ***********/

int
UI_Encoder() {
	char Input[10];
	scanf("%s", Input);
	return Input[0] * Input[2];
}

char *
CommandReader() {
	int i = 0, j = 50;
	char *command, let;

	let = getchar();
	command = (char *) malloc(sizeof(char *) * (j));
	if (!command)
		no_memory();
	while (let != '\n' && let != EOF && let != '\0') {
		command[i] = let;
		i++;
		let = getchar();
		if (i % 49 == 0) {
			j += 50;
			command = (char *) realloc(command, sizeof(char) * (j));
			if (!command)
				no_memory();
		}
	}

	command[i] = '\0';

	return command;
}
