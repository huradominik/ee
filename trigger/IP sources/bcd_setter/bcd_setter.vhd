library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity bcd_setter is
	generic(
	RESET_EDGE : std_logic := '1';
	
	U_SEC_1 : std_logic_vector (3 downto 0) := "0111";
	U_SEC_2 : std_logic_vector (3 downto 0) := "0110";
	U_SEC_3 : std_logic_vector (3 downto 0)	:= "0010";
	
	M_SEC_1 : std_logic_vector (3 downto 0) := "0000";
	M_SEC_2 : std_logic_vector (3 downto 0) := "0100";
	M_SEC_3 : std_logic_vector (3 downto 0) := "0010";
	
	SEC_1 : std_logic_vector (3 downto 0) := "0010";
	SEC_2 : std_logic_vector (2 downto 0) := "010";
	
	MIN_1 : std_logic_vector (3 downto 0) := "0100";
	MIN_2 : std_logic_vector (2 downto 0) := "100";
	
	HRS_1 : std_logic_vector (3 downto 0) := "0001";
	HRS_2 : std_logic_vector (1 downto 0) := "10";
	
	DAY_1 : std_logic_vector (3 downto 0) := "0011";
	DAY_2 : std_logic_vector (1 downto 0) := "10";
	
	MONTH_1 : std_logic_vector (3 downto 0) := "1000";
	MONTH_2 : std_logic_vector (1 downto 1) := "0";
	
	YEARS_1 : std_logic_vector (3 downto 0) := "0100";
	YEARS_2 : std_logic_vector (3 downto 0) := "0010"	
	);
	
	port(
	clk : in std_logic;
	rst : in std_logic;
	
	load_enable : in std_logic;
	
	bcd_set_usec : out std_logic_vector(11 downto 0);
	bcd_set_msec : out std_logic_vector(11 downto 0);
	bcd_set_sec : out std_logic_vector(6 downto 0);
	bcd_set_min : out std_logic_vector(6 downto 0);
	bcd_set_hrs : out std_logic_vector(5 downto 0);
	bcd_set_day : out std_logic_vector(5 downto 0);
	bcd_set_month : out std_logic_vector(4 downto 0);
	bcd_set_years : out std_logic_vector(7 downto 0)	
	);
	
end	bcd_setter;

architecture setter of bcd_setter is

signal bcd_t_usec : std_logic_vector(11 downto 0);
signal bcd_t_msec : std_logic_vector(11 downto 0);
signal bcd_t_sec : std_logic_vector(6 downto 0);
signal bcd_t_min : std_logic_vector(6 downto 0);
signal bcd_t_hrs : std_logic_vector(5 downto 0);
signal bcd_t_day : std_logic_vector(5 downto 0);
signal bcd_t_month : std_logic_vector(4 downto 0);
signal bcd_t_years : std_logic_vector(7 downto 0);

begin

process(clk, rst)

begin
if rising_edge(clk) then
	if rst = RESET_EDGE then
		bcd_t_usec <= (others => '0');
		bcd_t_msec <= (others => '0');
		bcd_t_sec <= (others => '0');
		bcd_t_min <= (others => '0');
		bcd_t_hrs <= (others => '0');
		bcd_t_day <= (others => '0');
		bcd_t_month <= (others => '0');
		bcd_t_years <= (others => '0');
	else
		if load_enable = '1' then
			bcd_t_usec <= U_SEC_3 & U_SEC_2 & U_SEC_1;
			bcd_t_msec <= M_SEC_3 & M_SEC_2 & M_SEC_1;
			bcd_t_sec <= SEC_2 & SEC_1;
			bcd_t_min <= MIN_2 & MIN_1;
			bcd_t_hrs <= HRS_2 & HRS_1;
			bcd_t_day <= DAY_2 & DAY_1;
			bcd_t_month <= MONTH_2 & MONTH_1;
			bcd_t_years <= YEARS_2 & YEARS_1;
		else 
			bcd_t_usec <= bcd_t_usec;
			bcd_t_msec <= bcd_t_msec;
			bcd_t_sec <= bcd_t_sec;
			bcd_t_min <= bcd_t_min;
			bcd_t_hrs <= bcd_t_hrs;
			bcd_t_day <= bcd_t_day;
			bcd_t_month <= bcd_t_month;
			bcd_t_years <= bcd_t_years;
		end if;
	end if;
end if;
end process;

bcd_set_usec <= bcd_t_usec;
bcd_set_msec <= bcd_t_msec;
bcd_set_sec <= bcd_t_sec;
bcd_set_min <= bcd_t_min;
bcd_set_hrs <= bcd_t_hrs;
bcd_set_day <= bcd_t_day;
bcd_set_month <= bcd_t_month;
bcd_set_years <= bcd_t_years;

end setter;

	
	