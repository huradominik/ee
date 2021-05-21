#ifndef _AXICMVTRIGGER_H_
#define _AXICMVTRIGGER_H_


typedef struct{
	unsigned int rtc_status;		// 0x00h
	unsigned int rtc_control;		// 0x04h
	unsigned int rtc_set_lsb;		// 0x08h
	unsigned int rtc_set_msb;		// 0x0Ch
	unsigned int rtc_curr_time_lsb;	// 0x10h
	unsigned int rtc_curr_time_msb;	// 0x14h
	unsigned int rtc_reserved_0;	// 0x18h
	unsigned int rtc_reserved_1;	// 0x1Ch
	unsigned int comp_status;		// 0x20h
	unsigned int comp_control;		// 0x24h
	unsigned int comp_set_time_lsb;	// 0x28h
	unsigned int comp_set_time_msb;	// 0x2Ch
	unsigned int comp_reserved_0;	// 0x30h
	unsigned int comp_reserved_1;	// 0x34h
}T_AXICMVTRIGGER;

typedef T_AXICMVTRIGGER *P_AXICMVTRIGGER;


void setRtcTime(unsigned int year, unsigned int month, unsigned int day,
	unsigned int hours, unsigned int min, unsigned int sec, unsigned int msec,
	unsigned int usec);

void setCompTime(unsigned int year, unsigned int month, unsigned int day,
		unsigned int hours, unsigned int min, unsigned int sec, unsigned int msec,
		unsigned int usec);
void displayRtcTime(unsigned int rtc_time_lsb, unsigned int rtc_time_msb);

#endif

