library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity counter_trig is
	generic(
	CNT_VAL : natural := 50;
	RESET_EDGE : std_logic := '1'
	);							  
	
	port(
	clk : in std_logic;
	rst : in std_logic;
	
	generateout : out std_logic
	);
	
end counter_trig;



architecture counter of counter_trig is

begin

process(clk, rst)

variable counter_value : integer range 0 to CNT_VAL := 0;
constant cnt : integer := CNT_VAL;

begin

if rising_edge(clk) then
	if rst = RESET_EDGE then
		generateout <= '0';
		counter_value := 0;
	else	
		if counter_value = cnt then
			counter_value := 0;
			generateout <= '1';
		else	
			counter_value := counter_value + 1;
			generateout <= '0';			
		end if;	
	end if;
end if;

end process;
end counter;
