library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package BCD_pkg is
	
	type BCD_interface is record
		
		usec_1 : std_logic_vector (3 downto 0);
		usec_2 : std_logic_vector (3 downto 0);
		usec_3 : std_logic_vector (3 downto 0);
	
		msec_1 : std_logic_vector (3 downto 0);
		msec_2 : std_logic_vector (3 downto 0);
		msec_3 : std_logic_vector (3 downto 0);
		
		sec_1 : std_logic_vector (3 downto 0);
		sec_2 : std_logic_vector (2 downto 0);
		
		min_1 : std_logic_vector (3 downto 0);
		min_2 : std_logic_vector (2 downto 0);
		
		hrs_1 : std_logic_vector (3 downto 0);
		hrs_2 : std_logic_vector (1 downto 0);
		
		day_1 : std_logic_vector (3 downto 0);
		day_2 : std_logic_vector (1 downto 0);
		
		month_1 : std_logic_vector (3 downto 0);
		month_2 : std_logic_vector (1 downto 1);
		
		years_1 : std_logic_vector (3 downto 0);
		years_2 : std_logic_vector (3 downto 0);
	
	end record;
end;
	
	package body BCD_pkg is 
		
	end package body;
	