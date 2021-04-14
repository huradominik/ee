# Cora Z7 board pinouts #

## CLOCK CREATES ##
set_property  PACKAGE_PIN H16 [get_ports  clk_in ]
set_property  IOSTANDARD LVCMOS33  [get_ports  clk_in ]
create_clock  -name sys_clk_pin -period 8.000 -waveform {0.000 4.000} [get_ports  clk_in ]


## BUTTONS ##
#set_property  PACKAGE_PIN D20  [get_ports  button_0 ]
#set_property  PACKAGE_PIN D19  [get_ports  button_1 ]
#set_property  IOSTANDARD LVCMOS33  [get_ports  button_0 ]
#set_property  IOSTANDARD LVCMOS33  [get_ports  button_1 ]


## DIODS PROPERTIES ##
#set_property  PACKAGE_PIN N15  [get_ports  dioda_R_0 ]
#set_property  IOSTANDARD LVCMOS33  [get_ports  dioda_R_0 ]
#set_property  PACKAGE_PIN G17  [get_ports  dioda_G_0 ]
#set_property  IOSTANDARD LVCMOS33  [get_ports  dioda_G_0 ]
#set_property  PACKAGE_PIN L15  [get_ports  dioda_B_0 ]
#set_property  IOSTANDARD LVCMOS33  [get_ports  dioda_B_0 ]

#set_property  PACKAGE_PIN M15  [get_ports  dioda_R_1 ]
#set_property  IOSTANDARD LVCMOS33  [get_ports  dioda_R_1 ]
#set_property  PACKAGE_PIN L14  [get_ports  dioda_G_1 ]
#set_property  IOSTANDARD LVCMOS33  [get_ports  dioda_G_1 ]
#set_property  PACKAGE_PIN G14  [get_ports  dioda_B_1 ]
#set_property  IOSTANDARD LVCMOS33  [get_ports  dioda_B_1 ]
  


#Pmod high-speed connectors
## Pmod Header JA
## SET PACKAGE_PIN YXX
#set_property  PACKAGE_PIN Y18  [get_ports  clk_axi ]; #IO_L17P_T2_34 Sch=ja_p[1]           # ja[0]
set_property  PACKAGE_PIN Y19  [get_ports  clk_lvds ]; #IO_L17N_T2_34 Sch=ja_n[1]           # ja[1]
#set_property  PACKAGE_PIN Y16  [get_ports  clk_spi ]; #IO_L7P_T1_34 Sch=ja_p[2]            # ja[2]
#set_property  PACKAGE_PIN Y17  [get_ports  clk_seq_n ]; #IO_L7N_T1_34 Sch=ja_n[2]            # ja[3]
set_property  PACKAGE_PIN U18  [get_ports  clk_axi ]; #IO_L12P_T1_MRCC_34 Sch=ja_p[3]      # ja[4]
#set_property PACKAGE_PIN U19  [get_ports  ja[5] ]; #IO_L12N_T1_MRCC_34 Sch=ja_n[3]     # ja[5]
set_property  PACKAGE_PIN W18  [get_ports  clk_spi ]; #IO_L22P_T3_34 Sch=ja_p[4]           # ja[6]
#set_property PACKAGE_PIN W19  [get_ports  ja[7] ]; #IO_L22N_T3_34 Sch=ja_n[4]          # ja[7]

## IOSTANDARD YYYYXXXX
#set_property IOSTANDARD LVCMOS25 [get_ports  clk_axi ];   # ja[0]
set_property IOSTANDARD LVCMOS25 [get_ports  clk_lvds];    # ja[1]
#set_property IOSTANDARD LVCMOS25 [get_ports  clk_spi ];    # ja[2]
#set_property IOSTANDARD LVDS_25 [get_ports  clk_seq_n ];    # ja[3]
set_property IOSTANDARD LVCMOS25 [get_ports  clk_axi ];      # ja[4]
#set_property IOSTANDARD LVDS_25 [get_ports  clk_lvds_p ];   # ja[5]
set_property IOSTANDARD LVCMOS25 [get_ports  clk_spi ];      # ja[6]
#set_property IOSTANDARD LVDS_25 [get_ports  clk_axi ];      # ja[7]

## Pmod Header JB
#set_property PACKAGE_PIN W14  [get_ports  clk_lvds_p ]; #IO_L8P_T1_34 Sch=jb_p[1]          jb[0]
#set_property PACKAGE_PIN Y14  [get_ports  clk_lvds_n ]; #IO_L8N_T1_34 Sch=jb_n[1]          jb[1]
#set_property PACKAGE_PIN T11  [get_ports  clk_seq_p  ]; #IO_L1P_T0_34 Sch=jb_p[2]          jb[2]
#set_property PACKAGE_PIN T10  [get_ports  clk_seq_n  ]; #IO_L1N_T0_34 Sch=jb_n[2]          jb[3]
#set_property PACKAGE_PIN V16  [get_ports clk_lvds_p]; #IO_L18P_T2_34 Sch=jb_p[3]         jb[4]
#set_property PACKAGE_PIN W16  [get_ports clk_lvds_n]; #IO_L18N_T2_34 Sch=jb_n[3]         jb[5]
set_property PACKAGE_PIN V12  [get_ports clk_seq_p]; #IO_L4P_T0_34 Sch=jb_p[4]          jb[6]
set_property PACKAGE_PIN W13  [get_ports clk_seq_n]; #IO_L4N_T0_34 Sch=jb_n[4]          jb[7]

## IOSTANDARD YYYYXXXX
#set_property IOSTANDARD LVDS_25 [get_ports  clk_lvds_p ];   # jb[0]
#set_property IOSTANDARD LVDS_25 [get_ports  clk_lvds_n ];   # jb[1]
set_property IOSTANDARD LVDS_25 [get_ports  clk_seq_p ];    # jb[2]
set_property IOSTANDARD LVDS_25 [get_ports  clk_seq_n ];    # jb[3]
#set_property IOSTANDARD LVDS_25 [get_ports  clk_spi ];      # jb[4]
#set_property IOSTANDARD LVDS_25 [get_ports  clk_lvds_p ];   # jb[5]
#set_property IOSTANDARD LVDS_25 [get_ports  clk_axi ];      # jb[6]
#set_property IOSTANDARD LVDS_25 [get_ports  clk_axi ];      # jb[7]


# UART PS
#MIO 500 3,3V  --c5 rx , c8 tx
#set_property PACKAGE_PIN C5 [get_ports uart_rtl_0_rxd]
#set_property IOSTANDARD LVCMOS33 [get_ports uart_rtl_0_rxd]
#set_property PACKAGE_PIN C8 [get_ports uart_rtl_0_txd]
#set_property IOSTANDARD LVCMOS33 [get_ports uart_rtl_0_txd]


#set_property SEVERITY button_0
#set_property SEVERITY button_1
#set_property SEVERITY dioda_0
#set_property SEVERITY dioda_1

#set_property IOSTANDARD LVCMOS18 [get_ports button_0]
#set_property IOSTANDARD LVCMOS18 [get_ports button_1]
#set_property IOSTANDARD LVCMOS18 [get_ports dioda_0]
#set_property IOSTANDARD LVCMOS18 [get_ports dioda_1]

#set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
#set_property SEVERITY {Warning} [get_drc_checks UCIO-1]