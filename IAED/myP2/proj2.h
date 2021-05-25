/* Projeto: Hierarchical storage system (IAED 20/21) *
 * Estudante: José Cutileiro                         *
 * Numero de estudante: 99097                        */

#ifndef _PROJ2_
#define _PROJ2_


/**** Encoder ****/

/* In order to avoid using strcmp each time user insert any info        *
 * I decided to code all tasks using the first(a) and second(b) letter  *
 * a*b (numbers were selected using ASCII code)                         *
 * (Note: this code only works in this specific problem for a different *
 * problem we would need a new way of coding the user input)            */

enum UI_Decoder { Uhelp = 104 * 108, Uquit = 113 * 105,
	Uset = 115 * 116, Uprint = 112 * 105,
	Ufind = 102 * 110, Ulist = 115 * 108,
	Usearch = 115 * 97, Udelete = 100 * 108
};


/************ Path struct ***********/

typedef struct path {
	char *Name, *Value;
	struct path **nexts;
	long int associated;
} *link;

typedef struct path PATH;

/************ Defenitions (Consts) ***********/

/*** Initial values ***/

#define Initial_Depth 30  /* This value is big so dont need  *
							 to realloc many time as we will *
							 if this value was smaller       */

/*** BOOL ***/

#define False 0
#define True 1

/*** helpf ***/

#define HELP "\
help: Imprime os comandos disponíveis.\n\
quit: Termina o programa.\n\
set: Adiciona ou modifica o valor a armazenar.\n\
print: Imprime todos os caminhos e valores.\n\
find: Imprime o valor armazenado.\n\
list: Lista todos os componentes imediatos de um sub-caminho.\n\
search: Procura o caminho dado um valor.\n\
delete: Apaga um caminho e todos os subcaminhos.\n"

/*** exceptions ***/

#define Not_Found "not found\n"
#define No_data "no data\n"
#define No_Mem "no memory\n"

/*** memory check ***/

void no_memory();

/*********** Path OPERATIONS (path.h) ***********/

link Term_Init();		/* Init a new link to path */

link Term_Update(link Terminal);	/* Update link memory info */


/*********** AUX FUNCTIONS (roots.h) ************/

/* Setf */

int command_split(char *command);

/* listf */

int less(char *a, char *b);

void merge(char **a, int l, int m, int r);

void mergesort(char **a, int l, int r);

/* delf */

int Command_check(char *command);

/* Main */

int UI_Encoder();		/* Encodes user first argument */

char *CommandReader();		/* Get user input to the system memory *
				 * Note: The length of the command is limited only *
				 * by the machine                                  */


#endif
