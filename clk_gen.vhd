library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity clk_gen is
	generic (BASE_TIME : time := 10ns
	);
	port ( clk_out : out std_logic);
	
end clk_gen;

architecture beh of clk_gen is

begin
	process
	variable tq : std_logic := '0';
	constant period : time := BASE_TIME;
	
	begin
		wait for period/2;
		tq := not tq;
		clk_out <= tq;
	end process;
end beh;

	
	
	