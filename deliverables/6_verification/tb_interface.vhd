----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2025 08:53:07 PM
-- Design Name: 
-- Module Name: tb_interface - Behavioral
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

USE ieee.std_logic_textio.all;
LIBRARY std;
USE std.textio.all;

entity tb_interface is
end tb_interface;

architecture Behavioral of tb_interface is

constant minimum_clk_period  : time := 14.734ns; 
constant clk_period : time := 15ns; --minimum_clk_period + minimum_clk_period/20;

signal clk: std_logic:= '0';
signal reset: std_logic:= '0';
signal din: std_logic_vector(31 downto 0):= (others => '0');
signal din_ready: std_logic; ----output
signal din_valid: std_logic:= '0';
signal din_in_last: std_logic := '0';
signal din_valid_bytes: std_logic_vector(3 downto 0) := (others => '0');
signal dout:  std_logic_vector(31 downto 0); --output
signal dout_ready: std_logic := '0'; 
signal dout_valid: std_logic;  -- output

begin

dut: entity work.interface
    port map (
        clk  => clk,
        reset => reset,
        din => din,
        din_ready => din_ready, 
        din_valid => din_valid,
        din_in_last => din_in_last,
        din_valid_bytes => din_valid_bytes,
        dout => dout,
        dout_ready => dout_ready,
        dout_valid => dout_valid
        );
        
        

clk <= not clk after clk_period/2;

stim: process
    variable time_ns : integer;
    variable L: line;
    variable Dout_Expected: std_logic_vector(31 downto 0);
begin
    wait for 4*clk_period; -- Initial delay
    
    reset <= '1';
    wait for clk_period*2;
    reset <= '0';
    ---------------------------------------------------
    -- SCENARIO 1 
    ---------------------------------------------------
    Dout_Expected:= x"C3213C80";
    wait until falling_edge(clk) and din_ready = '1';
    din_valid <= '1';
    din_valid_bytes <= "1111";
    din <= x"0000_0001";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0000_0010";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0000_0100";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0000_1000";
    din_in_last <= '1';
    wait for clk_period;
    din_valid <= '0';
    wait until dout_valid = '1';
    dout_ready <= '1';
    din_in_last <= '0';
    wait for clk_period/2;
    time_ns := integer(now / 1 ns);
    if Dout /= Dout_Expected then    
        assert false
        report "Scenario 1: Output does not match expected value."
        severity warning;
    else     
        assert false
        report "Correct Output, Scenario 1 Passed"
        severity warning;
    end if;
    -- write to line
    L := null;
    write(L, string'("Time: "));
    write(L, time_ns);
    write(L, string'(" ns, Actual output: "));
    hwrite(L, Dout);
    write(L, string'(", Expected output: "));
    hwrite(L, Dout_Expected);
    writeline(output, L);

    wait for clk_period/2;
    dout_ready <= '0';
    wait for clk_period*2;
    
    ---------------------------------------------------
    -- SCENARIO 2 
    --------------------------------------------------- 
    Dout_Expected:= x"46650803";
    wait until falling_edge(clk) and din_ready = '1';
    din_valid <= '1';
    din_valid_bytes <= "1111";
    
    din <= x"0000_0001";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0000_0010";
    din_in_last <= '1';
    wait for clk_period;
    din_valid <= '0';
    wait until dout_valid = '1';
    dout_ready <= '1';
    din_in_last <= '0';
    wait for clk_period/2;
    time_ns := integer(now / 1 ns);
    if Dout /= Dout_Expected then    
        assert false
        report "Scenario 2: Output does not match expected value."
        severity warning;
    else     
        assert false
        report "Correct Output, Scenario 2 Passed"
        severity warning;
    end if;
    -- write to line
    L := null;
    write(L, string'("Time: "));
    write(L, time_ns);
    write(L, string'(" ns, Actual output: "));
    hwrite(L, Dout);
    write(L, string'(", Expected output: "));
    hwrite(L, Dout_Expected);
    writeline(output, L);
    wait for clk_period/2;
    
    dout_ready <= '0';
    wait for 2*clk_period;
    
    ---------------------------------------------------
    -- SCENARIO 3
    ---------------------------------------------------    
    Dout_Expected:= x"E5D228DD";
    wait until falling_edge(clk) and din_ready = '1';
    din_valid <= '1';
    din_valid_bytes <= "1111";
    
    din <= x"0000_0001";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0000_0010";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0000_0100";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0000_1000";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0001_0000";
    wait until falling_edge(clk) and din_ready = '1';
    din_valid_bytes <= "1000";
    din_in_last <= '1';
    din <= x"0111_1111";
    wait for clk_period;
    din_valid <= '0';
    wait until dout_valid = '1';
    dout_ready <= '1';
    din_in_last <= '0';
    wait for clk_period/2;
    time_ns := integer(now / 1 ns);
    if Dout /= Dout_Expected then    
        assert false
        report "Scenario 3: Output does not match expected value."
        severity warning;
    else     
        assert false
        report "Correct Output, Scenario 3 Passed"
        severity warning;
    end if;
    -- write to line
    L := null;
    write(L, string'("Time: "));
    write(L, time_ns);
    write(L, string'(" ns, Actual output: "));
    hwrite(L, Dout);
    write(L, string'(", Expected output: "));
    hwrite(L, Dout_Expected);
    writeline(output, L);
    wait for clk_period/2;
    dout_ready <= '0';
    wait for clk_period*2;
    
    ---------------------------------------------------
    -- SCENARIO 4
    ---------------------------------------------------    
    Dout_Expected:= x"71B282B6";
    wait until falling_edge(clk) and din_ready = '1';
    din_valid <= '1';
    din_valid_bytes <= "1111";   
    din <= x"0000_0001";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0000_0010";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0000_0100";
    wait until falling_edge(clk) and din_ready = '1';
    din_valid_bytes <= "1110";
    din_in_last <= '1';
    din <= x"0302_01FF";
    wait for clk_period;
    din_valid <= '0';
    wait until dout_valid = '1';
    dout_ready <= '1';
    din_in_last <= '0';
    wait for clk_period/2;
    time_ns := integer(now / 1 ns);
    if Dout /= Dout_Expected then    
        assert false
        report "Scenario 4: Output does not match expected value."
        severity warning;
    else     
        assert false
        report "Correct Output, Scenario 4 Passed"
        severity warning;
    end if;
    -- write to line
    L := null;
    write(L, string'("Time: "));
    write(L, time_ns);
    write(L, string'(" ns, Actual output: "));
    hwrite(L, Dout);
    write(L, string'(", Expected output: "));
    hwrite(L, Dout_Expected);
    writeline(output, L);
    wait for clk_period/2;
    dout_ready <= '0';
    wait for clk_period*2;
    
    ---------------------------------------------------
    -- SCENARIO 5
    ---------------------------------------------------   
    Dout_Expected:= x"250F0F2A";
    wait until falling_edge(clk) and din_ready = '1';
    din_valid <= '1';
    din_valid_bytes <= "1111";   
    
    din <= x"0000_0001";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0000_0010";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0000_0100";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0000_1000";
    
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0001_0000";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0010_0000";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0100_0000";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"1000_0000";
    
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0102_0304";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0607_0809";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"0A0B_0E0F";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"F0F1_F2F3";
    
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"FADE_CADE";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"FACA_DEFF";
    wait until falling_edge(clk) and din_ready = '1';
    din <= x"F4F5_F6F7";
    wait until falling_edge(clk) and din_ready = '1';
    din_valid_bytes <= "1110";
    din_in_last <= '1';
    din <= x"F8F9_FA99";
    
    wait for clk_period;
    din_valid <= '0';
    wait until dout_valid = '1';
    dout_ready <= '1';
    din_in_last <= '0';
    wait for clk_period/2;
    time_ns := integer(now / 1 ns);
    if Dout /= Dout_Expected then    
        assert false
        report "Scenario 5: Output does not match expected value."
        severity warning;
    else     
        assert false
        report "Correct Output, Scenario 5 Passed"
        severity warning;
    end if;
    -- write to line
    L := null;
    write(L, string'("Time: "));
    write(L, time_ns);
    write(L, string'(" ns, Actual output: "));
    hwrite(L, Dout);
    write(L, string'(", Expected output: "));
    hwrite(L, Dout_Expected);
    writeline(output, L);
    wait for clk_period/2;
    dout_ready <= '0';
    
    wait;
    
    
end process;
end Behavioral;

