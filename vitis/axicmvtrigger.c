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

