----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2025 09:05:00 PM
-- Design Name: 
-- Module Name: tb_datapath - Behavioral
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

entity tb_datapath is
end tb_datapath;

architecture behavioral of tb_datapath is
    constant clk_period: time := 10ns;
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '1';
    signal done_tb  : std_logic := '0';
    signal din      : std_logic_vector(31 downto 0) := (others => '0');
    signal din_valid_bytes : std_logic_vector(3 downto 0) := (others => '0');
    signal din_in_last : std_logic := '0';
    
    signal op       : std_logic_vector(1 downto 0) := "00";
    signal byte_sel : std_logic_vector(1 downto 0) := "00";
    signal acc_stg  : std_logic_vector(1 downto 0) := "00";
    signal round_idx  : std_logic_vector(1 downto 0) := "00";
    signal cyc      : std_logic := '0';
    signal init     : std_logic := '0';
    signal rem_sel     : std_logic_vector (1 downto 0):= "00";
    
    signal tb_test : std_logic_vector(1 downto 0) := "00";
    
    signal en_a1, en_a2, en_a3, en_a4 : std_logic := '0';
    signal en_acc, en_buf : std_logic := '0';
    signal en_bidx, en_bcnt, en_remw, en_ptr : std_logic := '0';
    signal rst_bidx, rst_ptr : std_logic := '0';

    signal dout : std_logic_vector(31 downto 0);
    signal gt16, zb, beq3, gt0, eq4 : std_logic;

begin

    -- DUT
    uut: entity work.datapath
        port map (
            clk => clk,
            reset => reset,
            din => din,
            din_valid_bytes => din_valid_bytes,
            dout => dout,
            din_in_last => din_in_last,
            op => op,
            byte_sel => byte_sel,
            acc_stg => acc_stg,
            cyc => cyc,
            init => init,
            rem_sel => rem_sel,
            round_idx => round_idx,
            gt16 => gt16,
            zb => zb,
            beq3 => beq3,
            eq4 => eq4,
            gt0 => gt0,
            en_a1 => en_a1,
            en_a2 => en_a2,
            en_a3 => en_a3,
            en_a4 => en_a4,
            en_acc => en_acc,
            en_buf => en_buf,
            en_bidx => en_bidx,
            en_bcnt => en_bcnt,
            en_remw => en_remw,
            en_ptr => en_ptr,
            rst_bidx => rst_bidx,
            rst_ptr => rst_ptr
            
        );


    clk <= not clk after clk_period/2;

    ----------------------------------------
    -- Stimulus process
    ----------------------------------------
    stim: process
    
    variable time_ns : integer;
    variable L: line;
    variable Dout_Expected: std_logic_vector(31 downto 0);
    begin
 ------ SCENARIO 1 ------
        ---------------------------------------------------
        --Reset
        ---------------------------------------------------
        reset <= '1';
        rst_ptr<= '1';
        rst_bidx <= '1';
        done_tb <= '0';
        Dout_Expected:= x"C3213C80";        
        wait for 2*clk_period;
        reset <= '0';
        rst_ptr<= '0';
        rst_bidx <= '0';
        wait for clk_period;
        
        ---------------------------------------------------
        --Step 1. Initialize accumulators
        ---------------------------------------------------
        wait until rising_edge(clk);
        init <= '1';
        en_a1 <= '1';
        en_a2 <= '1';
        en_a3 <= '1';
        en_a4 <= '1';
        en_acc <= '1';
        en_bcnt <= '1';
        wait for clk_period;
        init <= '0';
        en_a1 <= '0';
        en_a2 <= '0';
        en_a3 <= '0';
        en_a4 <= '0';
        en_acc <= '0';
        ---------------------------------------------------
        --Load 4 word into input buffer
        ---------------------------------------------------
        en_buf <= '1';
        en_bidx <= '1';
        en_bcnt <= '1';
        din_valid_bytes <= "1111";
        
        
        din <= x"0000_0001";
        wait for clk_period;
        din <= x"0000_0010";
        wait for clk_period;
        din <= x"0000_0100";
        wait for clk_period;
        din <= x"0000_1000";
        wait for clk_period;
        en_bcnt <= '0';
        en_buf <= '0';
        en_bidx <= '0';
        
        ---------------------------------------------------
        --Step 2. Process stripes
        ---------------------------------------------------
        op <= "00";
        cyc <= '0';
        en_a1 <= '1';
        round_idx <= "00";
        wait for clk_period;
        cyc <= '1';
        wait for clk_period;
        en_a1 <= '0';
        en_a2 <= '1';
        cyc <= '0';
        round_idx <= "01";
        wait for clk_period;
        cyc <= '1';
        wait for clk_period;
        en_a2 <= '0';
        en_a3 <= '1';
        cyc <= '0';
        round_idx <= "10";
        wait for clk_period;
        cyc <= '1';
        wait for clk_period;
        en_a3 <= '0';
        en_a4 <= '1';
        cyc <= '0';
        round_idx <= "11";
        wait for clk_period;
        cyc <= '1';
        wait for clk_period;
        en_a4 <= '0';
        ---------------------------------------------------
        --Step 3. Accumulator convergence
        ---------------------------------------------------
        en_acc <= '1';
        acc_stg <= "00";
        wait for clk_period;
        ---------------------------------------------------
        --Step 4. Add input length
        ---------------------------------------------------
        acc_stg <= "01";
        wait for clk_period;
        ---------------------------------------------------
        --Step 6. Avalanche
        ---------------------------------------------------
        acc_stg <= "11";
        op <= "11";
        cyc <= '0';
        wait for clk_period;
        cyc <= '1';
        wait for clk_period;
        en_acc <= '0'; 
        done_tb <= '1';
        wait for clk_period/2;
        time_ns := integer(now / 1 ns);
        if Dout /= Dout_Expected then    
            assert false
            report "Output does not match expected value."
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
        
        
        
 ------ SCENARIO 2 ------
        ---------------------------------------------------
        --Reset
        ---------------------------------------------------
        reset <= '1';
        rst_ptr<= '1';
        rst_bidx <= '1';
        done_tb <= '0';
        tb_test <= "01";             
        Dout_Expected:= x"46650803";
        wait for 2*clk_period;
        reset <= '0';
        rst_ptr<= '0';
        rst_bidx <= '0';
        wait for clk_period;
        ---------------------------------------------------
        --Step 1. Initialize accumulators
        ---------------------------------------------------
        wait until rising_edge(clk);
        init <= '1';
        en_a1 <= '1';
        en_a2 <= '1';
        en_a3 <= '1';
        en_a4 <= '1';
        en_acc <= '1';
        en_bcnt <= '1';
        wait for clk_period;
        init <= '0';
        en_a1 <= '0';
        en_a2 <= '0';
        en_a3 <= '0';
        en_a4 <= '0';
        en_acc <= '0';
        ---------------------------------------------------
        --Load 2 word into input buffer
        ---------------------------------------------------
        en_buf <= '1';
        en_bidx <= '1';
        en_bcnt <= '1';
        din_valid_bytes <= "1111";
        op <= "00";
        
        din <= x"0000_0001";
        wait for clk_period;
        din <= x"0000_0010";
        rem_sel <= "10";
        en_remw <= '1';
        wait for clk_period;
        en_remw <= '0';
        en_buf <= '0';
        en_bidx <= '0';
        en_bcnt <= '0';
        ---------------------------------------------------
        --Step 4. Add input length
        ---------------------------------------------------
        en_acc <= '1';
        acc_stg <= "01";
        wait for clk_period;
        
        ---------------------------------------------------
        --Step 5. Consume remaining input 
        ---------------------------------------------------
        -- Full words --
         op <= "01";
         en_remw <= '1';
         en_ptr <= '1';
         en_acc <= '1';
         acc_stg <= "10"; 
         cyc <= '0';
         wait for clk_period;
         en_remw <= '0';
         en_ptr <= '0';
         cyc <= '1';
         wait for clk_period;
         en_remw <= '1';
         en_ptr <= '1';
         cyc <= '0';
         wait for clk_period;
         en_remw <= '0';
         en_ptr <= '0';
         cyc <= '1';
         wait for clk_period;
        ---------------------------------------------------
        --Step 6. Avalanche
        ---------------------------------------------------
        acc_stg <= "11";
        op <= "11";
        cyc <= '0';
        wait for clk_period;
        cyc <= '1';
        wait for clk_period;
        en_acc <= '0'; 
        done_tb <= '1';
        wait for clk_period/2;
        time_ns := integer(now / 1 ns);
        if Dout /= Dout_Expected then    
            assert false
            report "Output does not match expected value."
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
        
        --------------------Scenario 3---------------------
        -- 1 full stripe + 1 full word + partial word
        ---------------------------------------------------
        --Reset
        ---------------------------------------------------
        reset <= '1';
        rst_ptr<= '1';
        rst_bidx <= '1';
        done_tb <= '0';
        tb_test <= "10";
        Dout_Expected:= x"E5D228DD";  
        wait for 2*clk_period;
        reset <= '0';
        rst_ptr<= '0';
        rst_bidx <= '0';
        wait for clk_period;
        ---------------------------------------------------
        --Step 1. Initialize accumulators
        ---------------------------------------------------
        wait until rising_edge(clk);
        init <= '1';
        en_a1 <= '1';
        en_a2 <= '1';
        en_a3 <= '1';
        en_a4 <= '1';
        en_acc <= '1';
        en_bcnt <= '1';
        wait for clk_period;
        init <= '0';
        en_a1 <= '0';
        en_a2 <= '0';
        en_a3 <= '0';
        en_a4 <= '0';
        en_acc <= '0';
        ---------------------------------------------------
        --Load 4 word into input buffer
        ---------------------------------------------------
        en_buf <= '1';
        en_bidx <= '1';
        en_bcnt <= '1';
        din_valid_bytes <= "1111";
        op <= "00";
        
        din <= x"0000_0001";
        wait for clk_period;
        din <= x"0000_0010";
        wait for clk_period;
        din <= x"0000_0100";
        wait for clk_period;
        din <= x"0000_1000";
        wait for clk_period;
        en_bcnt <= '0';
        en_buf <= '0';
        en_bidx <= '0';
        ---------------------------------------------------
        --Step 2. Process stripes
        ---------------------------------------------------
        op <= "00";
        cyc <= '0';
        en_a1 <= '1';
        round_idx <= "00";
        wait for clk_period;
        cyc <= '1';
        wait for clk_period;
        en_a1 <= '0';
        en_a2 <= '1';
        cyc <= '0';
        round_idx <= "01";
        wait for clk_period;
        cyc <= '1';
        wait for clk_period;
        en_a2 <= '0';
        en_a3 <= '1';
        cyc <= '0';
        round_idx <= "10";
        wait for clk_period;
        cyc <= '1';
        wait for clk_period;
        en_a3 <= '0';
        en_a4 <= '1';
        cyc <= '0';
        round_idx <= "11";
        wait for clk_period;
        cyc <= '1';
        wait for clk_period;
        en_a4 <= '0';
        ---------------------------------------------------
        --Load more input into input buffer
        ---------------------------------------------------
        en_bidx <= '1';
        en_bcnt <= '1';
        en_buf <= '1';
        din_valid_bytes <= "1111";
        
        
        din <= x"0001_0000";
        wait for clk_period;
        din_valid_bytes <= "0001";
        din_in_last <= '1';
        din <= x"0000_0001";
        rem_sel <= "01";
        en_remw <= '1';
        wait for clk_period;
        rem_sel <= "00";
        en_remw <= '0';
        en_buf <= '0';
        en_bidx <= '0';
        en_bcnt <= '0';
        ---------------------------------------------------
        --Step 3. Accumulator convergence
        ---------------------------------------------------
        en_acc <= '1';
        acc_stg <= "00";
        wait for clk_period;
        ---------------------------------------------------
        --Step 4. Add input length
        ---------------------------------------------------
        acc_stg <= "01";
        wait for clk_period;
        ---------------------------------------------------
        --Step 5. Consume remaining input 
        ---------------------------------------------------
        -- Full words --
         op <= "01";
         en_acc <= '1';
         acc_stg <= "10";
         round_idx <= "00";   
         cyc <= '0';
         wait for clk_period;
         cyc <= '1';
         wait for clk_period;
         -- Byte Processing --
         op <= "10";
         en_acc <= '1';
         byte_sel <= "11";
         acc_stg <= "10";
         round_idx <= "01";   
         cyc <= '0';
         wait for clk_period;
         cyc <= '1';
         wait for clk_period;        
        ---------------------------------------------------
        --Step 6. Avalanche
        ---------------------------------------------------
        acc_stg <= "11";
        op <= "11";
        cyc <= '0';
        wait for clk_period;
        cyc <= '1';
        wait for clk_period;
        en_acc <= '0'; 
        done_tb <= '1';
        wait for clk_period/2;
        time_ns := integer(now / 1 ns);
        if Dout /= Dout_Expected then    
            assert false
            report "Output does not match expected value."
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
        wait;
        

    end process;

end architecture;

