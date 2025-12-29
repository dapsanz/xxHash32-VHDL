----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2025 02:25:19 PM
-- Design Name: 
-- Module Name: data_buffer - Behavioral
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

entity data_buffer is
    Port ( 
         addr : in std_logic_vector(1 downto 0);
         din  : in std_logic_vector(31 downto 0);
         we   : in std_logic;
         clk  : in std_logic;
         dout : out std_logic_vector(31 downto 0)
         );
end data_buffer;

architecture Behavioral of data_buffer is

type RAM is array(0 to 3) of std_logic_vector(31 downto 0);
signal buf : RAM := (others => (others => '0'));

begin

process(clk)
begin
    if(rising_edge(clk)) then
        if(we = '1') then
            buf(to_integer(unsigned(addr))) <= din;
        end if;
    end if;

end process;

dout <= buf(to_integer(unsigned(addr)));

end Behavioral;
