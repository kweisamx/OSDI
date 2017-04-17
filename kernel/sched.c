#include <kernel/task.h>
#include <inc/x86.h>

#define ctx_switch(ts) \
  do { env_pop_tf(&((ts)->tf)); } while(0)

/* TODO: Lab5
* Implement a simple round-robin scheduler (Start with the next one)
*
* 1. You have to remember the task you picked last time.
*
* 2. If the next task is in TASK_RUNNABLE state, choose
*    it.
*
* 3. After your choice set cur_task to the picked task
*    and set its state, remind_ticks, and change page
*    directory to its pgdir.
*
* 4. CONTEXT SWITCH, leverage the macro ctx_switch(ts)
*    Please make sure you understand the mechanism.
*/
static int i=1;
void sched();
void sched_yield(void)
{   
	extern Task tasks[];
	extern Task *cur_task;
    volatile int next;
    while(1){
        next = (cur_task->task_id + i++)%NR_TASKS;
        if(i==NR_TASKS)
            i = 0;
        if(next == cur_task->task_id)
            if(cur_task->state==TASK_RUNNING)
            break; 
        if(tasks[next].state==TASK_RUNNABLE)
        {
            cur_task =&(tasks[next]);
            cur_task->state = TASK_RUNNING;
            cur_task->remind_ticks = TIME_QUANT;
            lcr3(PADDR(cur_task->pgdir));
            env_pop_tf(&cur_task->tf);
        }

        

    }
    /*
    int i;
    int next_i = 0;
    i = (index +1)%NR_TASKS;
    while (1)
    {
        if ((tasks[i].state == TASK_RUNNABLE))                                                
        {
            next_i = i;                                                       
            break;
        }
        if (++i >= NR_TASKS) i = 0;
        
        if (index == i)
        {   
            next_i = -1;
            break;
        }
    }
    if (next_i == -1 ) //only one task can run
                next_i = index;
    if (next_i >= 0 && next_i < NR_TASKS)
            {*/
            
}


