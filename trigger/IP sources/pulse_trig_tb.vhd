library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pulse_trig_tb is
end pulse_trig_tb;



architecture testBench of pulse_trig_tb is

signal clk : std_logic;
signal rst : std_logic;

signal pulse_in : std_logic;
signal pulse_out : std_logic;


begin
	
	clk_gen_inst : entity work.clk_gen
		generic map(BASE_TIME => 20ns)
		port map(clk_out => clk);
		
	pulse_trig_inst : entity work.pulse_trig
		generic map(PULSE_WIDTH => 50)
		port map(clk => clk, rst => rst, pulse_in => pulse_in, pulse_out => pulse_out);
		
process
begin

rst <= '1';
wait for 100ns;
rst <= '0';
wait for 20 ns;
pulse_in <= '1';
wait for 20 ns;
pulse_in <= '0';
wait for 5010 ns;
pulse_in <= '1';
wait for 20 ns;
pulse_in <= '0';

wait for 5 us;
end process;

	
end testBench;
