#include <inc/stdio.h>
#include <inc/kbd.h>
#include <inc/shell.h>
#include <inc/timer.h>
#include <inc/x86.h>
#include <kernel/trap.h>
#include <kernel/picirq.h>

extern void init_video(void);
void kernel_main(void)
{
    int *ptr;
	init_video();

	pic_init();
  /* TODO: You should uncomment them
   */
	 kbd_init();
	 timer_init();
<<<<<<< HEAD
=======
	 trap_init();
     mem_init();
>>>>>>> bcaa209a1609ada3e98f4d025f49946cc7152525

	/* Enable interrupt */
    __asm __volatile("sti");

    /* Test for page fault handler */
    ptr = (int*)(0x12345678);
    //*ptr = 1;

	shell();
}
