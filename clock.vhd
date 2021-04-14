library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity clock is
	port (Q : out std_logic);
end clock;

architecture beh of clock is
begin
	process
	variable tq : std_logic := '0';
	constant period : time := 50 ns;
	begin
		wait for period/2;
		tq := not tq;
		Q <= tq;
	end process;
end beh;