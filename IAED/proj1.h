/* Projeto: Kanban (IAED 20/21)*
 * Estudante: José Cutileiro   *
 * Numero de estudante: 99097  *
 * HEADER FILE (defenitions)   */


/* System limits */

#define MAX_USERS 50
#define MAX_ACTIVITIES 10
#define MAX_TASKS 10000

/* Task defenitions */

#define MAX_NAME 20            /*    Limit input     */
#define T_MAX 50               /* Limit descripition */
#define MAX_NAME_AUX 21        /* One extra block to memory */
#define T_MAX_AUX 51           /* One extra block to memory */

/* Bool values */

#define True 1
#define False 0


/***** Task Manager Values *****/

enum T_manager { T_Quit = 'q', T_Task = 't',
	T_List = 'l', T_Jump = 'n', T_User = 'u',
	T_Move = 'm', T_Task_in_Activity = 'd',
	T_Add = 'a'
};


/***** Define - TASK *******/

typedef struct {
	unsigned int ID, start, duration;
	char text[T_MAX_AUX], user[MAX_NAME_AUX], Activity[MAX_NAME_AUX];
} Task;


/***** Command fail messages *****/

/* Memory is full */
#define ManyTasks "too many tasks\n"
#define ManyUsers "too many users\n"
#define ManyActv "too many activities\n"

/* Duplicated atributes */
#define DupeDesc "duplicate description\n"
#define DupeUser "user already exists\n"
#define DupeActivity "duplicate activity\n"

/* Invalid atributes */
#define InvDur "invalid duration\n"
#define InvTask "%d: no such task\n"
#define InvTime "invalid time\n"
#define InvDesc "invalid description\n"

/* Not in memory yet */

#define NmemTask "no such task\n"
#define NmemUser "no such user\n"
#define NmemActivity "no such activity\n"

/* Already started */

#define TaskStarted "task already started\n"


/**** Command sucess messages ****/

#define S_NewTask "task %d\n"
#define S_WriteTask "%d %s #%d %s\n"
#define FINISHED "duration=%d slack=%d\n"


/***** Activities (in memory by default) *****/

#define To_Do "TO DO"
#define In_Pgrs "IN PROGRESS"
#define DONE "DONE"
