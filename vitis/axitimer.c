
#include "axitimer.h"
#include "xparameters.h"
#include "xil_printf.h"



void setAxiTimer(unsigned int timer_count, T_AXI_TIMER_CH channel, T_AXI_TIMER_MODE mode, T_AXI_TIMER_COUNT count, T_AXI_TIMER_EXT_GEN ext_gen,
					T_AXI_TIMER_EXT_CAP ext_cap, T_AXI_TIMER_ARTH arth, T_AXI_TIMER_LOAD load, T_AXI_TIMER_ITR itr, T_AXI_TIMER_PWM pwm)
{
	unsigned int offset = 0x0;
	unsigned int nr = channel;
	if(nr == 0)
	{
		offset = 0;
	} else offset = 0x10;

	P_AXITIMER timer_t = (P_AXITIMER) (XPAR_TMRCTR_0_BASEADDR + offset);

	unsigned int count_value = 0xffffffff - timer_count - 2;
	timer_t->TLR0 = count_value;

	timer_t->TCSR0 = 0x0;
	timer_t->TCSR0 = mode;
	timer_t->TCSR0 |= count << 1;
	timer_t->TCSR0 |= ext_gen << 2;
	timer_t->TCSR0 |= ext_cap << 3;
	timer_t->TCSR0 |= arth << 4;
	timer_t->TCSR0 |= load << 5;
	timer_t->TCSR0 |= itr << 6;
	timer_t->TCSR0 |= pwm << 9;

}

void startAxiTimer(T_AXI_TIMER_CH channel, T_AXI_TIMER_ENABLE enable)
{
	unsigned int offset = 0x0;
	unsigned int nr = channel;
	if(nr == 0)
	{
		offset = 0;
	} else offset = 0x10;

	P_AXITIMER timer_t = (P_AXITIMER) (XPAR_TMRCTR_0_BASEADDR + offset);

	timer_t->TCSR0 &= 0xffffffdf;
	timer_t->TCSR0 |= (0x0 | enable << 7);
}

void statusAxiTimer(unsigned int TCSR)
{
	unsigned int temp = TCSR;

	xil_printf("Value TCSR : %x \n\r",temp);
	if (((temp >> 7) & 0x1) == 1)
	{
		xil_printf("Timer : running\n\r");
	} else xil_printf("Timer : running\n\r");

}
