/* Projeto: Hierarchical storage system (IAED 20/21) *
 * Estudante: José Cutileiro                         *
 * Numero de estudante: 99097                        */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "proj2.h"

/********** User interface **********/

/***** HELP *****/

/* List all commands *
 *   (inform user)   */
static void
helpf() {
	printf(HELP);
}

/***** SET *****/

/* When Sub is not in memory, we need *
 * to inserted                        */
link
not_found(link prev, char *Sub) {
	link new_link;
	char *name;

	new_link = Term_Init();
	prev->associated++;
	prev = Term_Update(prev);
	name = malloc(strlen(Sub) + 1);
	if (!name)
		no_memory();
	strcpy(name, Sub);
	new_link->Name = name;
	prev->nexts[prev->associated - 1] = new_link;

	return new_link;

}

/* A Sub path of path will be inserted in prev->nexts *
 * when there is no more path to read prev->value     *
 * will change to 'value'. Note: prev represents      *
 * the previous link                                  */
void
insert_path(link prev, char *path, char *value) {
	char *Sub = strtok(path, "/"), *new_value;
	int i, found;

	while (Sub != NULL) {
		for (i = 0, found = False;
		     i < prev->associated && found == False; i++) {
			if (!strcmp(prev->nexts[i]->Name, Sub)) {
				prev = prev->nexts[i];
				found = True;
			}
		}
		if (!found) {
			prev = not_found(prev, Sub);
		}
		Sub = strtok(NULL, "/");
	}
	new_value = malloc(strlen(value) + 1);
	if (!new_value)
		no_memory();
	strcpy(new_value, value);
	prev->Value = new_value;
}

/* Read a command, choosing the first part of  *
 * the command to be the "path" and the second *
 * to be the "value"                           */
static void
setf(char *command, link prev) {
	int i;
	char *path, *value;
	i = command_split(command);
	command[i] = '\0';
	path = command;
	value = command + i + 1;
	insert_path(prev, path, value);
}

/********** Mem_printf ***********/

/* About int *info: In order to avoid unnecessary string          *
 * copies, I use a group of ints witch represent the path it self *
 * example: info: [1,0,2]                                         *
 * wanted path: prev->nexts[1]->nexts[0] ->nexts[2]               */

/* until 'depth' is not 0 we will keep printing names       *
 * when we reach 0 we print the value of the completed path */
void
printing(link prev, int *info, int depht) {
	int i = 0;
	while (depht > 0) {
		prev = prev->nexts[info[i]];
		printf("/%s", prev->Name);
		i++;
		depht--;
	}
	printf(" %s\n", prev->Value);
}

/* We need to find all paths that are associated with a certain  *
 * value, (value != NULL) (initial value of path is NULL)        */
void
Mem_printf(link terminal, link prev, int *info, int depht) {
	int i;

	for (i = 0; i < prev->associated; i++) {
		info[depht] = i;
		if (prev->nexts[i]->Value != NULL)
			printing(terminal, info, depht + 1);
		Mem_printf(terminal, prev->nexts[i], info, depht + 1);
	}
}

/*********** findf ***********/

/* Once there is no more path, we have *
 * reach our solutio, so we print it   */
void
find_path_end(link prev) {
	if (prev->Value == NULL)
		printf(No_data);
	else
		printf("%s\n", prev->Value);

}

/* index == -1 => not in memory     *
 * index != -1 => we found the path */
int
find_path_explorer(link prev, int index, char *Sub) {
	int i;
	for (i = 0; i < prev->associated; i++) {
		if (!strcmp(prev->nexts[i]->Name, Sub)) {
			index = i;
			i = prev->associated;
		}
	}
	return index;
}

int
findf(link terminal, char *command) {
	char *Sub = NULL;
	link prev;
	int index = -1, time = 1;
	prev = terminal;
	Sub = strtok(command, "/");
	while (Sub != NULL || time) {
		if (!time)
			Sub = strtok(NULL, "/");

		if (Sub == NULL) {
			find_path_end(prev);
			return 0;
		}
		index = find_path_explorer(prev, -1, Sub);
		time = 0;
		if (index == -1) {
			printf(Not_Found);
			return -1;
		} else
			prev = prev->nexts[index];
	}
	return 0;
}

/*********** listf ***********/

/* prev (Terminal), first I used a Path to group *
 * all names that are next of prev, then I       *
 * aplly mergesort to order them as I wanted    */
void
listing(link prev) {
	char **Paths = (char **) malloc(sizeof(char *) * prev->associated);
	int i, j;
	if (!Paths)
		no_memory();
	for (i = 0; i < prev->associated; i++) {
		Paths[i] =
			(char *) malloc(sizeof(char) *
					(strlen(prev->nexts[i]->Name) + 1));
		if (!Paths[i])
			no_memory();
		strcpy(Paths[i], prev->nexts[i]->Name);
	}
	mergesort(Paths, 0, i - 1);
	for (j = 0; j < i; j++) {
		printf("%s\n", Paths[j]);
		free(Paths[j]);
	}
	free(Paths);
}

/* list <path> or list: first we need to find the path    *
 * (we need to know if path is in memory or not too)      *
 * after that we list all path subdirectories using ASCII *
 * alphabetical order using mergesort (call listing)      */
void
listf(link prev, char *command) {
	char *Sub = NULL;
	int found = True, i;
	if (command[-1] == ' ')
		Sub = strtok(command, "/");
	while (Sub != NULL) {
		found = False;
		for (i = 0; i < prev->associated && !found; i++) {
			if (!strcmp(prev->nexts[i]->Name, Sub)) {
				prev = prev->nexts[i];
				found = True;
			}
		}
		Sub = strtok(NULL, "/");
	}
	if (!found)
		printf(Not_Found);
	else
		listing(prev);
}

/*********** searchf ***********/

/* Once found, print the path */
void
search_sucess(link prev, int *path_info, int depht) {
	int i = path_info[depht];

	if (i != -1) {
		printf("/%s", prev->nexts[i]->Name);
		search_sucess(prev->nexts[i], path_info, depht + 1);
	} else
		printf("\n");
}

/* Once again we use int *path_info to retain all necessary        *
 * information about path, this way we can print the right path    *
 * without wasting time or memory. Search prev->Value == Value     */
int
searchf(link terminal, link prev, char *value, int *path_info, int depht) {
	int i, con = prev->associated, flag = 0;
	char *cmp = prev->Value;
	path_info[depht] = -1;

	if (cmp != NULL) {
		if (!strcmp(cmp, value)) {
			search_sucess(terminal, path_info, 0);
			return 1;
		}
	}

	for (i = 0; i < con && !flag; i++) {
		path_info[depht] = i;
		flag = searchf(terminal, prev->nexts[i], value, path_info,
			       depht + 1);
	}
	if (depht == 0 && flag == 0)
		printf(Not_Found);

	return flag;
}

/*********** delf ***********/

/* NOTE: Instead of deleting, we keep all deleted items inside *
 * a Delay deletion link, this way, if we want we can          *
 * recover any of the deleted links. Note: The act of          *
 * deleting the links from memory is on 'quitf'                */

/* Send one selected Path (and sub paths) to purgatory */
void
deleting(link Parent, link prev, link Delay_delete) {
	int i;
	for (i = 0; i < Parent->associated; i++) {
		if (!strcmp(Parent->nexts[i]->Name, prev->Name)) {
			Delay_delete->associated++;
			Delay_delete = Term_Update(Delay_delete);
			Delay_delete->nexts[Delay_delete->associated - 1] =
				prev;
			break;
		}
	}
	Parent->associated--;
	for (; i < Parent->associated; i++) {
		Parent->nexts[i] = Parent->nexts[i + 1];
	}
}

/* Send the main Terminal to purgatory */
link
delete_all(link Terminal, link Delay_delete) {
	link new_term;
	Delay_delete->associated++;
	Delay_delete = Term_Update(Delay_delete);
	Delay_delete->nexts[Delay_delete->associated - 1] = Terminal;
	new_term = Term_Init();
	return new_term;
}

/* Check witch link user want to send to purgatory */
link
delf(link Terminal, link prev, link Delay_delete, char *command, int OK) {
	char *Sub = NULL;
	int found, i;
	link Parent;

	if (!OK)
		return delete_all(prev, Delay_delete);
	Sub = strtok(command, "/");
	while (Sub != NULL && command[-1] == ' ') {
		for (i = 0, found = False; i < prev->associated; i++) {
			if (!strcmp(prev->nexts[i]->Name, Sub)) {
				Parent = prev;
				prev = prev->nexts[i];
				found = True;
			}
		}
		Sub = strtok(NULL, "/");
	}
	if (!found)
		printf(Not_Found);
	else
		deleting(Parent, prev, Delay_delete);
	return Terminal;
}

/*********** quitf ***********/

/* Free all memory used to sustain 'link' */
void
clean(link prev) {
	int i = 0;
	free(prev->Name);
	free(prev->Value);
	for (i = 0; i < prev->associated; i++) {
		clean(prev->nexts[i]);
	}
	free(prev->nexts);
	free(prev);
}

/* Ready to quit the program               *
 * Note: Delay deletion will be no deleted */
void
quitf(int *path_data, char *command, link terminal, link Delay_delete) {
	free(path_data);
	free(command);
	clean(terminal);
	clean(Delay_delete);
}

/********** Main program **********/

int
main() {
	int decode, *path_data, OK;
	char *command;
	link terminal = Term_Init(), Delay_delete = Term_Init();

	decode = UI_Encoder();
	path_data = (int *) malloc(sizeof(int) * Initial_Depth);
	if (!path_data)
		no_memory();

	while (decode) {
		command = CommandReader();
		OK = Command_check(command);
		switch (decode) {
		case Uhelp:
			helpf();
			break;
		case Uset:
			setf(command + 1, terminal);
			break;
		case Uprint:
			Mem_printf(terminal, terminal, path_data, 0);
			break;
		case Ufind:
			findf(terminal, command + 1);
			break;
		case Ulist:
			listf(terminal, command + 1);
			break;
		case Usearch:
			searchf(terminal, terminal, command + 1, path_data, 0);
			break;
		case Udelete:
			terminal =
				delf(terminal, terminal, Delay_delete,
				     command + 1, OK);
			break;
		default:
			quitf(path_data, command, terminal, Delay_delete);
			return 0;	/*quit */
		}
		free(command);
		decode = UI_Encoder();
	}
	return -1;		/* Something went wrong */
}
