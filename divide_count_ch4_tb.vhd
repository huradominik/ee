library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity divide_count_ch4_tb is
end divide_count_ch4_tb;


architecture testBench of divide_count_ch4_tb is

-- SIGNALS DECLARATION --

signal sys_rst : std_logic;

signal clk_in_ch0 : std_logic;
signal clk_in_ch1 : std_logic;
signal clk_in_ch2 : std_logic;
signal clk_in_ch3 : std_logic;

signal clk_out_ch0 : std_logic;
signal clk_out_ch1 : std_logic;
signal clk_out_ch2 : std_logic;
signal clk_out_ch3 : std_logic;

-- END SIGNALS DECLARATION --


--COMPONENT DECLARATION--
	component clk_gen is
		generic (
		BASE_TIME : time := 10ns
		);
		port(
		clk_out : out std_logic
		);
	end component;
	
	component divide_count_ch4 is
		generic(
		DIVIDE_VALUE_CH0 : natural := 10000000;    
		DIVIDE_VALUE_CH1 : natural := 50000000;
		DIVIDE_VALUE_CH2 : natural := 10000000;
		DIVIDE_VALUE_CH3 : natural := 50000000
		);
		port(
		sys_rst : in std_logic;
		clk_in_ch0 : in std_logic;
		clk_in_ch1 : in std_logic;
		clk_in_ch2 : in std_logic;
		clk_in_ch3 : in std_logic;
		clk_out_ch0 : out std_logic;
		clk_out_ch1 : out std_logic;
		clk_out_ch2 : out std_logic;
		clk_out_ch3 : out std_logic
		);
	end component;
	
--END COMPONENT DECLARATION--


begin

-- INSTANCE DECLARATION--

	GEN_0 : clk_gen
	generic map(
		BASE_TIME => 100 ns
	)
	port map(
		clk_out => clk_in_ch0
	);
	
	GEN_1 : clk_gen
	generic map(
		BASE_TIME => 20 ns
	)
	port map(
		clk_out => clk_in_ch1
	);
	
	GEN_2 : clk_gen
	generic map(
		BASE_TIME => 100 ns
	)
	port map(
		clk_out => clk_in_ch2
	);
	
	GEN_3 : clk_gen
	generic map(
		BASE_TIME => 20 ns
	)
	port map(
		clk_out => clk_in_ch3
	);

	
	div_inst : divide_count_ch4
	generic map(
		DIVIDE_VALUE_CH0 => 10000,    
		DIVIDE_VALUE_CH1 => 50000,
		DIVIDE_VALUE_CH2 => 10000,
		DIVIDE_VALUE_CH3 => 50000
	)
	port map(
		sys_rst => sys_rst,
		clk_in_ch0 => clk_in_ch0,
		clk_in_ch1 => clk_in_ch1,
		clk_in_ch2 => clk_in_ch2,
		clk_in_ch3 => clk_in_ch3,
		clk_out_ch0 => clk_out_ch0,
		clk_out_ch1 => clk_out_ch1,
		clk_out_ch2 => clk_out_ch2,
		clk_out_ch3 => clk_out_ch3
	);
-- END INSTANCE DECLARATION--

-- SIMULATION --

process
begin
	sys_rst <= '1';
	wait for 1000 ns;
	sys_rst <= '0';
	wait for 2000 ms;
	
end process;

	
end testBench;
