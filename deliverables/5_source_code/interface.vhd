----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2025 03:19:23 PM
-- Design Name: 
-- Module Name: interface - Behavioral
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


entity interface is
  Port ( clk: in std_logic;
         reset: in std_logic;
         din: in std_logic_vector(31 downto 0);
         din_ready: out std_logic;
         din_valid: in std_logic;
         din_in_last: in std_logic;
         din_valid_bytes: in std_logic_vector(3 downto 0);
         dout: out std_logic_vector(31 downto 0);
         dout_ready: in std_logic;
         dout_valid: out std_logic
         );
end interface;

architecture Structural of interface is

-- Control signals 
signal op        : std_logic_vector(1 downto 0);
signal byte_sel  : std_logic_vector(1 downto 0);
signal rem_sel  : std_logic_vector(1 downto 0);
signal acc_stg   : std_logic_vector(1 downto 0);
signal round_idx : std_logic_vector(1 downto 0);
signal cyc       : std_logic;
signal init      : std_logic;

-- Status Signals 
signal gt16 : std_logic;
signal zb   : std_logic;
signal beq3 : std_logic;
signal gt0  : std_logic;
signal eq4  : std_logic;

-- Enables
signal en_a1   : std_logic;
signal en_a2   : std_logic;
signal en_a3   : std_logic;
signal en_a4   : std_logic;
signal en_acc  : std_logic;
signal en_buf  : std_logic;
signal en_bidx : std_logic;
signal en_bcnt : std_logic;
signal en_remw : std_logic;
signal en_ptr  : std_logic;

signal rst_bidx : std_logic;
signal rst_ptr  : std_logic;

begin

u_controller : entity work.controller
    port map (
        clk  => clk,
        reset => reset,

        din_valid_bytes => din_valid_bytes,
        din_ready => din_ready,
        dout_valid => dout_valid,
        dout_ready => dout_ready,
        din_valid => din_valid,
        din_in_last => din_in_last,
        

        op        => op,
        byte_sel  => byte_sel,
        acc_stg   => acc_stg,
        round_idx => round_idx,
        cyc       => cyc,
        init      => init,
        rem_sel      => rem_sel,

        gt16 => gt16,
        zb   => zb,
        beq3 => beq3,
        gt0  => gt0,
        eq4  => eq4,

        en_a1   => en_a1,
        en_a2   => en_a2,
        en_a3   => en_a3,
        en_a4   => en_a4,
        en_acc  => en_acc,
        en_buf  => en_buf,
        en_bidx => en_bidx,
        en_bcnt => en_bcnt,
        en_remw => en_remw,
        en_ptr  => en_ptr,
        
        rst_bidx => rst_bidx,
        rst_ptr  => rst_ptr
    );


u_datapath : entity work.datapath
    port map (
        clk  => clk,
        reset => reset,

        din => din,
        din_valid_bytes => din_valid_bytes,
        dout => dout,
        din_in_last => din_in_last,

        op        => op,
        byte_sel  => byte_sel,
        acc_stg   => acc_stg,
        round_idx => round_idx,
        cyc       => cyc,
        init      => init,
        rem_sel      => rem_sel,

        gt16 => gt16,
        zb   => zb,
        beq3 => beq3,
        gt0  => gt0,
        eq4  => eq4,

        en_a1   => en_a1,
        en_a2   => en_a2,
        en_a3   => en_a3,
        en_a4   => en_a4,
        en_acc  => en_acc,
        en_buf  => en_buf,
        en_bidx => en_bidx,
        en_bcnt => en_bcnt,
        en_remw => en_remw,
        en_ptr  => en_ptr,
        
        rst_bidx => rst_bidx,
        rst_ptr  => rst_ptr
    );

end Structural;
