#ifndef MMCM_H
#define MMCM_H


typedef enum{
	true = 1,
	false = 0
} boolean;

typedef enum{
	mmcm_channel_0 = 0,
	mmcm_channel_1 = 1,
	mmcm_channel_2 = 2,
	mmcm_channel_3 = 3,
	mmcm_channel_4 = 4,
	mmcm_channel_5 = 5,
	mmcm_channel_6 = 6
} T_MMCM_CHANNEL;

typedef enum{
	mmcm_frac_0 = 0,
	mmcm_frac_125 = 125,
	mmcm_frac_250 = 250,
	mmcm_frac_375 = 375,
	mmcm_frac_500 = 500,
	mmcm_frac_625 = 625,
	mmcm_frac_750 = 750,
	mmcm_frac_875 = 875,
	mmcm_frac_1000 = 1000
}T_MMCM_FRACTIONAL;

typedef struct{
	unsigned int pwr_reg;
	unsigned int clkout0_reg1;
	unsigned int clkout0_reg2;
	unsigned int clkout1_reg1;
	unsigned int clkout1_reg2;
	unsigned int clkout2_reg1;
	unsigned int clkout2_reg2;
	unsigned int clkout3_reg1;
	unsigned int clkout3_reg2;
	unsigned int clkout4_reg1;
	unsigned int clkout4_reg2;
	unsigned int clkout5_reg1;
	unsigned int clkout5_reg2;
	unsigned int clkout6_reg1;
	unsigned int clkout6_reg2;
	unsigned int div_clk_reg;
	unsigned int clkfbout_reg1;
	unsigned int clkfbout_reg2;
	unsigned int lock_reg1;
	unsigned int lock_reg2;
	unsigned int lock_reg3;
	unsigned int filter_reg1;
	unsigned int filter_reg2;
	union{
		unsigned int clk_reg24;		// 0x1 default value,   0x3 reconfiguration
		struct{
			unsigned int reg24_load_sen : 1;
			unsigned int reg24_saddr : 1;
		};
	};
}T_MMCM_DRP;

typedef T_MMCM_DRP *P_MMCM_DRP;

typedef struct{
	union{
		unsigned int clk_reg0;  
		struct{
			unsigned int divclk_div : 8; 	// 8 bits divide value
			unsigned int clkfbout_mult : 8; // 0x8   = 8
			unsigned int clkfbout_frac : 10; // 0x7D  = 0.125
			unsigned int clk_reg0_xx   : 6;	//  == 8.125
		};
	};
	union{
		signed int clk_reg1;
		struct{
			signed int clkfbout_phase : 32;
		};
	};
	union{
		unsigned int clk_reg2;
		struct{
			unsigned int clkout0_div : 8;  
			unsigned int clkout0_frac : 10;
			unsigned int clk_reg2_xx : 14;
		};
	};
	union{
		signed int clk_reg3;
		struct{
			signed int clkout0_phase : 32;
		};
	};
	union{
		unsigned int clk_reg4;			// (duty cycle in %) * 1000
		struct{
			unsigned int clkout0_duty : 32;  // 0xC350 default -> 50%
		};
	};
	union{
		unsigned int clk_reg5;
		struct{
			unsigned int clkout1_div : 8;
			unsigned int clkout1_xx  : 24;
		};
	};
	union{
		signed int clk_reg6;
		struct{
			signed int clkout1_phase : 32;
		};
	};
	union{
		unsigned int clk_reg7;
		struct{
			unsigned int clkout1_duty : 32;
		};
	};
	union{
		unsigned int clk_reg8;
		struct{
		unsigned int clkout2_div : 8;
		unsigned int clkout2_xx  : 24;
		};
	};
	union{
		signed int clk_reg9;
		struct{
			signed int clkout2_phase : 32;
		};
	};
	union{
		unsigned int clk_reg10;
		struct{
			unsigned int clkout2_duty : 32;
		};
	};
	union{
		unsigned int clk_reg11;
		struct{
			unsigned int clkout3_div : 8;
			unsigned int clkout3_xx : 24;
		};
	};
	union{
		signed int clk_reg12;
		struct{
			signed int clkout3_phase : 32;
		};
	};
	union{
		unsigned int clk_reg13;
		struct{
			unsigned int clkout3_duty : 32;
		};
	};
	union{
		unsigned int clk_reg14;
		struct{
			unsigned int clkout4_div : 8;
			unsigned int clkout4_xx : 24;
		};
	};
	union{
		signed int clk_reg15;
		struct{
			signed int clkout4_phase : 32;
		};
	};
	union{
		unsigned int clk_reg16;
		struct{
			unsigned int clkout4_duty : 32;
		};
	};
	union{
		unsigned int clk_reg17;
		struct{
			unsigned int clkout5_div : 8;
			unsigned int clkout5_xx  : 24;
		};
	};
	union{
		signed int clk_reg18;
		struct{
			signed int clkout5_phase : 32;
		};
	};
	union{
		unsigned int clk_reg19;
		struct{
			unsigned int clkout5_duty : 32;
		};
	};
	union{
		unsigned int clk_reg20;
		struct{
			unsigned int clkout6_div : 8;
			unsigned int clkout6_xx : 24;
		};
	};
	union{
		signed int clk_reg21;
		struct{
			signed int clkout6_phase : 32;
		};
	};
	union{
		unsigned int clk_reg22;
		struct{
			unsigned int clkout6_duty : 32;
		};
	};
	union{
		unsigned clk_reg23;
		struct{
			unsigned int reg23_load_sen : 1;
			unsigned int reg23_drp_saddr : 1;
			unsigned int reg23_xx : 30; 			
		};
	};
}T_MMCM_REG;

typedef T_MMCM_REG *P_MMCM_REG;


typedef struct{
	unsigned int srr;		// Software Reset Register
	union{
		unsigned int status_register;	// Status Register
		struct{
			unsigned int status_locked : 1;  // if 1 - ready for reconfiguration
			unsigned int status_xx	: 31;
		};
	};
	unsigned int CMESR;			// Clock Monitor Error Status Register	
	unsigned int itr_status;	// Interrupt Status
	unsigned int itr_ena;		// Interrupt Enable
}T_MMCM_STATUS;

typedef T_MMCM_STATUS *P_MMCM_STATUS;

void setMmcmDefault();
void setMmcmReconfigure();
void setMmcmRegister(unsigned int *reg, unsigned int value);
void setMmcmDutyCycle(T_MMCM_CHANNEL channel, unsigned int value);
void setMmcmPhase(T_MMCM_CHANNEL channel, signed int value);
//void setMmcmFrequency(); //T_MMCM_CHANNEL, unsigned int value
void setMmcmPll(unsigned int D, unsigned int M, T_MMCM_FRACTIONAL M_FB);
void setMmcmCounterOutput(T_MMCM_CHANNEL channel, unsigned int divide, T_MMCM_FRACTIONAL divide_frac);


unsigned int getMmcmRegister(unsigned int *reg);
unsigned int getMmcmFreq(T_MMCM_CHANNEL channel);
signed int getMmcmPhase(T_MMCM_CHANNEL channel);
unsigned int getMmcmDutyCycle(T_MMCM_CHANNEL channel);

void showMmcmRegisters();
void showMmcmAddrMap();
boolean checkMmcmFreqPfd(unsigned int D);
boolean checkMmcmFreqVco(unsigned int D, unsigned int M, unsigned int M_FB);
boolean checkFreqOutput();

void setMmcmDrpFreq(unsigned int *tab, T_MMCM_DRP *addr);

int xil_FloatToIntAfterDec(float value);
int xil_FloatToIntDec(float value);


#endif
