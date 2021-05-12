----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2021 09:19:20
-- Design Name: 
-- Module Name: set_time - Behavioral
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

entity set_time is
    generic(
    DATA_WIDTH : natural := 48;
    SET_VALUE  : natural := 500000;
    RESET_ACTIVE_HIGH : std_logic := '1'
    );
    Port (
    clk : in std_logic;
    rst_n : in std_logic;
    Q   : out std_logic_vector (DATA_WIDTH-1 downto 0)
    );
    
end set_time;

architecture Behavioral of set_time is

begin

process(clk, rst_n)

variable tq : unsigned (DATA_WIDTH-1 downto 0);

begin
    if rising_edge(clk) then
        if rst_n = RESET_ACTIVE_HIGH then
            tq := (others => '0');
        else
            tq := TO_UNSIGNED(SET_VALUE, tq'length);
        end if;
        Q <= std_logic_vector(tq);
    end if;    
            
end process;


end Behavioral;
