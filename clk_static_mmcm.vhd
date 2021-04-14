library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;


entity clk_static_mmcm is 
	port (
	clk_input 	: in std_logic;	-- input clock 
	--
	mmcm_locked : out std_logic;	-- MMCM locked
	--	USER CLOCK --
	spi_clk 	: out std_logic;		-- SPI clock 25 MHz
	lvds_clk 	: out std_logic;		-- CMV clock 600 MHz
	seq_clk 	: out std_logic; 		-- sensor clk 60 MHz
	axi_clk		: out std_logic			-- axi aclk 100 MHz
	);
	
end entity clk_static_mmcm;

architecture CLK_STATIC of clk_static_mmcm is
  
  -- musi byc vivado_pkg --  
  --  attribute KEEP_HIERARCHY of CLK_STATIC : architecture is "TRUE";
    
	signal mmcm_fbin	: std_logic;
	signal mmcm_fbout	: std_logic;

	signal mmcm_spi_clk : std_logic;
	signal mmcm_lvds_clk : std_logic;
	signal mmcm_seq_clk : std_logic;
	signal mmcm_axi_clk	: std_logic;

begin
	mmcm_instance : MMCME2_BASE
	generic map(
	BANDWIDTH => "OPTIMIZED",
	
	CLKIN1_PERIOD => 8.0, -- input 100 MHz
	
	CLKFBOUT_MULT_F => 8.0, -- x12	   1000 MHz
	DIVCLK_DIVIDE => 1,	-- /1
	
	CLKOUT0_DIVIDE_F => 40.0,      -- 1000/25 = 40 
	CLKOUT0_PHASE	=> 0.0,
	
	CLKOUT1_DIVIDE => 3,			-- 1000/2 = 500
	CLKOUT1_PHASE => 0.0,
	
	CLKOUT2_DIVIDE => 18,			-- 1000/20 = 60;
	CLKOUT2_PHASE => 0.0,
	
	CLKOUT3_DIVIDE => 10,			-- 1000/12 = 100;
	CLKOUT3_PHASE => 0.0					 
	)
	port map(
	CLKIN1 => clk_input,
	CLKFBIN => mmcm_fbin,
	CLKFBOUT => mmcm_fbout,
	
	CLKOUT0 => mmcm_spi_clk,
	CLKOUT1 =>	mmcm_lvds_clk,
	CLKOUT2 =>	mmcm_seq_clk,
	CLKOUT3 =>	mmcm_axi_clk,
	
	LOCKED => mmcm_locked,
	PWRDWN => '0',
	RST => '0'
	);
	
	mmcm_fbin <= mmcm_fbout;
	
	BUFG_spi_instance : BUFG
	port map(
	I => mmcm_spi_clk,
	O => spi_clk
	);
	
	BUFG_lvds_instance : BUFG
	port map(
	I => mmcm_lvds_clk,
	O => lvds_clk
	);
	
	BUFG_seq_instance : BUFG
	port map(
	I => mmcm_seq_clk,
	O => seq_clk
	);
	
	BUFG_axi_instance : BUFG
	port map(
	I => mmcm_axi_clk,
	O => axi_clk
	);
	
end CLK_STATIC;




