
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity spi_cmv_tb is
	generic(
	data_width	: integer := 16; 		-- number of address + data bit to serialize
	addr_width : integer := 7		-- number of address	
	);
end entity;


architecture testbench of spi_cmv_tb is

component clock is
	port ( Q : out std_logic);
end component;
	
component spi_cmv is
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
end component;


signal clk_in : std_logic;

signal spi_start: std_logic;
signal spi_active : std_logic;

signal spi_write : std_logic;
signal spi_address : std_logic_vector (addr_width-1 downto 0);
signal spi_data : std_logic_vector (data_width-1 downto 0);

signal spi_data_out : std_logic_vector (data_width-1 downto 0);
signal spi_latch : std_logic;

signal spi_clk : std_logic;
signal spi_miso : std_logic;
signal spi_mosi : std_logic;
signal spi_cs : std_logic; 

signal okres : integer range 0 to 50 := 0;

begin

clk : clock port map ( Q => clk_in);	
	
spi : spi_cmv port map(
clk_in => clk_in,
spi_start => spi_start,
spi_active => spi_active,
spi_write => spi_write,
spi_address => spi_address,
spi_data => spi_data,
spi_data_out => spi_data_out,
spi_latch => spi_latch,
spi_clk => spi_clk,
spi_miso => spi_miso,
spi_mosi => spi_mosi,
spi_cs => spi_cs
);	

process
begin

spi_start <= '0';
spi_miso <= '0';

spi_write <= '0';
spi_address <= (others => '0');
spi_data <= (others => '0');

spi_clk <= '0';
spi_miso <= '1';
spi_cs <= '0';	

wait for 50 ns;

spi_address <= "1111111";

wait for 200 ns;
spi_write <= '1';
spi_address <= "1100101";
spi_data <= X"ACCA";
wait for 300 ns;
spi_start <= '1';
wait for 50 ns;
spi_start <= '0';

spi_write <= '0';
spi_address <= "0011100";
spi_data <= X"8788";
wait for 1400 ns;
spi_start <= '1';
wait for 50 ns;
spi_start <= '0';
wait for 1400 ns;


end process;
	
end testbench;

