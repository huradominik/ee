library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_SIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

library UNISIM;
use UNISIM.VCOMPONENTS.all;

entity clk_top is
end entity;


architecture top of clk_top is

-- SIGNAL DECLARATIONS --
signal clk_in_r : std_logic;
signal clk_out_bufg : std_logic;
signal mmcm_locked_r : std_logic;
signal lvds_clk_r : std_logic;
signal spi_clk_r : std_logic;
signal seq_clk_r : std_logic;
signal axi_clk_r : std_logic;

-- COMPONENTS DECLARATIONS --
component clk_gen is
	generic(BASE_TIME : time := 10 ns);
	port (clk_out : out std_logic);
end component;

component clk_mmcm is
	port (
	clk_input : in std_logic;
	mmcm_locked : out std_logic;
	spi_clk : out std_logic;
	lvds_clk : out std_logic;
	seq_clk : out std_logic;
	axi_clk : out std_logic
	);
end component;



begin
	clk_gen_inst : clk_gen
	generic map(BASE_TIME => 10 ns)
	port map(
	clk_out => clk_in_r
	);

	mmcm_inst : clk_mmcm 
	port map(
	clk_input => clk_out_bufg,	 
	mmcm_locked => mmcm_locked_r,
	spi_clk => spi_clk_r,	
	lvds_clk => lvds_clk_r, 
	seq_clk => seq_clk_r,	
	axi_clk	=> axi_clk_r	
	);
	
	bufg_inst1 : BUFG
	port map(
	I => clk_in_r,
	O => clk_out_bufg
	);
	-- SIMULATIONS VALUES --

	
end top;




