library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity divide_count_ch4 is
	generic(
	DIVIDE_VALUE_CH0 : natural := 10000000;    
	DIVIDE_VALUE_CH1 : natural := 50000000;
	DIVIDE_VALUE_CH2 : natural := 10000000;
	DIVIDE_VALUE_CH3 : natural := 50000000
	);
	port(
	sys_rst : in std_logic;
	clk_in_ch0 : in std_logic;
	clk_in_ch1 : in std_logic;
	clk_in_ch2 : in std_logic;
	clk_in_ch3 : in std_logic;
	clk_out_ch0 : out std_logic;
	clk_out_ch1 : out std_logic;
	clk_out_ch2 : out std_logic;
	clk_out_ch3 : out std_logic
	);
end divide_count_ch4;


architecture beh of divide_count_ch4 is

begin
	
	-- CLOCK DIVIDE CHANNEL 0 --
	process(clk_in_ch0)
	variable count : integer range 0 to DIVIDE_VALUE_CH0 := 0;
	constant divide_ch0 : integer := DIVIDE_VALUE_CH0; 
	begin
		if rising_edge(clk_in_ch0) then
			if sys_rst = '0' then
				count := 0;
				clk_out_ch0 <= '0';
			else
			    if(divide_ch0 = 1 or divide_ch0 = 0) then
			        clk_out_ch0 <= clk_in_ch0;
			    else
                    if count < DIVIDE_VALUE_CH0/2 then
                        clk_out_ch0 <= '0';
                    else
                        clk_out_ch0 <= '1';
                    end if;
                    if count = DIVIDE_VALUE_CH0 then
                        count := 0;
                    else
                        count := count + 1;
                    end if;
                 end if;
			end if;
		end if;
	end process;
		
	-- CLOCK DIVIDE CHANNEL 1 --
	process(clk_in_ch1)
	variable count : integer range 0 to DIVIDE_VALUE_CH1 :=0;
	constant divide_ch1 : integer := DIVIDE_VALUE_CH1;
	
	begin
		if rising_edge(clk_in_ch1) then
			if sys_rst = '0' then
				count :=0;
				clk_out_ch1 <= '0';
			else
			    if(divide_ch1 = 1 or divide_ch1 = 0) then
			        clk_out_ch1 <= clk_in_ch1;
			    else
                    if count < DIVIDE_VALUE_CH1/2 then
                        clk_out_ch1 <= '0';
                    else
                        clk_out_ch1 <= '1';
                    end if;
                    if count = DIVIDE_VALUE_CH1 then
                        count := 0;
                    else
                        count := count + 1;
                    end if;
                end if;   
			end if;
		end if;
	end process; 
	
	-- CLOCK DIVIDE CHANNEL 2 --	
	process(clk_in_ch2)
	variable count : integer range 0 to DIVIDE_VALUE_CH2 :=0;
	constant divide_ch2 : integer := DIVIDE_VALUE_CH2;
	
	begin
		if rising_edge(clk_in_ch2) then
			if sys_rst = '0' then
				count :=0;
				clk_out_ch2 <= '0';
			else
			    if(divide_ch2 = 1 or divide_ch2 = 0) then
			        clk_out_ch2 <= clk_in_ch2;
			    else
                    if count < DIVIDE_VALUE_CH2/2 then
                        clk_out_ch2 <= '0';
                    else
                        clk_out_ch2 <= '1';
                    end if;
                    if count = DIVIDE_VALUE_CH2 then
                        count := 0;
                    else
                        count := count + 1;
                    end if;
                end if;
			end if;
		end if;
	end process;
	
	-- CLOCK DIVIDE CHANNEL 3 --	
	process(clk_in_ch3)
	variable count : integer range 0 to DIVIDE_VALUE_CH3 :=0;
	constant divide_ch3 : integer := DIVIDE_VALUE_CH3;
	
	begin
		if rising_edge(clk_in_ch3) then
			if sys_rst = '0' then
				count :=0;
				clk_out_ch3 <= '0';
			else
			    if(divide_ch3 = 1 or divide_ch3 = 0) then
			        clk_out_ch3 <= clk_in_ch3;
			    else
                    if count < DIVIDE_VALUE_CH3/2 then
                        clk_out_ch3 <= '0';
                    else
                        clk_out_ch3 <= '1';
                    end if;
                    if count = DIVIDE_VALUE_CH3 then
                        count := 0;
                    else
                        count := count + 1;
                    end if;
                end if;
			end if;
		end if;
	end process;
	
end beh;

