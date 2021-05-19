library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

USE work.BCD_pkg.ALL;


--EDIT:
-- dodaæ jeden rejest wejsciowy i rozpisac aliasy na bcd
-- porownania w pêtli for generate -- uproszczenie opisu

entity comp_bcd_cmv is
	generic(
	RESET_EDGE : std_logic := '1'
	);
	
	port(
	clk : in std_logic;
	rst : in std_logic;
	
	--load_en : in std_logic;
	--input from REAL TIME --
	bcd_real_usec : in std_logic_vector(11 downto 0);
	bcd_real_msec : in std_logic_vector(11 downto 0);
	bcd_real_sec  : in std_logic_vector(6 downto 0);
	bcd_real_min : in std_logic_vector(6 downto 0);
	bcd_real_hrs : in std_logic_vector(5 downto 0);
	bcd_real_day : in std_logic_vector(5 downto 0);
	bcd_real_month : in std_logic_vector(4 downto 0);
	bcd_real_year : in std_logic_vector (7 downto 0);
	
	 
	
	--input from SET TIME--
	bcd_set_usec : in std_logic_vector(11 downto 0);
	bcd_set_msec : in std_logic_vector(11 downto 0);
	bcd_set_sec : in std_logic_vector(6 downto 0);
	bcd_set_min : in std_logic_vector(6 downto 0);
	bcd_set_hrs : in std_logic_vector(5 downto 0);
	bcd_set_day : in std_logic_vector(5 downto 0);
	bcd_set_month : in std_logic_vector(4 downto 0);
	bcd_set_year : in std_logic_vector(7 downto 0);
	
	
	--output trigger
	trigger : out std_logic
	);
	
	
end comp_bcd_cmv;


architecture comparator of comp_bcd_cmv is

function and_reduct(inp : in std_logic_vector) return std_logic is
variable res_v : std_logic := '1';
begin
	for i in inp'range loop
		res_v := res_v and inp(i);
	end loop;
	return res_v;
end function;

-- real registers
alias bcd_r_usec_1 : std_logic_vector(3 downto 0) is bcd_real_usec(3 downto 0);
alias bcd_r_usec_2 : std_logic_vector(3 downto 0) is bcd_real_usec(7 downto 4);
alias bcd_r_usec_3 : std_logic_vector(3 downto 0) is bcd_real_usec(11 downto 8);

alias bcd_r_msec_1 : std_logic_vector(3 downto 0) is bcd_real_msec(3 downto 0);
alias bcd_r_msec_2 : std_logic_vector(3 downto 0) is bcd_real_msec(7 downto 4);
alias bcd_r_msec_3 : std_logic_vector(3 downto 0) is bcd_real_msec(11 downto 8);

alias bcd_r_sec_1 : std_logic_vector(3 downto 0) is bcd_real_sec(3 downto 0);
alias bcd_r_sec_2 : std_logic_vector(2 downto 0) is bcd_real_sec(6 downto 4);

alias bcd_r_min_1 : std_logic_vector(3 downto 0) is bcd_real_min(3 downto 0);
alias bcd_r_min_2 : std_logic_vector(2 downto 0) is bcd_real_min(6 downto 4);

alias bcd_r_hrs_1 : std_logic_vector(3 downto 0) is bcd_real_hrs(3 downto 0);
alias bcd_r_hrs_2 : std_logic_vector(1 downto 0) is bcd_real_hrs(5 downto 4);

alias bcd_r_day_1 : std_logic_vector(3 downto 0) is bcd_real_day(3 downto 0);
alias bcd_r_day_2 : std_logic_vector(1 downto 0) is bcd_real_day(5 downto 4);

alias bcd_r_month_1 : std_logic_vector(3 downto 0) is bcd_real_month(3 downto 0);
alias bcd_r_month_2	: std_logic_vector(1 downto 1) is bcd_real_month(4 downto 4);

alias bcd_r_years_1 : std_logic_vector(3 downto 0) is bcd_real_year(3 downto 0);
alias bcd_r_years_2 : std_logic_vector(3 downto 0) is bcd_real_year(7 downto 4);

-- set registers
alias bcd_s_usec_1 : std_logic_vector(3 downto 0) is bcd_set_usec(3 downto 0);
alias bcd_s_usec_2 : std_logic_vector(3 downto 0) is bcd_set_usec(7 downto 4);
alias bcd_s_usec_3 : std_logic_vector(3 downto 0) is bcd_set_usec(11 downto 8);

alias bcd_s_msec_1 : std_logic_vector(3 downto 0) is bcd_set_msec(3 downto 0);
alias bcd_s_msec_2 : std_logic_vector(3 downto 0) is bcd_set_msec(7 downto 4);
alias bcd_s_msec_3 : std_logic_vector(3 downto 0) is bcd_set_msec(11 downto 8);

alias bcd_s_sec_1 : std_logic_vector(3 downto 0) is bcd_set_sec(3 downto 0);
alias bcd_s_sec_2 : std_logic_vector(2 downto 0) is bcd_set_sec(6 downto 4);

alias bcd_s_min_1 : std_logic_vector(3 downto 0) is bcd_set_min(3 downto 0);
alias bcd_s_min_2 : std_logic_vector(2 downto 0) is bcd_set_min(6 downto 4);

alias bcd_s_hrs_1 : std_logic_vector(3 downto 0) is bcd_set_hrs(3 downto 0);
alias bcd_s_hrs_2 : std_logic_vector(1 downto 0) is bcd_set_hrs(5 downto 4);

alias bcd_s_day_1 : std_logic_vector(3 downto 0) is bcd_set_day(3 downto 0);
alias bcd_s_day_2 : std_logic_vector(1 downto 0) is bcd_set_day(5 downto 4);

alias bcd_s_month_1 : std_logic_vector(3 downto 0) is bcd_set_month(3 downto 0);
alias bcd_s_month_2	: std_logic_vector(1 downto 1) is bcd_set_month(4 downto 4);

alias bcd_s_years_1 : std_logic_vector(3 downto 0) is bcd_set_year(3 downto 0);
alias bcd_s_years_2 : std_logic_vector(3 downto 0) is bcd_set_year(7 downto 4);

-- latch input registers --

--signal bcd_real : BCD_interface;
--signal bcd_set : BCD_interface;

-- compare flag--
signal cp_fl_usec_1 : std_logic;
signal cp_fl_usec_2 : std_logic;
signal cp_fl_usec_3 : std_logic;

signal cp_fl_msec_1 : std_logic;
signal cp_fl_msec_2 : std_logic;
signal cp_fl_msec_3 : std_logic;

signal cp_fl_sec_1 : std_logic;
signal cp_fl_sec_2 : std_logic;

signal cp_fl_min_1 : std_logic;
signal cp_fl_min_2 : std_logic;

signal cp_fl_hrs_1 : std_logic;
signal cp_fl_hrs_2 : std_logic;

signal cp_fl_day_1 : std_logic;
signal cp_fl_day_2 : std_logic;

signal cp_fl_month_1 : std_logic;
signal cp_fl_month_2 : std_logic;

signal cp_fl_year_1 : std_logic;
signal cp_fl_year_2 : std_logic;

signal flag : std_logic_vector(17 downto 0);

begin

-- micro sec	
process(bcd_r_usec_1, bcd_s_usec_1)
begin
	if (bcd_r_usec_1 = bcd_s_usec_1) then
	   	cp_fl_usec_1 <= '1';
	else
		cp_fl_usec_1 <= '0';
	end if;
end process;

process(bcd_r_usec_2, bcd_s_usec_2)
begin
	if (bcd_r_usec_2 = bcd_s_usec_2) then
		cp_fl_usec_2 <= '1';
	else
		cp_fl_usec_2 <= '0';
	end if;
end process;

process(bcd_r_usec_3, bcd_s_usec_3)
begin
	if (bcd_r_usec_3 = bcd_s_usec_3) then
		cp_fl_usec_3 <= '1';
	else
		cp_fl_usec_3 <= '0';
	end if;
end process;

-- mili sec	
process(bcd_r_msec_1, bcd_s_msec_1)
begin
	if (bcd_r_msec_1 = bcd_s_msec_1) then
		cp_fl_msec_1 <= '1';
	else
		cp_fl_msec_1 <= '0';
	end if;
end process;

process(bcd_r_msec_2, bcd_s_msec_2)
begin
	if (bcd_r_msec_2 = bcd_s_msec_2) then
		cp_fl_msec_2 <= '1';
	else
		cp_fl_msec_2 <= '0';
	end if;
end process;

process(bcd_r_msec_3, bcd_s_msec_3)
begin
	if (bcd_r_msec_3 = bcd_s_msec_3) then
		cp_fl_msec_3 <= '1';
	else
		cp_fl_msec_3 <= '0';
	end if;
end process;

-- sec

process(bcd_r_sec_1, bcd_s_sec_1)
begin
	if (bcd_r_sec_1 = bcd_s_sec_1) then
		cp_fl_sec_1 <= '1';
	else
		cp_fl_sec_1 <= '0';
	end if;
end process;

process(bcd_r_sec_2, bcd_s_sec_2)
begin
	if (bcd_r_sec_2 = bcd_s_sec_2) then
		cp_fl_sec_2 <= '1';
	else
		cp_fl_sec_2 <= '0';
	end if;
end process;

-- min
process(bcd_r_min_1, bcd_s_min_1)
begin
	if (bcd_r_min_1 = bcd_s_min_1) then
		cp_fl_min_1 <= '1';
	else
		cp_fl_min_1 <= '0';
	end if;
end process;

process(bcd_r_min_2, bcd_s_min_2)
begin
	if (bcd_r_min_2 = bcd_s_min_2) then
		cp_fl_min_2 <= '1';
	else
		cp_fl_min_2 <= '0';
	end if;
end process;

--hrs
process(bcd_r_hrs_1, bcd_s_hrs_1)
begin
	if (bcd_r_hrs_1 = bcd_s_hrs_1) then
		cp_fl_hrs_1 <= '1';
	else
		cp_fl_hrs_1 <= '0';
	end if;
end process;

process(bcd_r_hrs_2, bcd_s_hrs_2)
begin
	if (bcd_r_hrs_2 = bcd_s_hrs_2) then
		cp_fl_hrs_2 <= '1';
	else
		cp_fl_hrs_2 <= '0';
	end if;
end process;

--day
process(bcd_r_day_1, bcd_s_day_1)
begin
	if (bcd_r_day_1 = bcd_s_day_1) then
		cp_fl_day_1 <= '1';
	else
		cp_fl_day_1 <= '0';
	end if;
end process;

process(bcd_r_day_2, bcd_s_day_2)
begin
	if (bcd_r_day_2 = bcd_s_day_2) then
		cp_fl_day_2 <= '1';
	else
		cp_fl_day_2 <= '0';
	end if;
end process;

--month
process(bcd_r_month_1, bcd_s_month_1)
begin
	if (bcd_r_month_1 = bcd_s_month_1) then
		cp_fl_month_1 <= '1';
	else
		cp_fl_month_1 <= '0';
	end if;
end process;

process(bcd_r_month_2, bcd_s_month_2)
begin
	if (bcd_r_month_2 = bcd_s_month_2) then
		cp_fl_month_2 <= '1';
	else
		cp_fl_month_2 <= '0';
	end if;	
end process;

--years
process(bcd_r_years_1, bcd_s_years_1)
begin
	if (bcd_r_years_1 = bcd_s_years_1) then
		cp_fl_year_1 <= '1';
	else
		cp_fl_year_1 <= '0';
	end if;
end process;

process(bcd_r_years_2, bcd_s_years_2)
begin
	if (bcd_r_years_2 = bcd_s_years_2) then
		cp_fl_year_2 <= '1';
	else
		cp_fl_year_2 <= '0';
	end if;
end process;


-- flag compare

flag <= cp_fl_year_2 & cp_fl_year_1 & 
		cp_fl_month_2 & cp_fl_month_1 & 
		cp_fl_day_2 & cp_fl_day_1 & 
		cp_fl_hrs_2 & cp_fl_hrs_1 & 
		cp_fl_min_2 & cp_fl_min_1 & 
		cp_fl_sec_2 & cp_fl_sec_1 & 
		cp_fl_msec_3 & cp_fl_msec_2 & cp_fl_msec_1 & 
		cp_fl_usec_3 & cp_fl_usec_2 & cp_fl_usec_1;

trigger <= and_reduct(flag);
		

end comparator;

