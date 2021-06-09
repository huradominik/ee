/*
 AXITRIGGER v1.0 21.05.2021
 RTC, comparator set value
 control flags - enable_write, trigger
 BCD input and output data

 AXITRIGGER v2.0

*/

#include "axicmvtrigger.h"
#include "xparameters.h"
#include "xil_printf.h"

P_AXICMVTRIGGER trigger_t = (P_AXICMVTRIGGER) XPAR_AXI_TRIG_0_S_AXI_BASEADDR;

void setRtcTime(unsigned int year, unsigned int month, unsigned int day,
	unsigned int hours, unsigned int min, unsigned int sec, unsigned int msec,
	unsigned int usec)
{
	unsigned int temp = 0x0;
	//unsigned int temp_d = 0x0;
	temp |= usec/100 << 8 | ((usec/10)%10) << 4 | (usec%10) ;
	//temp_d = usec/10
	temp |= msec/100 << 20 | ((msec/10)%10) << 16 | (msec%10 << 12) ;
	temp |= sec/10 << 27 | sec%10 << 24;
	trigger_t->rtc_set_lsb = temp;
	temp = (min/10 << 4) | (min%10 << 0);
	temp |= (hours/10 << 11) | (hours%10 << 7);
	temp |= (day/10 << 17) | (day%10 << 13);
	temp |= (month/10 << 23) | (month%10 << 19);
	temp |= (year/10 << 28) | (year%10 << 24);
	trigger_t->rtc_set_msb = temp;
	trigger_t->rtc_control = 0x1;
	trigger_t->rtc_control = 0x0;
}

void setCompTime(unsigned int year, unsigned int month, unsigned int day,
	unsigned int hours, unsigned int min, unsigned int sec, unsigned int msec,
	unsigned int usec)
{
	unsigned int temp = 0x0;
	//unsigned int temp_d = 0x0;
	temp |= usec/100 << 8 | ((usec/10)%10) << 4 | (usec%10) ;
	//temp_d = usec/10
	temp |= msec/100 << 20 | ((msec/10)%10) << 16 | (msec%10 << 12) ;
	temp |= sec/10 << 27 | sec%10 << 24;
	trigger_t->comp_set_time_lsb = temp;
	temp = (min/10 << 4) | (min%10 << 0);
	temp |= (hours/10 << 11) | (hours%10 << 7);
	temp |= (day/10 << 17) | (day%10 << 13);
	temp |= (month/10 << 23) | (month%10 << 19);
	temp |= (year/10 << 28) | (year%10 << 24);
	trigger_t->comp_set_time_msb = temp;
	trigger_t->comp_control = 0x1;
	trigger_t->comp_control = 0x0;
}

void displayRtcTime(unsigned int rtc_time_lsb, unsigned int rtc_time_msb)
{
	unsigned int temp_lsb = rtc_time_lsb;
	unsigned int temp_msb = rtc_time_msb;

	unsigned int usec;
	unsigned int msec;
	unsigned int sec;
	unsigned int min;
	unsigned int hrs;
	unsigned int day;
	unsigned int month;
	unsigned int years;
	// lsb 31 bit
	usec = (temp_lsb & 0xf) + (((temp_lsb >> 4) & 0xf) *10) + (((temp_lsb >> 8) & 0xf) *100);
	msec = ((temp_lsb >> 12) & 0xf) + (((temp_lsb >> 16) & 0xf) *10) + (((temp_lsb >> 20) & 0xf) *100);
	sec = ((temp_lsb >> 24) & 0xf) + (((temp_lsb >> 28) & 0xf) * 10);

	// msb 32 bit
	min = (temp_msb & 0xf) + (((temp_msb >> 4) & 0x7) * 10);
	hrs = ((temp_msb >> 7) & 0xf) + (((temp_msb >> 11) & 0x3) * 10);
	day = ((temp_msb >> 13) & 0xf) + (((temp_msb >> 17) & 0x3) * 10);

	month = ((temp_msb>> 19) & 0xf) + (((temp_msb >> 23) & 0x1) * 10);
	years = ((temp_msb>> 24) & 0xf) + (((temp_msb >> 28) & 0xf) * 10);

	xil_printf("TIME: %d:%d:%d:%d:%d:%d:%d \n\r",years, month, day, hrs, min, sec, msec, usec);
	xil_printf("year:%d  month:%d  day:%d  hrs:%d  min:%d  sec:%d  \n\r",years, month, day, hrs, min, sec);
}


void displayFsmState(unsigned int fsm_state)
{
	unsigned int temp = trigger_t->fsm_state;

	xil_printf("STATE : ");
	switch (temp)
	{
	case 0x1:
		xil_printf("INITIALIZATION \n\r");
		break;

	case 0x2:
		xil_printf("SEQUENCE RESET \n\r");
		break;

	case 0x4:
		xil_printf("IDLE \n\r");
		break;

	case 0x8:
		xil_printf("LOAD DATA \n\r");
		break;

	case 0x10:
		xil_printf("SPI \n\r");
		break;

	case 0x20:
		xil_printf("SPI TRANSFER \n\r");
		break;

	case 0x40:
		xil_printf("INTERNAL MODE \n\r");
		break;

	case 0x80:
		xil_printf("EXTERNAL MODE \n\r");
		break;

	case 0x100:
		xil_printf("ACQUISITION MODE \n\r");
		break;

	default :
		xil_printf("unknown state \n\r");
	}
}
unsigned int getFsmState(unsigned int fsm_state)
{
	/*	09.06.2021
	 *  Function return CMV12000 fsm state
	 *
	 *  0x1 - Initialization state
	 *  0x2 - Sequence Reset state
	 *  0x4 - Idle Mode state
	 *  0x8 - Load Data state
	 *  0x10 - SPI state
	 *  0x20 - Spi Transfer Data state
	 *  0x40 - Internal Mode state
	 *  0x80 - External Mode state
	 *  0x100 - Acquisition Image state
	 *
	 */

	unsigned int temp = trigger_t->fsm_state;

	switch(temp)
	{
	case 0x1:
		return 0x1;
		break;
	case 0x2:
		return 0x2;
		break;
	case 0x4:
		return 0x4;
		break;
	case 0x8:
		return 0x8;
		break;
	case 0x10:
		return 0x10;
		break;
	case 0x20:
		return 0x20;
		break;
	case 0x40:
		return 0x40;
		break;
	case 0x80:
		return 0x80;
		break;
	case 0x100:
		return 0x100;
		break;
	default:
		return 0;
		xil_printf("unknown state \n\r");
	}
}

void cmvReset()
{
	/* 09.06.2021
	 * CMV12000 SEQUENCE RESET
	 */

	unsigned int i = 0;

	while(getFsmState(trigger_t->fsm_state) != 0x4 || (i < 1000))
	{
		i++;
	}

	if(getFsmState(trigger_t->fsm_state) == 0x4)
	{
		trigger_t->fsm_rst_active = 0x1;
		while(getFsmState(trigger_t->fsm_state) == 0x2 )  // = 0
			{
				xil_printf("reset in progerss... \n\r");
				trigger_t->fsm_rst_active = 0x0;
			}

			xil_printf("reset done.\n\r");
			xil_printf("----------------------\n\r");
	}
	else
	{
		trigger_t->fsm_rst_active = 0x0;
		xil_printf("reset FAIL\n\r");
	}


}
void cmvLoadData(unsigned int ld_flag)
{
	/*
	 * 09.06.2021
	 *
	 * CMV12000 Load Data:
	 * - spi_diff (0)	- different settings for SPI
	 * - cmp_f (1)		- trigger from compare time
	 * - soft_f (2)		- software trigger flag
	 * - exp_flag (3)	- exposure mode (0 - external, 1 - internal {for software trigger = internal})
	 * - bit mode (5-4) - cmv bit mode ("00" - 12bit, "01" - 10bit, "10" - 8bit, "11" - not used)
	 */

	unsigned int i = 0;

	while(getFsmState(trigger_t->fsm_state) != 0x4 || (i < 2000))
	{
		i++;
	}

	if(getFsmState(trigger_t->fsm_state) == 0x4)
	{
		trigger_t->fsm_flag = ld_flag;
		trigger_t->fsm_ld_active = 0x1;
		while(getFsmState(trigger_t->fsm_state) == 0x8 )
			{
				trigger_t->fsm_ld_active = 0x0;
				xil_printf("load data in progerss... \n\r");
			}
			xil_printf("load data done.\n\r");
			xil_printf("----------------------\n\r");
	}
	else
	{
		trigger_t->fsm_ld_active = 0x0;
		xil_printf("load data FAIL\n\r");
	}
}


void cmvSoftwareImageTrigger()
{
	/* 09.06.2021
	 * [future] :
	 * - add number of image acquisitnios
	 *
	 * Software Image Trigger
	 *
	 */

	unsigned int i = 0;
	while(getFsmState(trigger_t->fsm_state) != 0x4 || (i < 2000))
	{
		i++;
	}

	if(getFsmState(trigger_t->fsm_state) == 0x4)
	{
		trigger_t->fsm_trig_soft = 0x1;
		while(getFsmState(trigger_t->fsm_state) == 0x40)
		{
			trigger_t->fsm_trig_soft = 0x0;
			xil_printf("frame request\n\r");

		}
	}else
	{
		trigger_t->fsm_trig_soft = 0x0;
		xil_printf("software trigger FAIL \n\r");
	}
}
void cmvAcquisitionDone()
{
	trigger_t->fsm_acq_done = 0x1;
	trigger_t->fsm_acq_done = 0x0;
}

