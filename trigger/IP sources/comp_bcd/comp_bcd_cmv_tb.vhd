library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.BCD_pkg.all;


entity comp_bcd_cmv_tb is
end comp_bcd_cmv_tb;


architecture testBench of comp_bcd_cmv_tb is

signal clk : std_logic;
signal rst : std_logic;

signal load_enable : std_logic;
signal itr_in : std_logic;

	--input from REAL TIME --
signal	bcd_real_usec : std_logic_vector(11 downto 0);
signal	bcd_real_msec : std_logic_vector(11 downto 0);
signal	bcd_real_sec  : std_logic_vector(6 downto 0);
signal	bcd_real_min : std_logic_vector(6 downto 0);
signal	bcd_real_hrs : std_logic_vector(5 downto 0);
signal	bcd_real_day : std_logic_vector(5 downto 0);
signal	bcd_real_month : std_logic_vector(4 downto 0);
signal	bcd_real_year : std_logic_vector (7 downto 0);
	
	 
	
	--input from SET TIME--
signal	bcd_set_usec : std_logic_vector(11 downto 0);
signal	bcd_set_msec : std_logic_vector(11 downto 0);
signal	bcd_set_sec : std_logic_vector(6 downto 0);
signal	bcd_set_min : std_logic_vector(6 downto 0);
signal	bcd_set_hrs : std_logic_vector(5 downto 0);
signal	bcd_set_day : std_logic_vector(5 downto 0);
signal	bcd_set_month : std_logic_vector(4 downto 0);
signal	bcd_set_year : std_logic_vector(7 downto 0);  

signal trigger : std_logic;


begin

process(clk, rst)
	variable count : integer range 0 to 50;
	begin
		if rising_edge(clk) then
			if rst = '1' then
				count := 0;
			else
				if count = 50 then
					count := 0;
					itr_in <= '1';
				else
					count := count + 1;
					itr_in <= '0';
				end if;
			end if;
		end if;
				
	end process;
	
clk_gen_inst : entity work.clk_gen
	generic map(BASE_TIME => 20 ns)
	port map(clk_out => clk);

rtc_cmv_inst : entity work.rtc_module
	port map(
	clk => clk,
	rst => rst,
	
	itr_in => itr_in,
	
	bcd_in_usec => X"500",
	bcd_in_msec => X"444",
	bcd_in_sec => "010" & X"5",
	bcd_in_min => "100" & X"3",
	bcd_in_hrs => "01" & X"9",
	bcd_in_day => "10" & X"8",
	bcd_in_month => "0" & X"6",
	bcd_in_years => X"21",
		
	
	load_enable => load_enable,

	bcd_out_usec => bcd_real_usec,
	bcd_out_msec => bcd_real_msec,
	bcd_out_sec => bcd_real_sec,
	bcd_out_min => bcd_real_min,
	bcd_out_hrs => bcd_real_hrs,
	bcd_out_day => bcd_real_day,
	bcd_out_month => bcd_real_month,
	bcd_out_years => bcd_real_year
	);
	
comparator_cmv_inst : entity work.comp_bcd_cmv 
	port map(
	clk => clk,
	rst => rst,
	bcd_real_usec => bcd_real_usec,
	bcd_real_msec => bcd_real_msec,
	bcd_real_sec  => bcd_real_sec,
	bcd_real_min => bcd_real_min,
	bcd_real_hrs => bcd_real_hrs,
	bcd_real_day => bcd_real_day,
	bcd_real_month => bcd_real_month,
	bcd_real_year => bcd_real_year,
	
	--input from SET TIME--
	bcd_set_usec => bcd_set_usec,
	bcd_set_msec => bcd_set_msec,
	bcd_set_sec => bcd_set_sec,
	bcd_set_min => bcd_set_min,
	bcd_set_hrs => bcd_set_hrs,
	bcd_set_day => bcd_set_day,
	bcd_set_month => bcd_set_month,
	bcd_set_year => bcd_set_year,
	
	trigger => trigger
	);
	
process
begin
	
	rst <= '1';
	wait for 100 ns;
	rst <= '0';
	wait for 100 ns;
	load_enable <= '1';
	wait for 20 ns;
	load_enable <= '0';
	--load enable <= '0';
	bcd_set_usec <= X"550";
	bcd_set_msec <= X"444";
	bcd_set_sec  <= "010" & X"5";
	bcd_set_min <= "100" & X"3";
	bcd_set_hrs <= "01" & X"9";
	bcd_set_day <= "10" & X"8";
	bcd_set_month <= "0" & X"6";
	bcd_set_year <= X"21";

	wait for 100ms;
	
	wait for 200ms;
	
end process;

end testBench;
