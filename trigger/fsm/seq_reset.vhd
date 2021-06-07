library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity seq_reset is
	generic(COUNTER_VALUE : natural := 1100);
	
	port(
	clk : in std_logic;
	rst_n : in std_logic;
	
	rst_active : in std_logic;
	
	rst_done : out std_logic;
	sys_res_n : out std_logic   --- jak obliczyc dlugosc
	
	);
	
end seq_reset;


architecture reset of seq_reset is

--signal sys_res_n_v : std_logic;

begin
	
	process(clk)
	
	variable cnt : integer range 0 to COUNTER_VALUE := 0;
	variable tmp : std_logic := '0';
	variable sys_res_n_v : std_logic := '0';
	variable res_v : std_logic := '1';
	constant cnt_value : natural := COUNTER_VALUE;
	
	variable xxx : std_logic := '0';
	
	-- uwzglednic zmienna tmp przy pierwszym resecie,
	-- akutalnie jest to zle zrobione bo resetuje 2 razy
	-- pomysles na poprawa 
	
	begin		
	if rising_edge(clk) then
		if rst_n = '0' then
			sys_res_n_v := '0';
			rst_done <= '0';
			tmp := '0';	 -- zmienna resetujaca po inicjalizacji (tylko jednokrotnie dziala)
			res_v := '1';
		else
			if(rst_active = '1') then
				tmp := '1';
				xxx := '1';
				--res_v := '0';
				
				if(cnt < cnt_value) then
					cnt := cnt + 1;
					rst_done <= '0';
				--	res_v := '0';
					--sys_res_n_v := '1';
				else
					cnt := 0;
					rst_done <= '1';
				end if;
			
				
			else
				cnt := 0;
				rst_done <= '0';
				xxx := '0';
				res_v := '1';
				
			end if;
			--xxx = 1 - w stanie resetu
			--xxx = 0 - poza stanem resetu
					
			if(res_v = '1' and tmp = '1' and xxx = '1') then	 ---?
				sys_res_n_v := '0';
				res_v := '0';
			elsif (res_v = '0' and tmp = '1' and xxx = '0') then
				sys_res_n_v := '1';
				--res_v := '1';
			elsif (res_v = '0' and tmp = '1' and xxx = '1')	then
				sys_res_n_v := '1';
			elsif (res_v = '1' and tmp = '1' and xxx = '0') then
				sys_res_n_v := '1';
				res_v := '1';
			else sys_res_n_v := '0';			
			end if;			
			
		end if;
	end if;
	
	sys_res_n <= sys_res_n_v;
	end process;
	
	--sys_res_n <= sys_res_n_v;
			
	
end reset;
