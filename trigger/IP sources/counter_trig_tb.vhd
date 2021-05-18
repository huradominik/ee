library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity counter_trig_tb is
end counter_trig_tb;

architecture testBench of counter_trig_tb is

signal clk : std_logic;
signal rst : std_logic;

signal generateout : std_logic;


begin
	
	clk_gen_inst : entity work.clk_gen
	generic map(BASE_TIME => 20ns)
	port map(clk_out => clk);

	counter_trig_inst : entity work.counter_trig
	generic map (CNT_VAL => 50)
	port map(clk => clk, rst => rst, generateout => generateout);
		
				

process
begin
	rst <= '1';
	wait for 100 ns;
	rst <= '0';
	wait for 10ms;
	
end process;
end testBench;
