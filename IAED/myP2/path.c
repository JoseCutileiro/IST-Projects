/* Projeto: Hierarchical storage system (IAED 20/21) *
 * Estudante: José Cutileiro                         *
 * Numero de estudante: 99097                        */

/* Description: This file contains all operations that work *
 * with PATHS and LINKS (PATH struct is defined in proj2.h) */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "proj2.h"


/* Term_Init() -> Create a new Path and initializes all *
 * components. This way every initial state is the same */
link
Term_Init() {
	link Terminal = (link) malloc(sizeof(PATH));
	Terminal->nexts = (link *) malloc(sizeof(link) * 0);
	Terminal->associated = 0;
	Terminal->Value = NULL;
	Terminal->Name = NULL;
	return Terminal;
}

/* After updating how many paths are associated with the terminal  *
 * we need to update the info inside terminal associations (nexts) */
link
Term_Update(link Terminal) {
	Terminal->nexts =
		(link *) realloc(Terminal->nexts,
				 sizeof(link) * Terminal->associated);
	return Terminal;
}
