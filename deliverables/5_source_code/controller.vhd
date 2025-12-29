----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2025 03:21:48 PM
-- Design Name: 
-- Module Name: controller - Behavioral
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

entity controller is
  Port (
        clk: in std_logic;
        reset: in std_logic;    
        din_ready: out std_logic;
        dout_valid: out std_logic;
        dout_ready: in std_logic;
        din_valid_bytes: in std_logic_vector(3 downto 0);
        din_valid: in std_logic;
        din_in_last: in std_logic;

        
        --- flags 
        gt16: in std_logic;
        zb: in std_logic;
        beq3: in std_logic;
        gt0: in std_logic;
        eq4: in std_logic;
       
       ---controls 
        op: out std_logic_vector(1 downto 0);
        byte_sel : out std_logic_vector(1 downto 0);
        rem_sel : out std_logic_vector(1 downto 0);
        acc_stg :  out std_logic_vector(1 downto 0);
        round_idx : out std_logic_vector(1 downto 0);
        cyc: out std_logic;
        init: out std_logic;
        
        --- enables -- 
        en_a1: out std_logic;
        en_a2: out std_logic;
        en_a3: out std_logic;
        en_a4: out std_logic;
        en_acc: out std_logic;
        en_buf: out std_logic;
        en_bidx: out std_logic;
        en_bcnt: out std_logic;
        en_remw: out std_logic;
        en_ptr: out std_logic; 
        
        rst_bidx: out std_logic;
        rst_ptr : out std_logic
        
                     );

end controller;

architecture Behavioral of controller is


type state is(init_s,input_s,convergence_s,add_input_s,avalanche_s0,avalanche_s1,dout_s,ST0,ST1,ST2,ST3,ST4,ST5,ST6,ST7,FS0,FS1,PS0,PS1,PS2,PS3,PS4,PS5);
signal curr_state, next_state: state;


begin

process(clk,reset) 
begin
    if(reset = '1') then
        curr_state <= init_s; 
    elsif(rising_edge(clk)) then
        curr_state <= next_state;
    end if;
end process;


next_state_proc:
process(curr_state,gt16,zb,beq3,gt0,eq4,din_valid_bytes,din_valid,din_in_last,dout_ready)
begin
    -- Default Values
    din_ready      <= '0';
    dout_valid     <= '0';
    op             <= "00";
    byte_sel       <= "00";
    acc_stg        <= "00";
    round_idx      <= "00";
    cyc            <= '0';
    init           <= '0';
    rem_sel        <= "00";

    en_a1          <= '0';
    en_a2          <= '0';
    en_a3          <= '0';
    en_a4          <= '0';
    en_acc         <= '0';
    en_buf         <= '0';
    en_bidx        <= '0';
    en_bcnt        <= '0';
    en_remw        <= '0';
    en_ptr         <= '0';
    rst_bidx <= '0';
    rst_ptr <= '0';
    next_state <= curr_state;
    
    case curr_state is
        ---- Main FSM ---
        when init_s => 
            en_a1  <= '1';
            en_a2  <= '1';
            en_a3  <= '1';
            en_a4  <= '1';
            init   <= '1';
            en_acc <= '1';            
            next_state <= input_s;
            rst_bidx <= '1';
            rst_ptr <= '1';
            en_bcnt <= '1';
         when input_s => 
            din_ready <= '1';
            if(din_valid = '1') then
                en_bidx <= '1';
                en_bcnt <= '1';
                en_buf  <= '1';
                if(din_in_last = '0') then
                    if(beq3 = '1') then
                        next_state <= st0;
                        
                    else
                        next_state <= input_s;
                    end if;
                else
                    if(eq4 = '1' and beq3 = '1') then 
                        next_state <= st0;
                    else
                        if(gt16 = '1') then
                            next_state<=convergence_s;
                        else
                            next_state<=add_input_s;
                        end if;
                   end if;
                end if;
            else
                next_state <= input_s;
            end if;
            
          when convergence_s =>
            en_acc <= '1';
            acc_stg <= "00";
            next_state <= add_input_s;
          when add_input_s => 
            en_acc <= '1';
            acc_stg <= "01";
            if(zb = '1' and eq4 = '1') then
                next_state <= avalanche_s0;
            else    
                if(eq4 = '1') then 
                    rem_sel <= "10";
                    en_remw <= '1';
                else
                    rem_sel <= "01";
                    en_remw <= '1';
                end if;
                next_state <= fs0;            
            end if;
          when avalanche_s0 => 
            en_acc <= '1';
            cyc <= '0';
            op <= "11";
            acc_stg <= "11";
            next_state <= avalanche_s1;
          when avalanche_s1 =>
            cyc <= '1';
            en_acc <= '1';
            op <= "11";
            acc_stg <= "11";
            next_state <= dout_s;
           when dout_s =>
            dout_valid <= '1';
            if (dout_ready = '1') then 
                next_state <= init_s;
            else
                next_state <= dout_s;
            end if;
           ---- Stripe FSM ---
           when st0 =>
            din_ready <= '0';
            round_idx <= "00";
            op <= "00";
            cyc <= '0';
            en_a1 <= '1'; 
            next_state <= st1;
           when st1 =>
            round_idx <= "00";
            op <= "00";
            cyc <= '1';
            en_a1 <= '1'; 
            next_state <= st2;
           when st2 =>
            round_idx <= "01";
            op <= "00";
            cyc <= '0';
            en_a2 <= '1'; 
            next_state <= st3;
           when st3 =>
            round_idx <= "01";
            op <= "00";
            cyc <= '1';
            en_a2 <= '1'; 
            next_state <= st4;
           when st4 =>
            round_idx <= "10";
            op <= "00";
            cyc <= '0';
            en_a3 <= '1'; 
            next_state <= st5;
           when st5 =>
            round_idx <= "10";
            op <= "00";
            cyc <= '1';
            en_a3 <= '1'; 
            next_state <= st6;
           when st6 =>
            round_idx <= "11";
            op <= "00";
            cyc <= '0';
            en_a4 <= '1'; 
            next_state <= st7;
           when st7 =>
            round_idx <= "11";
            op <= "00";
            cyc <= '1';
            en_a4 <= '1'; 
            if(din_in_last ='1') then 
                if(gt16 = '1') then
                    next_state<=convergence_s;
                else
                    next_state<=add_input_s;
                end if;
            else
                next_state <= input_s;
            end if;
           ---- Full FSM ---
           when fs0 => 
            en_ptr <= '1';
            en_remw <= '1';
            op <= "01";
            cyc <= '0';
            en_acc <= '1';
            acc_stg <= "10";
            next_state <= fs1;
           when fs1 => 
            cyc <= '1';
            en_ptr <= '0';
            en_remw <= '0';
            op <= "01";
            en_acc <= '1';
            acc_stg <= "10";
            if(gt0 = '1') then
                next_state <= fs0;
            else
                if(eq4 = '1') then
                    next_state <= avalanche_s0;
                else
                    next_state <= ps0;
                end if;
            end if;
           ---- Partial FSM ---
           when ps0 => 
            op <= "10";
            cyc <= '0';
            acc_stg <= "10";
            if(din_valid_bytes(3) = '1') then
                byte_sel <= "00";
                en_acc <= '1';
                next_state <= ps1;
            else
                next_state <= avalanche_s0;
            end if;
           when ps1 =>
            op <= "10";
            cyc <= '1';
            byte_sel <= "00";
            en_acc <= '1';
            acc_stg <= "10";           
            next_state <= ps2;
           when ps2 => 
            op <= "10";
            cyc <= '0';
            acc_stg <= "10";
            if(din_valid_bytes(2) = '1') then
                byte_sel <= "01";
                en_acc <= '1';
                next_state <= ps3;
            else
                next_state <= avalanche_s0;
            end if;
           when ps3 =>
            op <= "10";
            cyc <= '1';
            byte_sel <= "01";
            en_acc <= '1';
            acc_stg <= "10";  
            next_state <= ps4;
           when ps4 => 
            op <= "10";
            cyc <= '0';
            acc_stg <= "10";
            if(din_valid_bytes(1) = '1') then
                byte_sel <= "10";
                en_acc <= '1';
                next_state <= ps5;
            else
                next_state <= avalanche_s0;
            end if;
           when ps5 =>
            op <= "10";
            cyc <= '1';
            byte_sel <= "10";
            en_acc <= '1';
            acc_stg <= "10";  
            next_state <= avalanche_s0;   
    end case;
end process;

end Behavioral;
