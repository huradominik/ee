library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity internal_mode_tb is
end internal_mode_tb;
	
	
architecture testBench of internal_mode_tb is

signal clk : std_logic;
signal rst : std_logic;

signal internal_active : std_logic;
signal bit_mode : std_logic_vector (1 downto 0);
signal internal_done : std_logic;
signal frame_request : std_logic;

begin
	
clk_gen_inst : entity work.clk_gen
	generic map(BASE_TIME => 10ns)
	port map(clk_out => clk);
	
internal_mode_inst : entity work.internal_mode
	port map(
	clk => clk,
	rst_n => rst,
	internal_active => internal_active,
	bit_mode => bit_mode,
	internal_done => internal_done,
	frame_request => frame_request
	);
	
	
process
begin
	
	internal_active <= '0';
	bit_mode <= "00";
	rst <= '0';
	wait for 5ns;
	wait for 50ns;
	rst <= '1';
	wait for 50ns;
	bit_mode <= "01";
	wait for 10ns;
	bit_mode <= "10";
	wait for 10ns;
	bit_mode <= "00";
	wait for 10ns;
	internal_active <= '1';
	wait until internal_done = '1';
	internal_active <= '0';
	wait for 100ns;
	
	
end process;

end testBench;

	