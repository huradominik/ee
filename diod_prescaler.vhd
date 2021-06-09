library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity diod_prescaler is
	generic(
		INPUT_FREQUENCY : integer := 100000000;	 -- value input frequency
		DUTY_CYCLE : integer := 2;  -- duty cycle on %
		NUMBER_OF_LED : integer := 6;
		RESET_EDGE : std_logic := '0' 
		);
	port(
		clk_in : in std_logic;
		rst_n  : in std_logic;
		led_in : in std_logic_vector ((NUMBER_OF_LED - 1) downto 0);
		led_out : out std_logic_vector ((NUMBER_OF_LED -1) downto 0)
		);
end diod_prescaler;

architecture beh of diod_prescaler is

	signal led_in_r : std_logic_vector ((NUMBER_OF_LED - 1) downto 0);
	signal clk_div : std_logic;
	--signal led_out_r : std_logic_vector ((NUMBER_OF_LED - 1) downto 0);
	
begin
	
	led_in_r <= led_in;
	
	-- SET PROPER PRESCALER VALUE --
	process(clk_in)
	
	--we/1000 = prescaler_divide == 1000 HZ
	variable divide_count : integer range 0 to (INPUT_FREQUENCY/10000) :=0;
	begin
		if rising_edge(clk_in) then
			if rst_n = RESET_EDGE then
				divide_count := 0;
				clk_div <= '0';
			else		
				if divide_count < (INPUT_FREQUENCY/10000)/2 then
					clk_div <= '0';
				else
				    clk_div <= '1';
				end if;
				if divide_count = (INPUT_FREQUENCY/10000) then
				    divide_count := 0;
				else
				    divide_count := divide_count + 1;
				end if;
			end if;
		end if;
	end process;
	
	process(clk_in, clk_div, led_in_r)
	
	variable presc_count : integer range 0 to 100 := 0;
	
	begin
		if rising_edge(clk_div) then
			for i in 0 to NUMBER_OF_LED-1 loop
				if presc_count < (DUTY_CYCLE) and led_in_r(i) = '1' then
					led_out(i) <= '1';
				else
					led_out(i) <= '0';
				end if;
			end loop;
			presc_count := presc_count + 1;
		end if;		
	end process;
	
end beh;

	