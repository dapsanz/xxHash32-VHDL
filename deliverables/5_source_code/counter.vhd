----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2025 09:55:59 PM
-- Design Name: 
-- Module Name: counter - Behavioral
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


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2025 01:21:33 PM
-- Design Name: 
-- Module Name: reg32 - Behavioral
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

entity counter is
  Generic(
          w : integer  
        );
  
  Port ( clk: in std_logic;
         rst: in std_logic;
         en: in std_logic;
         q: out std_logic_vector(w-1 downto 0) 
         );
end counter;

architecture Behavioral of counter is

signal data: std_logic_vector(w-1 downto 0) := (others => '0');

begin

process(clk)
begin
    if(rising_edge(clk)) then
        if(rst = '1') then
            data <= (others => '0');
        elsif (en = '1') then
            data <= std_logic_vector(unsigned(data) + 1);
        end if;
    end if;
end process;

q <= data;


end Behavioral;

