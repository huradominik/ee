   library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;
   use IEEE.NUMERIC_STD.ALL;
   
   
   entity diod_prescaler_tb is
   end diod_prescaler_tb;
   
   
   
   architecture testBench of diod_prescaler_tb is
   
   signal clk_100MHz : std_logic;
   signal sys_rst : std_logic;
   signal led_in_test : std_logic_vector (5 downto 0);
   signal led_out_test : std_logic_vector (5 downto 0);
   
   
   --COMPONENTS DECLARATION--
   
   component clk_gen is
	   generic(
	   BASE_TIME : time := 10ns
	   );
	   port(
	   clk_out : out std_logic
	   );
   end component;
   
   component diod_prescaler is
	   	generic(
		INPUT_FREQUENCY : integer := 100000000;
		PRESCALER_DIVIDE : integer := 100000;
		DUTY_CYCLE : integer := 2;  
		NUMBER_OF_LED : integer := 6 
		);
	port(
		clk_in : in std_logic;
		rst	   : in std_logic;
		led_in : in std_logic_vector ((NUMBER_OF_LED - 1) downto 0);
		led_out : out std_logic_vector ((NUMBER_OF_LED -1) downto 0)
		);
   end component;
   
   
   
   begin
	   
	   clk_inst : clk_gen
	   generic map( BASE_TIME => 10ns )
	   port map( clk_out => clk_100MHz);
	   
	   presc_inst : diod_prescaler
	   generic map(
	   INPUT_FREQUENCY => 100000000,
	   PRESCALER_DIVIDE => 100000,
	   DUTY_CYCLE => 1,
	   NUMBER_OF_LED => 6
	   )
	   port map(
	   clk_in => clk_100MHz,
	   rst => sys_rst,
	   led_in => led_in_test,
	   led_out => led_out_test
	   );
   
   	   -- SIMULATION --
		  
	process
	
	begin
		led_out_test <= (others => '0');
		wait for 10 ns;
		sys_rst <= '1';
		led_in_test <= (others => '0');
		wait for 50 ns;
		sys_rst <= '0';
		led_in_test <= "110011";
		
		wait for 1000 ms;
		led_in_test <= "001100";

	end process;   
	   
   end testBench;