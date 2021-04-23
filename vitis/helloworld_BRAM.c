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
#include "xil_io.h"
#include "xparameters.h"

#include "hw.h"

#define BRAM_BASE_ADDR 0x40000000U

PLED led = (PLED) 0x43C00000;
Pff ff = (Pff) 0x43C00008;
PBUTT butt = (PBUTT) 0x43C00010;
Pff sh = (Pff) 0x43C00014;


typedef struct{
	unsigned int BRAM;
}tbram_;

typedef tbram_ * pbram_;

pbram_ bram = (pbram_) BRAM_BASE_ADDR;

PBRAM pix = (PBRAM) BRAM_BASE_ADDR;



int main()
{
    init_platform();
 print("START\n\n\n\n\n\n");
 print("\r\r\r\r\n\n\n\n");
    unsigned int bram_v = 0;

   // unsigned int ga = 0;
   // unsigned int ro = 0;
   // unsigned int co = 0;

	void compute (unsigned int value_gain, unsigned int base_addr)
	{
		pix = base_addr;
    for (int i=0;i<40;i++)
    {
    	pix->gain = value_gain;
    	pix->row = i+5;
    	xil_printf("value of row : %x \n\r", pix->row);
    	pix->col = i+1;
    	xil_printf("value of col : %x \n\r",pix->col);
    	pix->result = pix->gain * pix->row * pix->col;
    	xil_printf("result : %x \n\r", pix->result);
    	xil_printf(" BRAM ADDRESS : %x \n\r", pix);
    	pix++;
    }
    pix = base_addr;
	}

	compute(1, BRAM_BASE_ADDR);
	print("-----------------------------========= \n\r");
	compute(2, BRAM_BASE_ADDR);
	print("-----------------------------========= \n\r");
	compute(3, BRAM_BASE_ADDR);
	print("-----------------------------========= \n\r");
	compute(4, BRAM_BASE_ADDR);

    for(int i=0;i<30;i++)
    {
    	(bram->BRAM) = bram_v + i;
    	printf("warotsc BRAM [ %i ] = %i \n\r",i, bram->BRAM);
    	bram++;
    	printf("bram : %x \n\r", putnum(bram));
    }
    bram = BRAM_BASE_ADDR;
    for(int i=0; i<30; i++)
    {
    	printf ("odczyt wartosci z pamieci BRAM : %i \n\r", bram->BRAM);
    	bram++;
    }

    unsigned int value0 = 0;
    unsigned int value1 = 0;
    unsigned int value2 = 0;

    unsigned int shift0 = 0x1;

    xil_printf("Value0 = %i\n\r", value0);
    led->LED = 0x10011001;
    led->LED = 0x10101010;
    led->LED = 0x11001100;
    led->LED = 0x10111011;
    led->LED = 0x11101110;
    led->LED = 0x11011101;

    ff->input = 100;
    value0 = ff->output;
    xil_printf("Value0 = %i\n\r", value0);

    ff->input = 200;
    value1 = ff->output;
    xil_printf("Value1 = %i\n\r", value1);

    value2 = value0 * value1;
    xil_printf("value2 = %i\n\r", value2);
    ff->input = value2;

    xil_printf("Value 2 after PL = %i\n\r",ff->output);

    sh->input = 0x4;
    xil_printf("test : %i \n\r", sh->output);
    for(int i=0;i<8;i++)
    {
    	xil_printf("current shift register = %i \n\r", shift0);
    	sh->input = shift0;
    	shift0 = (sh->output) << 1;
    	xil_printf("after compute shift register = %i \n\r", shift0);
    }


    for(;;)
    {
    	if(butt->BUTT_0 == 1)
    	{
    		if(butt ->BUTT_0 == 0)
    		{
    		xil_printf("button0\n\r");
    		}

    	}
    	if(butt->BUTT_1 == 1)
    	{
    		if (butt->BUTT_1 == 0)
    		{
    		xil_printf("button1\n\r");
    		}
    	}
    }
    cleanup_platform();
    return 0;
}
