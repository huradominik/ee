library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_SIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

library UNISIM;
use UNISIM.VCOMPONENTS.all;

entity clk_static_mmcm_top is
port(
--INPUTS--
clk_in : in std_logic;
--OUTPUTS--
clk_spi : out std_logic;
clk_lvds : out std_logic;
--clk_lvds_p : out std_logic;
--clk_lvds_n : out std_logic;
clk_seq_p : out std_logic;
clk_seq_n : out std_logic;
clk_axi : out std_logic

);
end entity;


architecture top of clk_static_mmcm_top is

-- SIGNAL DECLARATIONS --
signal clk_in_r : std_logic;
signal clk_out_bufg : std_logic;
signal mmcm_locked_r : std_logic;
signal lvds_clk_r : std_logic;
signal spi_clk_r : std_logic;
signal seq_clk_r : std_logic;
signal axi_clk_r : std_logic;

-- COMPONENTS DECLARATIONS --

component clk_static_mmcm is
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
    -- CAST INSTANCE --
    ibuf_inst : IBUF
    port map(
    O => clk_in_r,
    I => clk_in
    );
    
	mmcm_inst : clk_static_mmcm 
	port map(
	clk_input => clk_in_r,	 
	mmcm_locked => mmcm_locked_r,
	spi_clk => spi_clk_r,	
	lvds_clk => lvds_clk_r, 
	seq_clk => seq_clk_r,	
	axi_clk	=> axi_clk_r	
	);
	
    OBUF_spi_inst : OBUF
    port map(
    O => clk_spi,
    I => spi_clk_r
    );
    
    OBUF_axi_inst : OBUF
    port map(
    O => clk_axi,
    I => axi_clk_r
    );
 
 
    OBUF_lvds_inst : OBUF
    port map(
    O => clk_lvds,
    I => lvds_clk_r
    );   
--   OBUFDS_lvds_inst : OBUFDS
--   port map(
--   O => clk_lvds_p,
--   OB => clk_lvds_n,
--   I => lvds_clk_r
--   );
   
   OBUFDS_seq_inst : OBUFDS
   port map(
   O => clk_seq_p,
   OB => clk_seq_n,
   I => seq_clk_r
   ); 
	
end top;




