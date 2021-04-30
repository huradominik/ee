
#include "xil_printf.h"
#include "xparameters.h"
#include "mmcm.h"

// PARAMETERS FOR ZYNQ 7000 7S  "DS187"//
// MORE INFO "DC and AC Switching Characteristic Datasheet Xilinx"
#define XPAR_CLK_WIZ_0_PRIM_VCO_MAX		1200000000U
#define XPAR_CLK_WIZ_0_PRIM_VCO_MIN 	600000000U
#define XPAR_CLK_WIZ_0_PRIM_PFD_MAX 	450000000U
#define XPAR_CLK_WIZ_0_PRIM_PFD_MIN 	10000000U
#define XPAR_CLK_WIZ_0_PRIM_FREQ_OUT_MAX	800000000U
#define XPAR_CLK_WIZ_0_PRIM_FREQ_OUT_MIN	4700000U

#define XPAR_CLK_WIZ_0_PRIM_IN_FREQ_UINT 	125000000U
#define XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T XPAR_CLK_WIZ_0_NUM_OUT_CLKS

P_MMCM_STATUS mmcm_status_t = (P_MMCM_STATUS) XPAR_CLK_WIZ_0_BASEADDR;
P_MMCM_REG mmcm_t = (P_MMCM_REG) (XPAR_CLK_WIZ_0_BASEADDR + 0x200U);

//DRP Write Register
P_MMCM_DRP mmcm_drp_t = (P_MMCM_DRP) (XPAR_CLK_WIZ_0_BASEADDR + 0x300U);



void setMmcmDrpFreq(unsigned int *tab, P_MMCM_DRP addr)
{
	unsigned int *ptr = (unsigned int*)addr;
	for(unsigned int i=0;i<23;i++)
	{
		*ptr = *(tab+i);
		xil_printf("addr = %x, value = %x \n\r",ptr,*ptr);
		xil_printf("tab: %x , tab : %x\n\r",tab+i, *(tab+i));
		ptr++;
	}
	ptr = ((unsigned int*)addr + 23);
	*ptr = 0x3;
}
////////////////////////////////////////


// FUNCTION //

boolean checkMmcmFreqPfd(unsigned int D)  //, unsigned int *M, unsigned int *M_FB)
{
	float check_value;
	unsigned int input_freq_value = XPAR_CLK_WIZ_0_PRIM_IN_FREQ_UINT;
	unsigned int pfd_max = XPAR_CLK_WIZ_0_PRIM_PFD_MAX;
	unsigned int pfd_min = XPAR_CLK_WIZ_0_PRIM_PFD_MIN;

	check_value = input_freq_value / D;

	print("===============================================\n\r");
	if ((check_value > XPAR_CLK_WIZ_0_PRIM_PFD_MIN) && (check_value < XPAR_CLK_WIZ_0_PRIM_PFD_MAX))
	{
		xil_printf("PFD is : %d Hz   OK value\n\r", (unsigned int)check_value);
		return true;
	} else
	{

		xil_printf("Value of PFD is not in range %i MHz - %i MHz (%d.%3d MHz)\n\r",pfd_min/1000000,
				pfd_max/1000000, xil_FloatToIntDec(check_value), xil_FloatToIntAfterDec(check_value));
		xil_printf("Change coefficient divclk_divide! (%i)\n\r",mmcm_t->divclk_div);
		return false;
	}

}

boolean checkMmcmFreqVco(unsigned int D, unsigned int M, unsigned int M_FB)
{
	unsigned int check_value;
	unsigned int vco_max = XPAR_CLK_WIZ_0_PRIM_VCO_MAX;
	unsigned int vco_min = XPAR_CLK_WIZ_0_PRIM_VCO_MIN;
	float factory_value = ((float)M_FB/1000);
	float fb_mult = (float)M + factory_value;

	check_value = (unsigned int)((float)(XPAR_CLK_WIZ_0_PRIM_IN_FREQ_UINT / D) * fb_mult);


	print("===============================================\n\r");
	if (check_value > XPAR_CLK_WIZ_0_PRIM_VCO_MIN && check_value < XPAR_CLK_WIZ_0_PRIM_VCO_MAX)
	{
		xil_printf("VCO correct (%i MHz) from range : %i MHz - %i MHz \n\r",check_value/1000000,
				vco_min/1000000, vco_max/1000000);
		return true;
	} else
	{
		xil_printf("VCO uncorrect from range %i MHz - %i MHz  (%i MHz) \n\r",vco_min/1000000,
				vco_max/1000000,check_value/1000000);
		xil_printf("D = %i,  M = %i, M_FB = 0.%i,\n\r",mmcm_t->divclk_div, mmcm_t->clkfbout_mult,
				mmcm_t->clkfbout_frac);

		return false;
	}
}

boolean checkFreqOutput()
{
	unsigned int *ptr = &(mmcm_t->clk_reg2);
	unsigned int check_value;
	volatile unsigned int D = mmcm_t->divclk_div;
	volatile unsigned int M = mmcm_t->clkfbout_mult;
	volatile float M_FB = mmcm_t->clkfbout_frac/1000;
	float mult = (float)M + M_FB;
	check_value = (XPAR_CLK_WIZ_0_PRIM_IN_FREQ_UINT / D) * mult;

	print("===============================================\n\r");
	for(int i = 0; i < XPAR_CLK_WIZ_0_NUM_OUT_CLKS; i++)
	{
		if(check_value / *(ptr+(i*3)))
			{
				xil_printf("Output Frequency correct %i \n\r", i);
			}else
			{
				xil_printf("Output Frequency uncorrect for %i\n\r",i);
				return false;
			}
	}
	return true;
}
void setMmcmDefault()
{
	print("===============================================\n\r");
	while(!mmcm_status_t->status_locked)
	{
		xil_printf("Durring configuration LOCKED = '0'\n\r");
	}
	mmcm_t->clk_reg23 = 0x1;
	xil_printf("Mmcm back to default value \n\r");
}
void setMmcmReconfigure()
{

	if (checkMmcmFreqPfd(mmcm_t->divclk_div) && checkMmcmFreqVco(mmcm_t->divclk_div,
			mmcm_t->clkfbout_mult, mmcm_t->clkfbout_frac) && checkFreqOutput())
		{
		while(!mmcm_status_t->status_locked)
		{
			xil_printf("Durring configuration LOCKED = '0'\n\r");
			// dopisaæ kawa³ek kodu przywracaj¹cego do ustawieñ podstawowych gdy wpadnie w stan locked = 0
			//for(i;i<;i++)
			//{
			//	if(mmcm_status_t-status_locked) count++
			//		if(count == 10) mmcm_t->clk_reg23 = 0x1;
			//}
		}
		mmcm_t->clk_reg23 = 0x3;
		print("===============================================\n\r");
		xil_printf("SUCCESFULL MMCM CONFIGURATION\n\r");
		} else
		{
			xil_printf("Configuration FAIL!! \n\r");
		}
}

void setMmcmRegister(unsigned int *reg, unsigned int value)
{
	*reg = value;
}

void setMmcmPhase(T_MMCM_CHANNEL channel, signed int value)
{
	// CLKOUT0_PHASE = reg3
	// CLKOUT1_PHASE = reg6
	// CLKOUT2_PHASE = reg9
	// CLKOUT3_PHASE = reg12
	// CLKOUT4_PHASE = reg15
	// CLKOUT5_PHASE = reg18
	// CLKOUT6_PHASE = reg21

	switch (channel)
	{
		case mmcm_channel_0 :
			mmcm_t->clk_reg3 = value;
			break;
		case mmcm_channel_1 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_1)
			{
				mmcm_t->clk_reg6 = value;
			}else xil_printf("This channel is not declarated. You have : %d channels ", XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T);
			break;
		case mmcm_channel_2 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_2)
			{
				mmcm_t->clk_reg9 = value;
			}else xil_printf("This channel is not declarated. You have : %d channels ", XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T);
			break;
		case mmcm_channel_3 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_3)
			{
				mmcm_t->clk_reg12 = value;
			}else xil_printf("This channel is not declarated. You have : %d channels ", XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T);
			break;
		case mmcm_channel_4 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_4)
			{
				mmcm_t->clk_reg15 = value;
			}else xil_printf("This channel is not declarated. You have : %d channels ", XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T);
			break;
		case mmcm_channel_5 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_5)
			{
				mmcm_t->clk_reg18 = value;
			}else xil_printf("This channel is not declarated. You have : %d channels ", XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T);
			break;
		case mmcm_channel_6 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_6)
			{
				mmcm_t->clk_reg21 = value;
			}else xil_printf("This channel is not declarated. You have : %d channels ", XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T);
	}
}

void setMmcmDutyCycle(T_MMCM_CHANNEL channel, unsigned int value)
{
	// duty cycle value = (Duty Cycle in %) * 1000
	// 50% * 1000 = 50000 = 0xC350
	// CLKOUT0_DUTY = reg4
	// CLKOUT1_DUTY = reg7
	// CLKOUT2_DUTY = reg10
	// CLKOUT3_DUTY = reg13
	// CLKOUT4_DUTY = reg16
	// CLKOUT5_DUTY = reg19
	// CLKOUT6_DUTY = reg22

	switch (channel)
	{
		case mmcm_channel_0 :
			mmcm_t->clk_reg4 = value;
			break;

		case mmcm_channel_1 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_1)
			{
				mmcm_t->clk_reg7 = value;
			}else xil_printf("This channel is not declarated. You have : %d channels ", XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T);
			break;

		case mmcm_channel_2 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_2)
			{
				mmcm_t->clk_reg10 = value;
			}else xil_printf("This channel is not declarated. You have : %d channels ", XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T);
			break;

		case mmcm_channel_3 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_3)
			{
				mmcm_t->clk_reg13 = value;
			}else xil_printf("This channel is not declarated. You have : %d channels ", XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T);
			break;

		case mmcm_channel_4 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_4)
			{
				mmcm_t->clk_reg16 = value;
			}else xil_printf("This channel is not declarated. You have : %d channels ", XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T);
			break;

		case mmcm_channel_5 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_5)
			{
				mmcm_t->clk_reg19 = value;
			}else xil_printf("This channel is not declarated. You have : %d channels ", XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T);
			break;

		case mmcm_channel_6 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_6)
			{
				mmcm_t->clk_reg22 = value;
			}else xil_printf("This channel is not declarated. You have : %d channels ", XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T);
	}
}

void setMmcmPll(unsigned int D, unsigned int M, T_MMCM_FRACTIONAL M_FB)
{
	unsigned int temp = 0;

	//[7:0] divclk_div
	//[15:8] clkfbout_mult
	//[25:16] clkfbout_frac
	temp = (0x000000FF & D) | (0xFF00 & M << 8) | (0x3FF0000 & M_FB << 16);

	mmcm_t->clk_reg0 = temp;

}
void setMmcmCounterOutput(T_MMCM_CHANNEL channel, unsigned int divide, T_MMCM_FRACTIONAL divide_frac)
{
	// CLKOUT0_DIVIDE = reg2    [17:8] divide_frac, [7:0] divide
	// CLKOUT1_DIVIDE = reg5	[7:0] divide
	// CLKOUT2_DIVIDE = reg8	[7:0] divide
	// CLKOUT3_DIVIDE = reg11	[7:0] divide
	// CLKOUT4_DIVIDE = reg14	[7:0] divide
	// CLKOUT5_DIVIDE = reg17	[7:0] divide
	// CLKOUT6_DIVIDE = reg20	[7:0] divide

	switch(channel)
	{
		case mmcm_channel_0 :
			mmcm_t->clk_reg2 = (0x0003ff00 & (divide_frac << 8)) | (0x000000ff & divide);
			break;

		case mmcm_channel_1 :
			mmcm_t->clk_reg5 = divide;
			break;

		case mmcm_channel_2 :
			mmcm_t->clk_reg8 = divide;
			break;

		case mmcm_channel_3 :
			mmcm_t->clk_reg11 = divide;
			break;

		case mmcm_channel_4 :
			mmcm_t->clk_reg14 = divide;
			break;

		case mmcm_channel_5 :
			mmcm_t->clk_reg17 = divide;
			break;

		case mmcm_channel_6 :
			mmcm_t->clk_reg20 = divide;
			break;
	}
}

unsigned int getMmcmRegister(unsigned int *reg)
{
	return *reg;
}

unsigned int getMmcmFreq(T_MMCM_CHANNEL channel)
{
	unsigned int fbout_mult = mmcm_t->clkfbout_mult;
	float fbout_frac = (float)(mmcm_t->clkfbout_frac)/1000;
	float mult_fb = fbout_mult+fbout_frac;
	float PFD = (XPAR_CLK_WIZ_0_PRIM_IN_FREQ_UINT/1000000) / mmcm_t->divclk_div;
	float VCO = PFD * mult_fb;

	switch (channel)
	{
		case mmcm_channel_0 :
		{
			float temp =  mmcm_t->clkout0_div + (float)(mmcm_t->clkout0_frac)/1000;
			return (VCO / temp) * 1000000;
			break;
		}

		case mmcm_channel_1 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_1)
			{
				return (VCO / mmcm_t->clkout1_div) * 1000000;
			}else return 0;

			break;

		case mmcm_channel_2 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_2)
			{
				return (VCO / mmcm_t->clkout2_div) * 1000000;
			}else return 0;
			break;

		case mmcm_channel_3 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_3)
			{
				return (VCO / mmcm_t->clkout3_div) * 1000000;
			}else return 0;
			break;

		case mmcm_channel_4 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_4)
			{
				return (VCO / mmcm_t->clkout4_div) * 1000000;
			}else return 0;
			break;

		case mmcm_channel_5 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_5)
			{
				return (VCO / mmcm_t->clkout5_div) * 1000000;
			}else return 0;
			break;

		case mmcm_channel_6 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_6)
			{
				return (VCO / mmcm_t->clkout6_div) * 1000000;
			}else return 0;
	}
	return 0;
}

signed int getMmcmPhase(T_MMCM_CHANNEL channel)
{
	switch(channel)
	{
		case mmcm_channel_0 :
			return mmcm_t->clk_reg3;
			break;
		case mmcm_channel_1 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_1)
			{
				return mmcm_t->clk_reg6;
			}else return 0;
			break;

		case mmcm_channel_2 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_2)
			{
				return mmcm_t->clk_reg9;
			}else return 0;
			break;

		case mmcm_channel_3 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_3)
			{
				return mmcm_t->clk_reg12;
			}else return 0;
			break;

		case mmcm_channel_4 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_4)
			{
				return mmcm_t->clk_reg15;
			}else return 0;
			break;

		case mmcm_channel_5 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_5)
			{
				return mmcm_t-> clk_reg18;
			}else return 0;
			break;

		case mmcm_channel_6 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_6)
			{
				return mmcm_t-> clk_reg21;
			}else return 0;
	}
	return 0;
}

unsigned int getMmcmDutyCycle(T_MMCM_CHANNEL channel)
{
	switch(channel)
	{
		case mmcm_channel_0 :
			return mmcm_t->clk_reg4;
			break;

		case mmcm_channel_1 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_1)
			{
				return mmcm_t->clk_reg7;
			}else return 0;
			break;

		case mmcm_channel_2 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_2)
			{
				return mmcm_t->clk_reg10;
			}else return 0;
			break;

		case mmcm_channel_3 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_3)
			{
				return mmcm_t->clk_reg13;
			}else return 0;
			break;

		case mmcm_channel_4 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_4)
			{
				return mmcm_t->clk_reg16;
			}else return 0;
			break;

		case mmcm_channel_5 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_5)
			{
				return mmcm_t->clk_reg19;
			}else return 0;
			break;

		case mmcm_channel_6 :
			if(XPAR_CLK_WIZ_0_NUM_OUT_CLKS_T-1 >= mmcm_channel_6)
			{
				return mmcm_t->clk_reg22;
			}else return 0;
	}
	return 0;
}
void showMmcmRegisters()
{
	print("===============================================\n\r");
    xil_printf("VALUE OF ALL DRP REGISTERS \n\r");
    xil_printf("value reg0 : %x \n\r", mmcm_t->clk_reg0);
    xil_printf("value reg1 : %x \n\r", mmcm_t->clk_reg1);
    xil_printf("value reg2 : %x \n\r", mmcm_t->clk_reg2);
    xil_printf("value reg3 : %x \n\r", mmcm_t->clk_reg3);
    xil_printf("value reg4 : %x \n\r", mmcm_t->clk_reg4);
    xil_printf("value reg5 : %x \n\r", mmcm_t->clk_reg5);
    xil_printf("value reg6 : %x \n\r", mmcm_t->clk_reg6);
    xil_printf("value reg7 : %x \n\r", mmcm_t->clk_reg7);
    xil_printf("value reg8 : %x \n\r", mmcm_t->clk_reg8);
    xil_printf("value reg9 : %x \n\r", mmcm_t->clk_reg9);
    xil_printf("value reg10 : %x \n\r", mmcm_t->clk_reg10);
    xil_printf("value reg11 : %x \n\r", mmcm_t->clk_reg11);
    xil_printf("value reg12 : %x \n\r", mmcm_t->clk_reg12);
    xil_printf("value reg13 : %x \n\r", mmcm_t->clk_reg13);
    xil_printf("value reg14 : %x \n\r", mmcm_t->clk_reg14);
    xil_printf("value reg15 : %x \n\r", mmcm_t->clk_reg15);
    xil_printf("value reg16 : %x \n\r", mmcm_t->clk_reg16);
    xil_printf("value reg17 : %x \n\r", mmcm_t->clk_reg17);
    xil_printf("value reg18 : %x \n\r", mmcm_t->clk_reg18);
    xil_printf("value reg19 : %x \n\r", mmcm_t->clk_reg19);
    xil_printf("value reg20 : %x \n\r", mmcm_t->clk_reg20);
    xil_printf("value reg21 : %x \n\r", mmcm_t->clk_reg21);
    xil_printf("value reg22 : %x \n\r", mmcm_t->clk_reg22);
    xil_printf("value reg23 : %x \n\r", mmcm_t->clk_reg23);
    print("===============================================\n\r");
    print("VALUE OF STATUS REGISTERS\n\r");
    xil_printf("Software reset (WO) - set 0xA to %x \n\r",&mmcm_status_t->srr);
    xil_printf("Status register (RO) : %x \n\r", mmcm_status_t->status_register);
    xil_printf("CMESR (RO) : %x \n\r",mmcm_status_t->CMESR);
    xil_printf("Interrupt Status (R/W) : %x \n\r",mmcm_status_t->itr_status);
    xil_printf("Interrupt Enable (R/W) : %x \n\r",mmcm_status_t->itr_ena);
}

void showMmcmAddrMap()
{
	print("===============================================\n\r");
    print("MMCM : STATUS REGISTERS ADDRESS MAP\n\r");
    xil_printf("Software reset :  %x \n\r",&mmcm_status_t->srr);
    xil_printf("Status register : %x \n\r", &mmcm_status_t->status_register);
    xil_printf("CMESR : %x \n\r",&mmcm_status_t->CMESR);
    xil_printf("Interrupt Status : %x \n\r",&mmcm_status_t->itr_status);
    xil_printf("Interrupt Enable : %x \n\r",&mmcm_status_t->itr_ena);
    print("===============================================\n\r");
    xil_printf("MMCM : CONFIGURATION REGISTERS ADDRESS MAP \n\r");
    xil_printf("Address reg0 : %x \n\r",&mmcm_t->clk_reg0);
    xil_printf("Address reg1 : %x \n\r",&mmcm_t->clk_reg1);
    xil_printf("Address reg2 : %x \n\r",&mmcm_t->clk_reg2);
    xil_printf("Address reg3 : %x \n\r",&mmcm_t->clk_reg3);
    xil_printf("Address reg4 : %x \n\r",&mmcm_t->clk_reg4);
    xil_printf("Address reg5 : %x \n\r",&mmcm_t->clk_reg5);
    xil_printf("Address reg6 : %x \n\r",&mmcm_t->clk_reg6);
    xil_printf("Address reg7 : %x \n\r",&mmcm_t->clk_reg7);
    xil_printf("Address reg8 : %x \n\r",&mmcm_t->clk_reg8);
    xil_printf("Address reg9 : %x \n\r",&mmcm_t->clk_reg9);
    xil_printf("Address reg10 : %x \n\r",&mmcm_t->clk_reg10);
    xil_printf("Address reg11 : %x \n\r",&mmcm_t->clk_reg11);
    xil_printf("Address reg12 : %x \n\r",&mmcm_t->clk_reg12);
    xil_printf("Address reg13 : %x \n\r",&mmcm_t->clk_reg13);
    xil_printf("Address reg14 : %x \n\r",&mmcm_t->clk_reg14);
    xil_printf("Address reg15 : %x \n\r",&mmcm_t->clk_reg15);
    xil_printf("Address reg16 : %x \n\r",&mmcm_t->clk_reg16);
    xil_printf("Address reg17 : %x \n\r",&mmcm_t->clk_reg17);
    xil_printf("Address reg18 : %x \n\r",&mmcm_t->clk_reg18);
    xil_printf("Address reg19 : %x \n\r",&mmcm_t->clk_reg19);
    xil_printf("Address reg20 : %x \n\r",&mmcm_t->clk_reg20);
    xil_printf("Address reg21 : %x \n\r",&mmcm_t->clk_reg21);
    xil_printf("Address reg22 : %x \n\r",&mmcm_t->clk_reg22);
    xil_printf("Address reg23 : %x \n\r",&mmcm_t->clk_reg23);
}

int xil_FloatToIntAfterDec(float value)
{
	int whole = 0, thousand = 0;
	whole = value;
	thousand = (value - whole)*1000;
	return thousand;
}
int xil_FloatToIntDec(float value)
{
	int whole;
	return whole = value;
}
