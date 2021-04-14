
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity spi_cmv is
	generic(
	data_width	: integer := 16; 		-- number of address + data bit to serialize
	addr_width : integer := 7		-- number of address	
	);
	port(
	clk_in : std_logic;
	
	spi_start : in std_logic;
	spi_active : out std_logic;
	
--	spi_data_in : in std_logic_vector (data_width -1 downto 0);
	spi_write : in std_logic; 
	spi_address : in std_logic_vector (	addr_width-1 downto 0);
	spi_data  : in std_logic_vector ( data_width-1 downto 0 );
	
	spi_data_out : out std_logic_vector (data_width-1 downto 0);
	spi_latch : out std_logic;
	
	
	spi_clk : out std_logic;
	spi_miso : in std_logic;
	spi_mosi : out std_logic;
	spi_cs	: out std_logic
	);
	
end entity;

architecture beh of spi_cmv is

	signal enable_a : std_logic := '0';
	signal enable_b : std_logic := '0';
	signal enable	: std_logic := '0';
	
	signal data_shift : std_logic_vector (22 downto 0) := (others => '0');
	signal ctrl_shift : std_logic_vector (24 downto 0) := (others => '0');
	
	signal spi_miso_r : std_logic;
	signal spi_data_r : std_logic_vector (data_width-1 downto 0);
	signal spi_write_r : std_logic;
	signal spi_address_r : std_logic_vector (addr_width-1 downto 0);
	
	signal clk_in_r : std_logic;
	signal spi_cs_r : std_logic;

begin
	
	control_process : process(clk_in)
	begin
		if falling_edge(clk_in) then
			ctrl_shift <= spi_start & ctrl_shift(ctrl_shift'high downto 1);
		end if;
	end process;
	
	enable_a_process : process(clk_in, spi_start)
	begin
		if falling_edge(clk_in) then
			if spi_start = '1' then
				enable_a <= not enable_b;
			end if;
		end if;
	end process;
		
	enable_b_process : process(clk_in, spi_start)
	begin
		if rising_edge(clk_in) then
			if ctrl_shift(0) = '1' then
				enable_b <= enable_a;
			end if;
		end if;
	end process;
	
	enable <= enable_a xor enable_b;
	spi_cs <= enable;
	
	spi_clk <= clk_in when enable = '1' else '0';
	
	data_in_process : process (clk_in, spi_start, spi_data, spi_address, spi_miso)
	begin
		if rising_edge(clk_in) then
			if spi_start = '1' then
				data_shift(15 downto 0) <= spi_data;
				data_shift(22  downto 16) <= spi_address;
				
			elsif enable = '1' then
				data_shift <= data_shift(data_shift'high-1 downto 0) & spi_miso;
			end if;
		end if;
	end process;
		
	data_out_process : process (clk_in, spi_start)
	begin
	if falling_edge(clk_in) then
		if spi_start = '1' then
		spi_mosi <= spi_write;
		else
		spi_mosi <= data_shift(data_shift'high);
		end if;
	end if;
	end process;
	
	spi_data_out <= data_shift(spi_data_out'high + 1 downto 1);
	spi_latch <= ctrl_shift(0) and not spi_start;
	
	
	start_process : process(clk_in,spi_start, enable)
	begin
		if rising_edge(clk_in) then
			if spi_start = '1' then	
				spi_active <= '1';
			elsif enable = '0' then
				spi_active <= '0';
			end if;
		end if;
	end process;
	
end beh;
