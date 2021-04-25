/* Projeto: Kanban (IAED 20/21)*
 * Estudante: José Cutileiro   *
 * Numero de estudante: 99097  */

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "proj1.h"


/*** Erase keyboard buffer ***/

/* Delete keyboard buffer */
void
buffer_delete() {
	while (getchar() != '\n');
}

/* Avoid reading spaces or tabs
 * (' ' || '\t') */
char
no_blank() {
	char let;
	let = getchar();
	while (let == ' ' || let == '\t')
		let = getchar();
	return let;
}


/*** Merge sort ***/

/* Compare Task a & b 
 * flag == 0 -> alphabetic order 
 * flag == 1 -> time (alphabetic order if ==)*/
int
less(Task a, Task b, int flag) {

	switch (flag) {
	case 0:
		if (strcmp(a.text, b.text) < 0)
			return True;
		return False;
	case 1:
		if (a.start > b.start)
			return True;
		if (a.start == b.start && strcmp(a.text, b.text) < 0)
			return True;
		return False;
	}
	return 0;
}

/* mergesort algorithm - Used to 
 * order the Tasks in specific orders */
void
merge(Task a[], int l, int m, int r, int flag) {
	Task aux[MAX_TASKS];
	int i, j, k;
	for (i = m + 1; i > l; i--)
		aux[i - 1] = a[i - 1];
	for (j = m; j < r; j++)
		aux[r + m - j] = a[j + 1];
	for (k = l; k <= r; k++)
		if (less(aux[j], aux[i], flag))
			a[k] = aux[j--];
		else
			a[k] = aux[i++];
}

void
mergesort(Task a[], int l, int r, int flag) {
	int m = (r + l) / 2;
	if (r <= l)
		return;
	mergesort(a, l, m, flag);
	mergesort(a, m + 1, r, flag);
	merge(a, l, m, r, flag);

}

/************ User Activity ************/

/***** ADD TASK ('t') *****/

/* Check if task is already in memory */
int
check_new_task(Task TASKS[], char new_text[], int tasks_in_memory) {
	int i = 0;
	while (i < tasks_in_memory) {
		if (!strcmp(new_text, TASKS[i].text))
			return 1;
		i++;
	}
	return 0;
}

/* read new description from stdin */
void
task_description(char text[]) {
	int i = 0, let;

	let = getchar();
	while (let == ' ' || let == '\t')
		let = getchar();

	text[i] = let;		/* Task description */
	while (i < T_MAX && text[i] != '\n') {
		i++;
		text[i] = getchar();
	}

	text[i] = '\0';		/* End description */
}


 /* Check compatibility with existing tasks
  * and in case of compatibility, insert the new
  * task in memory */
int
finish_task(Task TASKS[], Task new_task, int *tasks_in_memory, int i) {
	int repeat;		/* 0 -> New task || 1 -> Existing task */

	repeat = check_new_task(TASKS, new_task.text, *tasks_in_memory);
	if (repeat) {
		printf(DupeDesc);
		return -1;
	}

	/* Check if duration is valid */

	if (i <= 0) {
		printf(InvDur);
		return -1;
	}
	new_task.duration = (unsigned) i;


	/* Complete task */
	TASKS[*tasks_in_memory] = new_task;	/* Add task to memory */
	*tasks_in_memory = *tasks_in_memory + 1;	/* Memory counter +1 */
	printf(S_NewTask, new_task.ID);	/* New task - Sucess */

	return 0;

}

/* add new task to memory 
 * (if conditions are good) */
int
task_create(int *tasks_in_memory, Task TASKS[], char to_do[]) {
	int i;
	Task new_task;
	if (*tasks_in_memory == MAX_TASKS) {
		printf(ManyTasks);
		buffer_delete();	/* Reset user input */
		return -1;
	}

	/* Task informations */

	new_task.start = 0;	/*  Not started yet  */
	strcpy(new_task.Activity, to_do);	/* To do - New task  */
	new_task.ID = *tasks_in_memory + 1;	/*  ID [1 to 10000]  */
	scanf("%d", &i);	/*   Task duration   */
	task_description(new_task.text);	/*  Task description */
	new_task.user[0] = '\0';	/*  Not started yet  */


	finish_task(TASKS, new_task, tasks_in_memory, i);

	return 0;
}

/***** LIST SELECTED TASKS - 'l' *****/

/* Write a selected task
 * to stdout */
void
write_task(Task sel_task) {
	printf(S_WriteTask, sel_task.ID, sel_task.Activity,
	       sel_task.duration, sel_task.text);
}

/* List a group of tasks
 * (or all by default) */
void
list_tasks(int *tasks_in_memory, Task TASKS[]) {
	int ID = 0;
	Task valids[MAX_TASKS];
	while (scanf("%d", &ID) == 1) {
		if (ID > *tasks_in_memory || ID < 1)
			printf(InvTask, ID);
		else
			write_task(TASKS[ID - 1]);
	}
	if (!ID) {
		for (ID = 0; ID < *tasks_in_memory; ID++)
			valids[ID] = TASKS[ID];
		mergesort(valids, 0, *tasks_in_memory - 1, 0);
		for (ID = 0; ID < *tasks_in_memory; ID++)
			write_task(valids[ID]);

	}


}


/***** Time Control - 'n' *****/

/* Update time info on all
 * tasks that are no longer in "TO DO" */
void
update_time_system(int forward, Task TASKS[], int tasks_in_memory) {
	int i = 0;

	while (i < tasks_in_memory) {
		if (strcmp(TASKS[i].Activity, To_Do))
			TASKS[i].start += forward;
		i++;


	}

}

/* User can select a time unit to advance
 * in system, this function will make sure 
 * this unit is compatible with the sytem */
int
time_control(int time, Task TASKS[], int *tasks_in_memory) {
	float insert;
	int forward, args;

	args = scanf("%f", &insert);
	buffer_delete();
	if (args != 1) {
		printf("%d\n", time);
		return time;
	}
	forward = insert;
	if (insert < 0 || (forward - insert)) {
		printf(InvTime);
		return time;
	}
	time += forward;
	update_time_system(forward, TASKS, *tasks_in_memory);
	printf("%d\n", time);
	return time;


}


/***** User managment - 'u' *****/

/* List all users in stdout */
void
list_users(int users_in_system, char USERS[MAX_USERS][MAX_NAME_AUX]) {
	int i = 0, j = 0;

	while (i < users_in_system) {
		j = 0;
		while (j < MAX_NAME && USERS[i][j] != '\0') {
			printf("%c", USERS[i][j]);
			j++;
		}
		printf("\n");
		i++;
	}

}

/* stdin user */

int
new_user_aux(char new_user[MAX_NAME_AUX], int users_in_system,
	     char USERS[MAX_USERS][MAX_NAME_AUX]) {
	int j = 0;
	new_user[j] = getchar();
	while (j < MAX_NAME && new_user[j] != '\n') {
		if (new_user[j] == ' ' || new_user[j] == '\t')
			j--;
		j++;
		new_user[j] = getchar();
	}
	new_user[j] = '\0';

	if (strlen(new_user) == 0) {
		list_users(users_in_system, USERS);
		return False;
	}

	return True;
}

/* add new user to the system
 * (or list the users if none user name is inserted)*/
int
add_user(int *users_in_system, char USERS[MAX_USERS][MAX_NAME_AUX]) {
	char new_user[MAX_NAME_AUX];
	int i = 0;

	if (!new_user_aux(new_user, *users_in_system, USERS))
		return -1;

	while (i < *users_in_system) {
		if (!strcmp(USERS[i], new_user)) {
			printf(DupeUser);
			return -1;
		}
		i++;
	}

	if (*users_in_system + 1 > MAX_USERS) {
		printf(ManyUsers);
		return -1;
	}

	strcpy(USERS[*users_in_system], new_user);
	*users_in_system += 1;
	return 0;

}


/***** Task managment - 'm'*****/


int
verify(int number, char STDY[MAX_USERS][MAX_NAME_AUX], char user_activity[]) {
	int i = 0;

	while (i < number) {
		if (!strcmp(user_activity, STDY[i]))
			return 0;
		i++;
	}
	return 1;
}


int
ID_aux(int *ID, int mem) {
	scanf("%d", &(*ID));
	if ((*ID) > mem || *ID <= 0) {
		printf(NmemTask);
		buffer_delete();
		return False;
	}
	return True;
}


int
worker_aux(char worker[MAX_NAME_AUX], int mem,
	   char USERS[MAX_USERS][MAX_NAME_AUX]) {
	int i = 0, invalid;
	worker[i] = no_blank();
	while (worker[i] != ' ' && i < MAX_NAME) {
		i++;
		worker[i] = getchar();
	}

	worker[i] = '\0';

	invalid = verify(mem, USERS, worker);
	if (invalid) {
		printf(NmemUser);
		buffer_delete();
		return False;
	}
	return True;
}

int
activity_aux(int mem, char activity[MAX_NAME_AUX],
	     char ACTIVITIES[MAX_ACTIVITIES][MAX_NAME_AUX], Task TASKS[],
	     int ID) {
	int i = 0, invalid;

	activity[i] = no_blank();
	while (i < MAX_NAME && activity[i] != '\n') {
		i++;
		activity[i] = getchar();
	}
	activity[i] = '\0';
	if (!strcmp(activity, To_Do)
	    && strcmp(TASKS[ID - 1].Activity, To_Do)) {
		printf(TaskStarted);
		return False;
	}
	invalid = verify(mem, ACTIVITIES, activity);
	if (invalid) {
		printf(NmemActivity);
		return False;
	}

	return True;
}

/* move tasks from activity to activity
 * (read info from stdin) */
int
move_tasks(int mem[], Task TASKS[], char USERS[MAX_USERS][MAX_NAME_AUX],
	   char ACTIVITIES[MAX_ACTIVITIES][MAX_NAME_AUX]) {
	int ID;

	char worker[MAX_NAME_AUX], activity[MAX_NAME_AUX];


	if (!ID_aux(&ID, mem[2]))
		return -1;

	if (!worker_aux(worker, mem[1], USERS))
		return -1;

	if (!activity_aux(mem[1], activity, ACTIVITIES, TASKS, ID))
		return -1;

	if (!strcmp(activity, DONE))
		printf(FINISHED, TASKS[ID - 1].start,
		       TASKS[ID - 1].start - TASKS[ID - 1].duration);
	strcpy(TASKS[ID - 1].user, worker);
	strcpy(TASKS[ID - 1].Activity, activity);

	return 0;

}


/***** Activity managment - 'a' *****/

/* verify conditions */
int
verify_activity(int *activities_in_system,
		char ACTIVITIES[MAX_ACTIVITIES][MAX_NAME_AUX],
		char new_activity[MAX_NAME_AUX], int invalid) {
	int i = 0;
	while (i < *activities_in_system) {
		if (!strcmp(ACTIVITIES[i], new_activity)) {
			printf(DupeActivity);
			return -1;
		}
		i++;
	}

	if (invalid) {
		printf(InvDesc);
		return 0;
	}

	if (*activities_in_system + 1 > MAX_ACTIVITIES) {
		printf(ManyActv);
		return -1;
	}

	strcpy(ACTIVITIES[*activities_in_system], new_activity);
	*activities_in_system += 1;
	return 0;
}


/* Add activity to the system
 * (if conditions are verified) */
int
add_activity(int *activities_in_system,
	     char ACTIVITIES[MAX_ACTIVITIES][MAX_NAME_AUX]) {

	char new_activity[MAX_NAME_AUX];
	int i = 0, j = 0, invalid_description = 0;

	new_activity[j] = getchar();
	while (j < MAX_NAME && new_activity[j] != '\n') {
		if ((new_activity[j] == ' ' || new_activity[j] == '\t')
		    && i == 0) {
			j--;
			i++;
		}
		if (new_activity[j] >= 'a' && new_activity[j] <= 'z') {
			invalid_description = 1;
		}
		j++;
		new_activity[j] = getchar();
	}
	new_activity[j] = '\0';

	if (strlen(new_activity) == 0) {
		list_users(*activities_in_system, ACTIVITIES);
		return 0;
	}

	verify_activity(activities_in_system, ACTIVITIES, new_activity,
			invalid_description);
	return 0;
}


/***** Tasks in activity - 'd' *****/

/* Print task in activity on stdout */
void
draw_task_activity(Task task, int time) {
	printf("%d %d %s\n", task.ID, time - task.start, task.text);
}

/* check all tasks that have the "activity_in_study"*/
void
valid_activity(unsigned int tasks_in_memory, Task TASKS[],
	       char activity_in_study[], int time) {
	unsigned i = 0, j = 0;
	Task valids[MAX_TASKS];

	while (i < tasks_in_memory) {
		if (!strcmp(TASKS[i].Activity, activity_in_study)) {
			valids[j] = TASKS[i];
			j++;
		}
		i++;
	}
	mergesort(valids, 0, j - 1, 1);
	i = 0;
	while (i < j) {
		draw_task_activity(valids[i], time);
		i++;
	}


}

/* view task in selected activity */
int
task_visualizer(int activities_in_system, Task TASKS[],
		char ACTIVITIES[MAX_ACTIVITIES][MAX_NAME_AUX],
		int tasks_in_memory, int time) {
	char activity_in_study[MAX_NAME_AUX], first;
	int i = 0;
	first = getchar();
	while (first == ' ' || first == '\t')
		first = getchar();
	activity_in_study[i] = first;
	while (activity_in_study[i] != '\n') {
		i++;
		activity_in_study[i] = getchar();
	}
	activity_in_study[i] = '\0';
	for (i = 0; i < activities_in_system; i++) {
		if (!strcmp(activity_in_study, ACTIVITIES[i])) {
			valid_activity(tasks_in_memory, TASKS,
				       activity_in_study, time);
			return 0;
		}
	}

	printf(NmemActivity);
	return -1;
}


/******* KANBAN (main function) *******/

/* Program informations:
 * Mem_usage -> A 3 dimensional array that keeps how much memory
 *              is being used at the moment by users, activities and TASKS
 * USERS -> Save all users (same as TASKS and ACTIVITIES)
 * ProgramTask -> selected task                                            */

int
main() {
	int time = 0, ProgramTask, Mem_usage[] = { 0, 3, 0 };	/* {USERS,ACTIVITIES,TASKS} */
	char USERS[MAX_USERS][MAX_NAME_AUX],
		ACTIVITIES[MAX_ACTIVITIES][MAX_NAME_AUX] =
		{ To_Do, In_Pgrs, DONE };
	Task TASKS[MAX_TASKS];

	ProgramTask = getchar();
	while (ProgramTask) {
		switch (ProgramTask) {
		case T_Task:
			task_create(&Mem_usage[2], TASKS, ACTIVITIES[0]);
			break;
		case T_List:
			list_tasks(&Mem_usage[2], TASKS);
			break;
		case T_Jump:
			time = time_control(time, TASKS, &Mem_usage[2]);
			break;
		case T_User:
			add_user(&Mem_usage[0], USERS);
			break;
		case T_Move:
			move_tasks(Mem_usage, TASKS, USERS, ACTIVITIES);
			break;
		case T_Task_in_Activity:
			task_visualizer(Mem_usage[1], TASKS, ACTIVITIES,
					Mem_usage[2], time);
			break;
		case T_Add:
			add_activity(&Mem_usage[1], ACTIVITIES);
			break;
		default:
			return 0;

		}
		ProgramTask = getchar();

	}

	return -1;		/* Something went wrong */
}
