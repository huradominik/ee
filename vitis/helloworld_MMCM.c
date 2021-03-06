/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"

#include "mmcm.h"

P_MMCM_STATUS mmcm_status = (P_MMCM_STATUS) XPAR_CLK_WIZ_0_BASEADDR;

P_MMCM_REG mmcm = (P_MMCM_REG) (XPAR_CLK_WIZ_0_BASEADDR + 0x200U);
//P_MMCM_REG mmcm = (P_MMCM_REG) 0x43C00200;



#define MMCM_WIZ_0_INPUT_FREQUENCY 125000000U
// enum get value

int main()
{
    init_platform();

    showMmcmRegisters();
    showMmcmAddrMap();

    setMmcmPll(5, 36, mmcm_frac_0);
    setMmcmCounterOutput(mmcm_channel_0, 4, mmcm_frac_0);
    setMmcmCounterOutput(mmcm_channel_1, 9, mmcm_frac_0);
    setMmcmCounterOutput(mmcm_channel_2, 2, mmcm_frac_0);
    setMmcmCounterOutput(mmcm_channel_3, 4, mmcm_frac_0);

    setMmcmDutyCycle(mmcm_channel_2, 0x2710);
    setMmcmDutyCycle(mmcm_channel_3, 0x1000);

    boolean a = checkFreqOutput();
    setMmcmReconfigure();

    xil_printf("FREQENCY CH0 : %d Hz\n\r", getMmcmFreq(mmcm_channel_0));
    xil_printf("FREQENCY CH1 : %d Hz\n\r", getMmcmFreq(mmcm_channel_1));
    xil_printf("FREQENCY CH2 : %d Hz\n\r", getMmcmFreq(mmcm_channel_2));
	xil_printf("FREQENCY CH3 : %d Hz\n\r", getMmcmFreq(mmcm_channel_3));
	xil_printf("FREQENCY CH4 : %d Hz\n\r", getMmcmFreq(mmcm_channel_4));

	setMmcmDefault();
    setMmcmReconfigure();

    mmcm->clkout1_div = 4;
    mmcm->clkout2_div = 4;
    mmcm->clkout3_div = 10;

    setMmcmReconfigure();

    setMmcmDefault();

    setMmcmRegister(&mmcm->clk_reg0, 0x1F40820);
    setMmcmReconfigure();

    setMmcmRegister(&mmcm->clk_reg0, 0x1F4100C);
    setMmcmReconfigure();

    setMmcmRegister(&mmcm->clk_reg0, 0x1F4200C);
    setMmcmReconfigure();

    //test factory//
    setMmcmRegister(&mmcm->clk_reg0, 0x1F42806);
    setMmcmReconfigure();



    xil_printf("load_sen value: %x \n\r", mmcm->reg23_load_sen);
    xil_printf("drp_saddr value: %x \n\r", mmcm->reg23_drp_saddr);



    cleanup_platform();
    return 0;
}
