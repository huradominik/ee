library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity seq_reset_tb is
end seq_reset_tb;



architecture testBench of seq_reset_tb is

signal clk : std_logic;
signal rst : std_logic;
signal rst_active : std_logic;
signal rst_done : std_logic;
signal sys_res_n : std_logic;

begin
	
clk_gen_inst : entity work.clk_gen
	generic map(BASE_TIME => 10ns)
	port map(clk_out => clk);
	
seq_reset_inst : entity work.seq_reset
	generic map(COUNTER_VALUE => 20)
	port map(
	clk => clk,
	rst_n => rst,
	rst_active => rst_active,
	rst_done => rst_done,
	sys_res_n => sys_res_n
	);
	
process
begin
rst <= '0';
rst_active <= '0';
wait for 5ns;
wait for 40ns;
rst <= '1';
wait for 50ns;
rst_active <= '1';
wait for 300 ns;
rst_active <= '0';
wait for 50ns;
rst_active <= '1';
wait for 900ns;
	
end process;
	
end testBench;

