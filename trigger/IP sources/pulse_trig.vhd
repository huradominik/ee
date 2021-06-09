library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity pulse_trig is
	generic(
	PULSE_WIDTH : natural := 5000000;
	RESET_EDGE : std_logic := '1';
	ACTIVE_EDGE : std_logic := '1'
	
	);
	port(
	clk : in std_logic;
	rst : in std_logic;
	
	pulse_in  : in std_logic;
	pulse_out : out std_logic
	);
	
end pulse_trig;

architecture pulse_out of pulse_trig is


signal flag_pulse : std_logic;

begin
	
process(clk, rst, pulse_in)

variable active : std_logic := ACTIVE_EDGE;
--constant pulse : integer := PULSE_WIDTH;

begin
	if rising_edge(clk) then
		if rst = RESET_EDGE then
			flag_pulse <= '0';		
		else
			if pulse_in = '1' and active = '1' then
				flag_pulse <= '1';
			elsif pulse_in = '0' and active = '0' then
			    flag_pulse <= '1';
			else flag_pulse <= '0';
			end if;
		end if;
	end if;		
end process;

process(clk, rst, flag_pulse)

variable pulse_duration : integer range 0 to PULSE_WIDTH := 0;
begin

if rising_edge(clk) then
	if rst = RESET_EDGE then
		pulse_duration := 0;
		pulse_out <= '0';
	else
		if flag_pulse = '1' and pulse_duration = 0 then
			pulse_duration := PULSE_WIDTH;
			pulse_out <= '1';
		else if pulse_duration > 0 then
			pulse_duration := pulse_duration - 1;
			pulse_out <= '1';
		else
			pulse_out <= '0';
		end if;
		end if;
	end if;
end if;
			
end process;
	
end pulse_out;
