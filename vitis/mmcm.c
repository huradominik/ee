
#include "xil_printf.h"
#include "xparameters.h"
#include "mmcm.h"

#define XPAR_CLK_WIZ_0_PRIM_IN_FREQ_UINT 	125000000
#define XPAR_CLK_WIZ_0_PRIM_VCO_MAX		1200000000
#define XPAR_CLK_WIZ_0_PRIM_VCO_MIN 	600000000
#define XPAR_CLK_WIZ_0_PRIM_PFD_MAX 	450000000
#define XPAR_CLK_WIZ_0_PRIM_PFD_MIN 	10000000

P_MMCM_STATUS mmcm_status_t = (P_MMCM_STATUS) XPAR_CLK_WIZ_0_BASEADDR;
P_MMCM_REG mmcm_t = (P_MMCM_REG) (XPAR_CLK_WIZ_0_BASEADDR + 0x200U);

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
			mmcm_t->clkfbout_mult, mmcm_t->clkfbout_frac))
		{
		while(!mmcm_status_t->status_locked)
		{
			xil_printf("Durring configuration LOCKED = '0'\n\r");
		}
		mmcm_t->clk_reg23 = 0x3;
		xil_printf("SUCCESFULL MMCM CONFIGURATION\n\r");
		} else
		{
			xil_printf("Configuration FAIL!! \n\r");
		}
}

void setMmcmRegisters(P_MMCM_REG reg, unsigned int value)
{


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
