library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- wait 1us for allowe reset sequence
-- internal counter



entity init_cmv is
	generic(COUNTER_VALUE : natural := 1000);
	port(
	clk : in std_logic;
	rst_n : in std_logic;
	
	--itr_en : in std_logic;   -- chyba wewnêtrzny licznik
	init_en : in std_logic;
	power_good : in std_logic;
	
	init_done : out std_logic
	
	);
end init_cmv;


architecture initialization of init_cmv is

begin

	process(clk)
	
	variable cnt : integer range 0 to COUNTER_VALUE := 0;
	variable init_done_v : std_logic;
	begin
		
	if rising_edge(clk) then
		if rst_n = '0' then
			init_done_v := '0';
			cnt := 0;
		else
			if(init_en = '1' and power_good = '1') then
				if(cnt < COUNTER_VALUE) then
					cnt := cnt + 1;
					init_done_v := '0';
				else
					cnt := 0;
					init_done_v := '1';
				end if;
			else
				cnt := 0;
				init_done_v := '0';
			end if;
		end if;	
	end if;
	
	init_done <= init_done_v;
	
	end process;

	
end initialization;