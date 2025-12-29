----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2025 01:21:33 PM
-- Design Name: 
-- Module Name: reg - Behavioral
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

entity reg is
  Generic(
            w : integer := 32
        );
  Port ( clk: in std_logic;
         rst: in std_logic;
         en: in std_logic;
         d: in std_logic_vector(w-1 downto 0);
         q: out std_logic_vector(w-1 downto 0) 
         );
end reg;

architecture Behavioral of reg is

signal data: std_logic_vector(w-1 downto 0) := (others => '0');

begin

process(clk)
begin
    if(rising_edge(clk)) then
        if(rst = '1') then
            data <= (others => '0');
        elsif (en = '1') then
            data <= d;
        end if;
    end if;
end process;

q <= data;


end Behavioral;
