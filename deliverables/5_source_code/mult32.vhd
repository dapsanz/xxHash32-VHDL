----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2025 02:01:41 PM
-- Design Name: 
-- Module Name: mult32 - Behavioral
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



entity mult32 is
  Port ( 
         a: in std_logic_vector(31 downto 0);
         b: in std_logic_vector(31 downto 0);
         prod: out std_logic_vector(31 downto 0)
  );
end mult32;

architecture Behavioral of mult32 is

begin
    prod <= std_logic_vector( resize(unsigned(a) * unsigned(b), 32) );
end Behavioral;
