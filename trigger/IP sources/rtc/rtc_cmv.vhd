-- LICZNIK (RTC) w kodzie BCD 
-- dopisaæ uwzglêdnienie iloœci dni w ka¿dym miesi¹cu (przestêpne)
-- dopisaæ okreœlenie roku przestêpnego


library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

use work.BCD_pkg.ALL;

entity rtc_module is
	generic(
	RESET_EDGE : std_logic := '1'
	);
	port(
	clk : in std_logic;
	rst : in std_logic;
	
	itr_in : in std_logic;
	
	bcd_in_usec : in std_logic_vector (11 downto 0);
	bcd_in_msec : in std_logic_vector (11 downto 0);
	bcd_in_sec : in std_logic_vector (6 downto 0);
	bcd_in_min : in std_logic_vector (6 downto 0);
	bcd_in_hrs : in std_logic_vector (5 downto 0);
	bcd_in_day : in std_logic_vector (5 downto 0);
	bcd_in_month : in std_logic_vector (4 downto 0);
	bcd_in_years : in std_logic_vector (7 downto 0);
		
	
	load_enable : in std_logic;

	bcd_out_usec : out std_logic_vector (11 downto 0);
	bcd_out_msec : out std_logic_vector (11 downto 0);
	bcd_out_sec : out std_logic_vector (6 downto 0);
	bcd_out_min : out std_logic_vector (6 downto 0);
	bcd_out_hrs : out std_logic_vector (5 downto 0);
	bcd_out_day : out std_logic_vector (5 downto 0);
	bcd_out_month : out std_logic_vector (4 downto 0);
	bcd_out_years : out std_logic_vector (7 downto 0)
	
	);
	
end rtc_module;

architecture rtc of rtc_module is

signal bcd_t : BCD_interface;
signal itr_in_t : std_logic;

-- alias bcd input
alias bcd_in_usec_1 : std_logic_vector(3 downto 0) is bcd_in_usec(3 downto 0);
alias bcd_in_usec_2 : std_logic_vector(3 downto 0) is bcd_in_usec(7 downto 4);
alias bcd_in_usec_3 : std_logic_vector(3 downto 0) is bcd_in_usec(11 downto 8);

alias bcd_in_msec_1 : std_logic_vector(3 downto 0) is bcd_in_msec(3 downto 0);
alias bcd_in_msec_2 : std_logic_vector(3 downto 0) is bcd_in_msec(7 downto 4);
alias bcd_in_msec_3 : std_logic_vector(3 downto 0) is bcd_in_msec(11 downto 8);

alias bcd_in_sec_1 : std_logic_vector(3 downto 0) is bcd_in_sec(3 downto 0);
alias bcd_in_sec_2 : std_logic_vector(2 downto 0) is bcd_in_sec(6 downto 4);

alias bcd_in_min_1 : std_logic_vector(3 downto 0) is bcd_in_min(3 downto 0);
alias bcd_in_min_2 : std_logic_vector(2 downto 0) is bcd_in_min(6 downto 4);

alias bcd_in_hrs_1 : std_logic_vector(3 downto 0) is bcd_in_hrs(3 downto 0);
alias bcd_in_hrs_2 : std_logic_vector(1 downto 0) is bcd_in_hrs(5 downto 4);

alias bcd_in_day_1 : std_logic_vector(3 downto 0) is bcd_in_day(3 downto 0);
alias bcd_in_day_2 : std_logic_vector(1 downto 0) is bcd_in_day(5 downto 4);

alias bcd_in_month_1 : std_logic_vector(3 downto 0) is bcd_in_month(3 downto 0);
alias bcd_in_month_2 : std_logic_vector(1 downto 1) is bcd_in_month(4 downto 4);

alias bcd_in_years_1 : std_logic_vector(3 downto 0) is bcd_in_years(3 downto 0);
alias bcd_in_years_2 : std_logic_vector(3 downto 0) is bcd_in_years(7 downto 4);

-- alias bcd output

alias bcd_out_usec_1 : std_logic_vector(3 downto 0) is bcd_out_usec(3 downto 0);
alias bcd_out_usec_2 : std_logic_vector(3 downto 0) is bcd_out_usec(7 downto 4);
alias bcd_out_usec_3 : std_logic_vector(3 downto 0) is bcd_out_usec(11 downto 8);

alias bcd_out_msec_1 : std_logic_vector(3 downto 0) is bcd_out_msec(3 downto 0);
alias bcd_out_msec_2 : std_logic_vector(3 downto 0) is bcd_out_msec(7 downto 4);
alias bcd_out_msec_3 : std_logic_vector(3 downto 0) is bcd_out_msec(11 downto 8);

alias bcd_out_sec_1 : std_logic_vector(3 downto 0) is bcd_out_sec(3 downto 0);
alias bcd_out_sec_2 : std_logic_vector(2 downto 0) is bcd_out_sec(6 downto 4);

alias bcd_out_min_1 : std_logic_vector(3 downto 0) is bcd_out_min(3 downto 0);
alias bcd_out_min_2 : std_logic_vector(2 downto 0) is bcd_out_min(6 downto 4);

alias bcd_out_hrs_1 : std_logic_vector(3 downto 0) is bcd_out_hrs(3 downto 0);
alias bcd_out_hrs_2 : std_logic_vector(1 downto 0) is bcd_out_hrs(5 downto 4);

alias bcd_out_day_1 : std_logic_vector(3 downto 0) is bcd_out_day(3 downto 0);
alias bcd_out_day_2 : std_logic_vector(1 downto 0) is bcd_out_day(5 downto 4);

alias bcd_out_month_1 : std_logic_vector(3 downto 0) is bcd_out_month(3 downto 0);
alias bcd_out_month_2 : std_logic_vector(1 downto 1) is bcd_out_month(4 downto 4);

alias bcd_out_years_1 : std_logic_vector(3 downto 0) is bcd_out_years(3 downto 0);
alias bcd_out_years_2 : std_logic_vector(3 downto 0) is bcd_out_years(7 downto 4);
begin
	
--load iterrupt input
	
-- load bcd value from external place --
-- set based rtc time --


--BCD carry --

process(clk, rst, bcd_t)

variable usec_ac_1 : std_logic := '0';	
variable usec_ac_2 : std_logic := '0';
variable usec_ac_3 : std_logic := '0';
variable msec_ac_1 : std_logic := '0';
variable msec_ac_2 : std_logic := '0';
variable msec_ac_3 : std_logic := '0';
variable sec_ac_1 : std_logic  := '0';
variable sec_ac_2 : std_logic  := '0';
variable min_ac_1 : std_logic  := '0';
variable min_ac_2 : std_logic  := '0';
variable hrs_ac_1 : std_logic  := '0';
variable hrs_ac_2 : std_logic  := '0';
variable day_ac_1 : std_logic  := '0';
variable day_ac_2 : std_logic  := '0';
variable month_ac_1 : std_logic := '0';
variable month_ac_2 : std_logic := '0';
variable years_ac_1 : std_logic := '0';
variable years_ac_2 : std_logic := '0';

begin

if rising_edge(clk) then
	if rst = RESET_EDGE then
		bcd_t.usec_1 <= (others => '0');
		bcd_t.usec_2 <= (others => '0');
		bcd_t.usec_3 <= (others => '0');
		bcd_t.msec_1 <= (others => '0');
		bcd_t.msec_2 <= (others => '0');
		bcd_t.msec_3 <= (others => '0');
		bcd_t.sec_1 <= (others => '0');
		bcd_t.sec_2 <= (others => '0');
		bcd_t.min_1 <= (others => '0');
		bcd_t.min_2 <= (others => '0');
		bcd_t.hrs_1 <= (others => '0');
		bcd_t.hrs_2 <= (others => '0');
		bcd_t.day_1 <= (others => '0');
		bcd_t.day_2 <= (others => '0');
		bcd_t.month_1 <= (others => '0');
		bcd_t.month_2 <= (others => '0');
		bcd_t.years_1 <= (others => '0');
		bcd_t.years_2 <= (others => '0');
		itr_in_t <= '0';
	else
		if load_enable = '1' then
			bcd_t.usec_1 <= bcd_in_usec_1; 
            bcd_t.usec_2 <= bcd_in_usec_2;
            bcd_t.usec_3 <= bcd_in_usec_3; 
            
            bcd_t.msec_1 <= bcd_in_msec_1; 
            bcd_t.msec_2 <= bcd_in_msec_2; 
            bcd_t.msec_3 <= bcd_in_msec_3; 
                
            bcd_t.sec_1 <= bcd_in_sec_1; 
            bcd_t.sec_2 <= bcd_in_sec_2; 
                
            bcd_t.min_1 <= bcd_in_min_1;
            bcd_t.min_2 <= bcd_in_min_2; 
                
            bcd_t.hrs_1 <= bcd_in_hrs_1; 
            bcd_t.hrs_2 <= bcd_in_hrs_2; 
                
            bcd_t.day_1 <= bcd_in_day_1; 
            bcd_t.day_2 <= bcd_in_day_2; 
                
            bcd_t.month_1 <= bcd_in_month_1; 
            bcd_t.month_2 <= bcd_in_month_2; 
                
            bcd_t.years_1 <= bcd_in_years_1; 
            bcd_t.years_2 <= bcd_in_years_2;
		else 
			bcd_t <= bcd_t;	   
		end if;
		
		-- micro seconds
		if  bcd_t.usec_1 = "1001" and itr_in = '1' then
			bcd_t.usec_1 <= "0000";
			usec_ac_1 := '1';
		else if itr_in = '1' then
			bcd_t.usec_1 <= std_logic_vector(unsigned(bcd_t.usec_1) + 1);
		else 
			usec_ac_1 := '0';
		end if;
		end if;
		
		if (bcd_t.usec_2 = "1001" and usec_ac_1 = '1') or bcd_t.usec_2 > "1001" then
			bcd_t.usec_2 <= "0000";
			usec_ac_2 := '1';
		else if usec_ac_1 = '1'  then
			bcd_t.usec_2 <= std_logic_vector(unsigned(bcd_t.usec_2) + 1);
		else
			usec_ac_2 := '0';
		end if;
		end if;
		
		if (bcd_t.usec_3 = "1001" and usec_ac_2 = '1') or bcd_t.usec_3 > "1001" then
			bcd_t.usec_3 <= "0000";
			usec_ac_3 := '1';
		else if usec_ac_2 = '1'  then
			bcd_t.usec_3 <= std_logic_vector(unsigned(bcd_t.usec_3) + 1);
		else
			usec_ac_3 := '0';
		end if;
		end if;
		
		-- mili seconds
		if (bcd_t.msec_1 = "1001" and usec_ac_3 = '1') or bcd_t.msec_1 > "1001" then
			bcd_t.msec_1 <= "0000";
			msec_ac_1 := '1';
		else if usec_ac_3 = '1'  then
			bcd_t.msec_1 <= std_logic_vector(unsigned(bcd_t.msec_1) + 1);
		else
			msec_ac_1 := '0';
		end if;
		end if;
		
		if (bcd_t.msec_2 = "1001" and msec_ac_1 = '1') or bcd_t.msec_2 > "1001" then
			bcd_t.msec_2 <= "0000";
			msec_ac_2 := '1';
		else if msec_ac_1 = '1'  then
			bcd_t.msec_2 <= std_logic_vector(unsigned(bcd_t.msec_2) + 1);
		else
			msec_ac_2 := '0';
		end if;
		end if;
		
		if (bcd_t.msec_3 = "1001" and msec_ac_2 = '1') or bcd_t.msec_3 > "1001" then
			bcd_t.msec_3 <= "0000";
			msec_ac_3 := '1';
		else if msec_ac_2 = '1'  then 
			bcd_t.msec_3 <= std_logic_vector(unsigned(bcd_t.msec_3) + 1);
		else
			msec_ac_3 := '0';
		end if;
		end if;
		
		-- seconds 
		if (bcd_t.sec_1 = "1001" and msec_ac_3 = '1') or bcd_t.sec_1 > "1001"  then	 -- or	 bcd_t.sec_2 = "110"
			bcd_t.sec_1 <= "0000";
			sec_ac_1 := '1';
		else if msec_ac_3 = '1' then
			bcd_t.sec_1 <= std_logic_vector(unsigned(bcd_t.sec_1) + 1);
		else
			sec_ac_1 := '0';
		end if;
		end if;

		if (bcd_t.sec_2 = "101" and sec_ac_1 = '1') or bcd_t.sec_2 > "101" then
			bcd_t.sec_2 <= "000";
			sec_ac_2 := '1';
		else if sec_ac_1 = '1' then
			bcd_t.sec_2 <= std_logic_vector(unsigned(bcd_t.sec_2) + 1);
		else
			sec_ac_2 := '0';
		end if;		
		end if;
		
		--minutes
		if (bcd_t.min_1 = "1001" and sec_ac_2 = '1') or bcd_t.min_1 > "1001" then
			bcd_t.min_1 <= "0000";
			min_ac_1 := '1';
		else if sec_ac_2 = '1' then
			bcd_t.min_1 <= std_logic_vector(unsigned(bcd_t.min_1) + 1);
		else
			min_ac_1 := '0';
		end if;
		end if;

		if (bcd_t.min_2 = "101" and min_ac_1 = '1') or bcd_t.min_2 > "101" then
			bcd_t.min_2 <= "000";
			min_ac_2 := '1';
		else if min_ac_1 = '1' then
			bcd_t.min_2 <= std_logic_vector(unsigned(bcd_t.min_2) + 1);
		else
			min_ac_2 := '0';
		end if;
		end if;
		
		--hours
		if (bcd_t.hrs_1 = "1001" and min_ac_2 = '1' and bcd_t.hrs_2 /= "10") or 
			(bcd_t.hrs_1 = "0011" and min_ac_2 = '1' and bcd_t.hrs_2 = "10") or bcd_t.hrs_1 > "1001" then
			bcd_t.hrs_1 <= "0000";
			hrs_ac_1 := '1';			
		else if min_ac_2 = '1' then
			bcd_t.hrs_1 <= std_logic_vector(unsigned(bcd_t.hrs_1) + 1);
		else
			hrs_ac_1 := '0';
		end if;
		end if;

		if (bcd_t.hrs_2 = "10" and hrs_ac_1 = '1') or bcd_t.hrs_2 > "10" then
			bcd_t.hrs_2 <= "00";
			hrs_ac_2 := '1';
		else if hrs_ac_1 = '1' then
			bcd_t.hrs_2 <= std_logic_vector(unsigned(bcd_t.hrs_2) + 1);
		else
			hrs_ac_2 := '0';
		end if;
		end if;
				
		--days
		if (bcd_t.day_1 = "1001" and hrs_ac_2 = '1' and bcd_t.day_2 /= "11") or 
		   (bcd_t.day_1 = "0001" and hrs_ac_2 = '1' and bcd_t.day_2 = "11") or bcd_t.day_1 > "1001" then
			bcd_t.day_1 <= "0000";
			day_ac_1 := '1';
		else if hrs_ac_2 = '1' then
			bcd_t.day_1 <= std_logic_vector(unsigned(bcd_t.day_1) + 1);
		else
			day_ac_1 := '0';
		end if;
		end if;

		if (bcd_t.day_2 = "11" and day_ac_1 = '1') or bcd_t.day_2 > "11" then
			bcd_t.day_2 <= "00";
			day_ac_2 := '1';
		else if day_ac_1 = '1' then
			bcd_t.day_2 <= std_logic_vector(unsigned(bcd_t.day_2) + 1);
		else
			day_ac_2 := '0';
		end if;
		end if;
	
		--months
		if (bcd_t.month_1 = "1001" and day_ac_2 = '1' and bcd_t.month_2 = "0") or 
		   (bcd_t.month_1 = "0010" and day_ac_2 = '1' and bcd_t.month_2 = "1") or bcd_t.month_1 > "1001" then
			bcd_t.month_1 <= "0000";
			month_ac_1 := '1';
		else if day_ac_2 = '1' then
			bcd_t.month_1 <= std_logic_vector(unsigned(bcd_t.month_1) + 1);
		else
			month_ac_1 := '0';
		end if;
		end if;

		if (bcd_t.month_2 = "1" and month_ac_1 = '1') or bcd_t.month_2 > "1" then
			bcd_t.month_2 <= "0";
			month_ac_2 := '1';
		else if month_ac_1 = '1' then
			bcd_t.month_2 <= std_logic_vector(unsigned(bcd_t.month_2) + 1);
		else
			month_ac_2 := '0';
		end if;
		end if;
		
		--years
		if (bcd_t.years_1 = "1001" and month_ac_2 = '1') or bcd_t.years_1 > "1001" then
			bcd_t.years_1 <= "0000";
			years_ac_1 := '1';
		else if month_ac_2 = '1' then
			bcd_t.years_1 <= std_logic_vector(unsigned(bcd_t.years_1) + 1);
		else
			years_ac_1 := '0';
		end if;
		end if;
	
		if (bcd_t.years_2 = "1001" and years_ac_1 = '1') or bcd_t.years_2 > "1001" then
			bcd_t.years_2 <= "0000";
			years_ac_2 := '1';
		else if years_ac_1 = '1' then
			bcd_t.years_2 <= std_logic_vector(unsigned(bcd_t.years_2) + 1);
		end if;
		end if;
		
		
	
end if;
end if;
end process;

bcd_out_usec_1 <= bcd_t.usec_1; 
bcd_out_usec_2 <= bcd_t.usec_2;
bcd_out_usec_3 <= bcd_t.usec_3; 
            
bcd_out_msec_1 <= bcd_t.msec_1; 
bcd_out_msec_2 <= bcd_t.msec_2; 
bcd_out_msec_3 <= bcd_t.msec_3; 
                
bcd_out_sec_1 <= bcd_t.sec_1; 
bcd_out_sec_2 <= bcd_t.sec_2; 
                
bcd_out_min_1 <= bcd_t.min_1;
bcd_out_min_2 <= bcd_t.min_2; 
                    
bcd_out_hrs_1 <= bcd_t.hrs_1; 
bcd_out_hrs_2 <= bcd_t.hrs_2; 
                    
bcd_out_day_1 <= bcd_t.day_1; 
bcd_out_day_2 <= bcd_t.day_2; 
                    
bcd_out_month_1 <= bcd_t.month_1; 
bcd_out_month_2 <= bcd_t.month_2; 
                
bcd_out_years_1 <= bcd_t.years_1; 
bcd_out_years_2 <= bcd_t.years_2;

end rtc;
