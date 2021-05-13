library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.BCD_pkg.ALL;

entity rtc_cmv_tb is
end entity;



architecture testBench of rtc_cmv_tb is

signal clk : std_logic;	  -- 50MHz
signal rst : std_logic;

signal itr_in : std_logic; -- 1MHz


signal	bcd_in_usec : std_logic_vector (11 downto 0);
signal	bcd_in_msec : std_logic_vector (11 downto 0);
signal	bcd_in_sec : std_logic_vector (6 downto 0);
signal	bcd_in_min : std_logic_vector (6 downto 0);
signal	bcd_in_hrs : std_logic_vector (5 downto 0);
signal	bcd_in_day : std_logic_vector (5 downto 0);
signal	bcd_in_month : std_logic_vector (4 downto 0);
signal	bcd_in_years : std_logic_vector (7 downto 0);

signal load_enable : std_logic;

signal	bcd_out_usec : std_logic_vector (11 downto 0);
signal	bcd_out_msec : std_logic_vector (11 downto 0);
signal	bcd_out_sec : std_logic_vector (6 downto 0);
signal	bcd_out_min : std_logic_vector (6 downto 0);
signal	bcd_out_hrs : std_logic_vector (5 downto 0);
signal	bcd_out_day : std_logic_vector (5 downto 0);
signal	bcd_out_month : std_logic_vector (4 downto 0);
signal	bcd_out_years : std_logic_vector (7 downto 0);




signal count : integer range 0 to 50;

begin
	
	clock_inst : entity work.clk_gen
		generic map(BASE_TIME => 20 ns) --50MHz
		port map(clk_out => clk);
	
	process(clk, rst)
	
	begin
		
		if rising_edge(clk) then
			if rst = '1' then
				count <= 0;
			else
				if count = 50 then
					count <= 0;
					itr_in <= '1';
				else
					count <= count + 1;
					itr_in <= '0';
				end if;
			end if;
		end if;
				
	end process;
			
		
	rtc_cmv_inst : entity work.rtc_module
		generic map(RESET_EDGE => '1')
		port map(
			clk => clk,
			rst => rst,
			itr_in => itr_in,
		
			bcd_in_usec => bcd_in_usec,
			bcd_in_msec => bcd_in_msec,
			bcd_in_sec => bcd_in_sec,	
			bcd_in_min => bcd_in_min,
			bcd_in_hrs => bcd_in_hrs,
			bcd_in_day => bcd_in_day,
			bcd_in_month => bcd_in_month,
			bcd_in_years => bcd_in_years,
								
			load_enable => load_enable,
			
			bcd_out_usec => bcd_out_usec,
			bcd_out_msec => bcd_out_msec,
			bcd_out_sec => bcd_out_sec,	
			bcd_out_min => bcd_out_min,
			bcd_out_hrs => bcd_out_hrs,
			bcd_out_day => bcd_out_day,
			bcd_out_month => bcd_out_month,
			bcd_out_years => bcd_out_years

			);

	process
	
	begin
		load_enable <= '0';
		rst <= '1';

		bcd_in_usec <= X"995";
		bcd_in_msec <= X"999";
		bcd_in_sec <= "101" & X"9";
		bcd_in_min <= "101" & X"9";
		bcd_in_hrs <= "10" & X"3";  
		bcd_in_day <= "11" & X"1";
		bcd_in_month <= '1' & X"2";
		bcd_in_years <= X"66";

		
		wait for 100 ns;
		rst <= '0';
		wait for 40 ns;
		load_enable <= '1';
		wait for 20 ns;
		load_enable <= '0';
		
		wait for 100 us;
		wait for 1000 ms;
		
	end process;	
		
end testBench;
	