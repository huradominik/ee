----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2021 11:19:49
-- Design Name: 
-- Module Name: comparator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comparator is
    generic(
    DATA_WIDTH : natural := 48;
    PULSE : integer := 50000000;
    RESET_ACTIVE_HIGH : std_logic := '1'
    );
    Port(
    clk : in std_logic;
    rst_n : in std_logic;
    
    d_set : in std_logic_vector (DATA_WIDTH-1 downto 0);
    d_real : in std_logic_vector (DATA_WIDTH-1 downto 0);
    trigger : out std_logic
     );
end comparator;

architecture Behavioral of comparator is

signal d_set_t : std_logic_vector (DATA_WIDTH-1 downto 0);
signal d_real_t : std_logic_vector (DATA_WIDTH-1 downto 0);
signal trigger_t : std_logic;

begin

process(clk, rst_n, d_set, d_real)
begin
if rising_edge(clk) then
    if rst_n = RESET_ACTIVE_HIGH then
        d_set_t <= (others => '0');
        d_real_t <= (others => '0');
    else
        d_set_t <= d_set;
        d_real_t <= d_real;
    end if;
end if;
end process;

process(d_set_t, d_real_t)
begin

    if d_set_t = d_real_t then
        trigger_t <= '1';
    else
        trigger_t <= '0';
    end if;

end process;

process(clk, rst_n, trigger_t)

variable pulse_t : integer range 0 to PULSE := 0;
begin

if rising_edge(clk) then
    if rst_n = RESET_ACTIVE_HIGH then
        trigger <= '0';
        pulse_t := 0;
    else
        if trigger_t = '1' then
            pulse_t := PULSE;
        end if;
    if  pulse_t > 0 then
        pulse_t := pulse_t - 1;
        trigger <= '1';
    else
        trigger <= '0';
    end if;
    end if;
end if;
                    
end process;

end Behavioral;
