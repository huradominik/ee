#ifndef _AXITIMER_H_
#define _AXITIMER_H_

#include "xparameters.h"


typedef struct{
	unsigned int TCSR0;  // 0x00h  Timer 0 Control and Status Register
	unsigned int TLR0;	 // 0x04h  Timer 0 Load Register
	unsigned int TCR0;	 // 0x08h  Timer 0 Counter Register
	unsigned int RSVD_0; // 0x0Ch  Reserved
	unsigned int TCSR1;	 // 0x10h  Timer 1 Control and Status Register
	unsigned int TLR1;	 // 0x14h  Timer 1 Load Register
	unsigned int TCR1;	 // 0x18h  Timer 1 Counter Register
	unsigned int RSVD; 	 // 0x1Ch  Reserved
}T_AXITIMER;

typedef T_AXITIMER *P_AXITIMER;

typedef enum{
	timer_generate = 0,  // generate mode
	timer_capture = 1		// capture mode
}T_AXI_TIMER_MODE;

typedef enum{
	timer_countup = 0,	// timer count up
	timer_countdown = 1	// timer count down
}T_AXI_TIMER_COUNT;

typedef enum{
	timer_extgen_disable = 0,	// generate external flag 1 pulse disable
	timer_extgen_enable = 1  // generate external flag 1 pulse enable
}T_AXI_TIMER_EXT_GEN;

typedef enum{					// External Capture Trigger
	timer_capture_disable = 0,	// disable
	timer_capture_enable = 1		// enable
}T_AXI_TIMER_EXT_CAP;

typedef enum{			// Auto Reload/ Hold Timer
	timer_hold = 0,
	timer_reload = 1
}T_AXI_TIMER_ARTH;

typedef enum{				// Load Value Timer
	timer_load_disable = 0,
	timer_load_tlr = 1
}T_AXI_TIMER_LOAD;

typedef enum{					// Interrupt flag
	timer_itr_disable = 0,
	timer_itr_enable = 1
}T_AXI_TIMER_ITR;

typedef enum{					// Stop and Start flag
	timer_stop = 0,
	timer_start = 1
}T_AXI_TIMER_ENABLE;

typedef enum{					// PWM flag
	timer_pwm_disable = 0,
	timer_pwm_enable = 1
}T_AXI_TIMER_PWM;

typedef enum{					// Enable all timers
	timer_disable = 0,			// No effect with stop and start flag
	timer_enable = 1			// run all timers
}T_AXI_TIMER_ENALL;

typedef enum{
	timer_ch0 = 0,
	timer_ch1 = 1
}T_AXI_TIMER_CH;




void setAxiTimer(unsigned int timer_count, T_AXI_TIMER_CH channel, T_AXI_TIMER_MODE mode, T_AXI_TIMER_COUNT count, T_AXI_TIMER_EXT_GEN ext_gen,
					T_AXI_TIMER_EXT_CAP ext_cap, T_AXI_TIMER_ARTH arth, T_AXI_TIMER_LOAD load, T_AXI_TIMER_ITR itr, T_AXI_TIMER_PWM pwm);
void startAxiTimer(T_AXI_TIMER_CH channel, T_AXI_TIMER_ENABLE enable);

void statusAxiTimer(unsigned int TCSR);






#endif
