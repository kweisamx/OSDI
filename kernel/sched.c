#include <kernel/task.h>
#include <kernel/cpu.h>
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
void sched();

//
// TODO: Lab6
// Modify your Round-robin scheduler to fit the multi-core
// You should:
//
// 1. Design your Runqueue structure first (in kernel/task.c)
//
// 2. modify sys_fork() in kernel/task.c ( we dispatch a task
//    to cpu runqueue only when we call fork system call )
//
// 3. modify sys_kill() in kernel/task.c ( we remove a task
//    from cpu runqueue when we call kill_self system call
//
// 4. modify your scheduler so that each cpu will do scheduling
//    with its runqueue
//    
//    (cpu can only schedule tasks which in its runqueue!!) 
//    (do not schedule idle task if there are still another process can run)	
//
void sched_yield(void)
{   
	extern Task tasks[];
	extern Task *cur_task;
    volatile int next,cid;
    cid = cpunum();
    /*while(1){
        
        next = (cpus[0].cpu_task->task_id + i++)%NR_TASKS;
        if(i==NR_TASKS)
            i = 0;
        if(next == cpus[0].cpu_task->task_id)
            if(cpus[0].cpu_task->state==TASK_RUNNING)
                break; 
        if(tasks[next].state==TASK_RUNNABLE)
        {
            cpus[cid].cpu_task =&(tasks[next]);
            cpus[cid].cpu_task->state = TASK_RUNNING;
            cpus[cid].cpu_task->remind_ticks = TIME_QUANT;
            lcr3(PADDR(cpus[cid].cpu_task->pgdir));
            env_pop_tf(&cpus[cid].cpu_task->tf);
        }
           

        

    }
    */
    int i = 0 ;
    int j = (cpus[cid].cpu_rq.index + 1)%NR_TASKS;
   // for(i = 0;i<NR_TASKS;i++)
    while(1)
    {
        if(cpus[cid].cpu_rq.task_rq[j]!= NULL && cpus[cid].cpu_rq.task_rq[j]->state == TASK_RUNNABLE)// if the task is not NULL and it wait to run
            /*we will see the right now the cpu task state*/
        {
            switch(cpus[cid].cpu_task->state)
            {
                case TASK_RUNNING:
                    cpus[cid].cpu_task->state = TASK_RUNNABLE;
                    cpus[cid].cpu_task->remind_ticks = TIME_QUANT;
                    break;
                case TASK_SLEEP:
                    break;
                case TASK_FREE:
                    break;
                case TASK_STOP:
                    break;

            }
            cpus[cid].cpu_task = cpus[cid].cpu_rq.task_rq[j];      
            lcr3( PADDR( cpus[cid].cpu_rq.task_rq[j]->pgdir ) );
            cpus[cid].cpu_rq.task_rq[j]->state = TASK_RUNNING;
            cpus[cid].cpu_rq.index = j;
            env_pop_tf(&cpus[cid].cpu_task->tf);
        }
        else if(cpus[cid].cpu_rq.task_rq[j]!=NULL && cpus[cid].cpu_rq.task_rq[j]->state ==TASK_RUNNING)//run back again
        {
            break;
        }
        j = (j+1)%NR_TASKS;
    }
}


