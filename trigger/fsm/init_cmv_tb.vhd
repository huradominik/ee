library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity init_cmv_tb is
end init_cmv_tb;


architecture testBench of init_cmv_tb is

signal clk : std_logic;
signal rst : std_logic;

signal init_en : std_logic;
signal power_good : std_logic;
signal init_done : std_logic;

begin

clk_gen_inst : entity work.clk_gen
	generic map(BASE_TIME => 10ns)
	port map(clk_out => clk);
	
init_cmv_inst : entity work.init_cmv
	generic map(COUNTER_VALUE => 20)
	port map(
	clk => clk,
	rst_n => rst,
	init_en => init_en,
	power_good => power_good,
	init_done => init_done
	);
	

	process
	begin
		init_en <= '1';
		power_good <= '0';
		rst <= '0';
		wait for 5 ns;
		wait for 10ns;
		rst <= '1';
		wait for 100ns;
		power_good <= '1';
		wait for 100 ns;
		power_good <= '0';
		wait for 10ns;
		power_good <= '1';
		
		wait for 100us;
		
	end process;
	
end testBench;
