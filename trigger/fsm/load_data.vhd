library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity load_data is
	generic(
	DATA_WIDTH : natural := 32;
	ADDR_WIDTH : natural := 8;
	SPI_NUMBER_REGISTES : natural 128
	);
	
	port(
	clk : in std_logic;
	rst_n : in std_logic;
	
	-- control FSM												  -- wys³anie request i potem odbiór
	ld_active : in std_logic;  -- sched_active
	--ld_request : out std_logic; 
	ld_done : out std_logic;   -- sched_done
	
	
	-- outputs flags to control FSM	
	--trig_enable : out std_logic;
	--cmp_flag : out std_logic;
	--test_flag : out std_logic;
	--exposure_flag : out std_logic;
	--spi_diff : out std_logic;
	
	
	-- temporaty input registers from AXI
	
	trigg_settings : in std_logic_vector (DATA_WIDTH-1 downto 0);
	
	trigg_exp_time : in std_logic_vector (DATA_WIDTH-1 downto 0);
	
	
	-- temporary load compare time (BCD)
	--trigg_set_time_lsb : in std_logic_vector (DATA_WIDTH-1 downto 0);
	--trigg_set_time_msb : in std_logic_vector (DATA_WIDTH-1 downto 0);
	);
	
end load_data;

signal ld_done_r : std_logic;
signal trig_enable_r : std_logic;
signal cmp_flag_r : std_logic;
signal test_flag_r : std_logic;
signal exposure_flag_r : std_logic;
signal spi_diff_r : std_logic;

architecture ld_cmv of load_data is



begin 
	
	process(clk, ld_active)
	if rising_edge(clk) then
		if rst_n = '0' then
			ld_done_r <= '0';
			trig_enable_r <= '0';
			cmp_flag_r <= '0';
			test_flag_r <= '0';
			exposure_flag_r <= '0';
			spi_diff_r <= '0';
			

	
	
end ld_cmv;