----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2025 02:35:18 PM
-- Design Name: 
-- Module Name: datapath - Structural
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

entity datapath is
  Port (
        ---- Ports ----
        clk: in std_logic;
        reset: in std_logic;
        din: in std_logic_vector(31 downto 0);
        din_valid_bytes: in std_logic_vector(3 downto 0);
        dout: out std_logic_vector(31 downto 0);
        din_in_last : in std_logic;
        
        ---- Control signals
        op: in std_logic_vector(1 downto 0);
        byte_sel : in std_logic_vector(1 downto 0);
        acc_stg :  in std_logic_vector(1 downto 0);
        round_idx : in std_logic_vector(1 downto 0);
        cyc: in std_logic;
        init: in std_logic;
        rem_sel: in std_logic_vector(1 downto 0);
        gt16: out std_logic;
        zb: out std_logic;
        beq3: out std_logic;
        gt0: out std_logic;
        eq4: out std_logic;
        
        
        --- enables -- 
        en_a1: in std_logic;
        en_a2: in std_logic;
        en_a3: in std_logic;
        en_a4: in std_logic;
        en_acc: in std_logic;
        en_buf: in std_logic;
        en_bidx: in std_logic;       
        en_bcnt: in std_logic;      
        en_remw: in std_logic;
        en_ptr: in std_logic;
        
        rst_bidx: in std_logic;
        rst_ptr : in std_logic
        
         );
end datapath;

architecture Datapath of datapath is
-- Constants (PRIMES)--

constant PRIME1    : std_logic_vector(31 downto 0) := x"9E3779B1";
constant PRIME2    : std_logic_vector(31 downto 0) := x"85EBCA77";
constant PRIME3    : std_logic_vector(31 downto 0) := x"C2B2AE3D";
constant PRIME4    : std_logic_vector(31 downto 0) := x"27D4EB2F";
constant PRIME5    : std_logic_vector(31 downto 0) := x"165667B1";
constant PRIME1pP2 : std_logic_vector(31 downto 0) := x"24234428";
constant PRIME1n   : std_logic_vector(31 downto 0) := x"61C8864F";


-- Signals
signal buf_idx : std_logic_vector(1 downto 0);
signal ptr     : std_logic_vector(1 downto 0);
signal op00idx : std_logic_vector(1 downto 0);
signal acc_mux_out: std_logic_vector(31 downto 0);
signal rem_bytes : std_logic_vector(2 downto 0);
signal rem_words_in : std_logic_vector(1 downto 0);
signal rem_words_out : std_logic_vector(1 downto 0);
signal din_little_endian : std_logic_vector(31 downto 0);
signal byte_cnt_sel: std_logic_vector(1 downto 0);

signal byte_cnt_out: std_logic_vector(31 downto 0);
signal byte_cnt_in: std_logic_vector(31 downto 0);

signal acc1_in : std_logic_vector(31 downto 0);
signal acc1_out : std_logic_vector(31 downto 0);

signal acc2_in : std_logic_vector(31 downto 0);
signal acc2_out : std_logic_vector(31 downto 0);

signal acc3_in : std_logic_vector(31 downto 0);
signal acc3_out : std_logic_vector(31 downto 0);

signal acc4_in : std_logic_vector(31 downto 0);
signal acc4_out : std_logic_vector(31 downto 0);

signal acc_in : std_logic_vector(31 downto 0);
signal acc_out : std_logic_vector(31 downto 0);

signal mult_A : std_logic_vector(31 downto 0);
signal mult_B : std_logic_vector(31 downto 0);
signal mult_P : std_logic_vector(31 downto 0);

signal mult_A_c0 : std_logic_vector(31 downto 0);
signal mult_A_c1 : std_logic_vector(31 downto 0);
signal mult_B_c0 : std_logic_vector(31 downto 0);
signal mult_B_c1 : std_logic_vector(31 downto 0);

signal tmp_in : std_logic_vector(31 downto 0);
signal tmp_out : std_logic_vector(31 downto 0);

signal buf_addr : std_logic_vector(1 downto 0);
signal buf_in : std_logic_vector(31 downto 0);
signal buf_out : std_logic_vector(31 downto 0);


--  Inputs to operations --
signal round_in : std_logic_vector(31 downto 0);
signal rotate_in : std_logic_vector(31 downto 0);

--- Results of operations
signal avalanche_out : std_logic_vector(31 downto 0);
signal round_out : std_logic_vector(31 downto 0);
signal converge_out : std_logic_vector(31 downto 0);
signal accxr15 : std_logic_vector(31 downto 0);
signal add_out : std_logic_vector(31 downto 0);

signal extracted_byte : std_logic_vector(31 downto 0); -- 0 padded


begin

------ Entity Declarations ------

---Accumulators---
u_acc1 : entity work.reg 
port map ( clk => clk, rst => reset, en => en_a1, d => acc1_in, q => acc1_out );

u_acc2 : entity work.reg 
port map ( clk => clk, rst => reset, en => en_a2, d => acc2_in, q => acc2_out );

u_acc3 : entity work.reg 
port map ( clk => clk, rst => reset, en => en_a3, d => acc3_in, q => acc3_out );

u_acc4 : entity work.reg 
port map ( clk => clk, rst => reset, en => en_a4, d => acc4_in, q => acc4_out );

u_acc : entity work.reg 
port map ( clk => clk, rst => reset, en => en_acc, d => acc_in, q => acc_out );

--- Counter Registers ---
u_byte_cnt : entity work.reg 
port map ( clk => clk, rst => reset, en => en_bcnt, d => byte_cnt_in, q => byte_cnt_out );

u_rem_words : entity work.reg generic map(w => 2)
port map ( clk => clk, rst => reset, en => en_remw, d => rem_words_in, q => rem_words_out);

u_buf_idx : entity work.counter generic map(w => 2)
port map ( clk => clk, rst => rst_bidx, en => en_bidx, q => buf_idx);

u_ptr : entity work.counter generic map(w => 2)
port map ( clk => clk, rst => rst_ptr, en => en_ptr, q => ptr);

--- Multiplier ---
u_mult : entity work.mult32
port map ( a=> mult_A, b=> mult_B, prod => mult_P );

---Input Buffer ---
u_buffer : entity work.data_buffer
port map ( clk => clk, we => en_buf, addr=> buf_addr ,din => din_little_endian, dout => buf_out );

------ End of Entity Declarations ------

dout <= acc_out;

din_little_endian(31 downto 24) <= din(7 downto 0);
din_little_endian(23 downto 16) <= din(15 downto 8);
din_little_endian(15 downto 8)  <= din(23 downto 16);
din_little_endian(7 downto 0)   <= din(31 downto 24);

with en_buf select
    op00idx <= buf_idx         when '1',
               round_idx       when '0',
               (others => '0') when others;

with op select 
    buf_addr <= op00idx when "00",
                ptr when "01",
                std_logic_vector(unsigned(buf_idx) - 1)  when "10",
                (others => '0') when others;

converge_out <= std_logic_vector(
    (unsigned(acc1_out) rol 1) + (unsigned(acc2_out) rol 7) + 
    (unsigned(acc3_out) rol 12) + (unsigned(acc4_out) rol 18)
);

with rem_sel select
    rem_words_in <= std_logic_vector(unsigned(rem_words_out) - 1) when "00",
                    std_logic_vector(unsigned(buf_idx) - 1)      when "01",
                    buf_idx                                   when "10",
                    (others => '0') when others;

accxr15 <= acc_out xor std_logic_vector(unsigned(acc_out) srl 15);

add_out <= std_logic_vector(unsigned(mult_P) + unsigned(rotate_in));

rem_bytes <= std_logic_vector((unsigned("00" & din_valid_bytes(3 downto 3)) + 
                               unsigned("00" & din_valid_bytes(2 downto 2))) +
                              (unsigned("00" & din_valid_bytes(1 downto 1)) +
                               unsigned("00" & din_valid_bytes(0 downto 0))));

zb <= '1' when buf_idx = "00" else '0';
beq3 <= '1' when buf_idx = "11" else '0';
gt0 <= '1' when unsigned(rem_words_out) > 0 else '0';
gt16 <= '1' when unsigned(byte_cnt_out) >= 16 else '0';
eq4 <= '1' when rem_bytes = "100" else '0';

byte_cnt_sel <= din_in_last & init;
with (byte_cnt_sel) select
    byte_cnt_in <=  std_logic_vector(unsigned(byte_cnt_out) + 4)     when "00",
                    (others => '0')                                  when "01",
                    std_logic_vector( unsigned(byte_cnt_out) + resize(unsigned(rem_bytes),32)) when "10",
                    (others => '0')                                  when "11",
                    (others => '0')                                  when others;
with byte_sel select
    extracted_byte <= (31 downto 8 => '0') & buf_out(7 downto 0)      when "00",
                      (31 downto 8 => '0') & buf_out(15 downto 8)     when "01",
                      (31 downto 8 => '0') & buf_out(23 downto 16)    when "10",
                      (31 downto 8 => '0') & buf_out(31 downto 24)    when "11",
                      (others => '0')                                 when others;
                      
------ Multiply Operand B Muxing ------
with op select
    mult_b_c0 <= buf_out            when "00",
                 buf_out            when "01",
                 extracted_byte     when "10",
                 accxr15            when "11",
                 (others => '0')    when others;
with round_idx select
    round_in <= acc1_out when "00",
                acc2_out when "01",
                acc3_out when "10",
                acc4_out when "11",
                (others => '0') when others;

with op select 
    rotate_in <= round_in when "00",
                 acc_out when others;
with op select 
    mult_b_c1 <=  std_logic_vector(unsigned(rotate_in) rol 13) when "00",
                  std_logic_vector(unsigned(rotate_in) rol 17) when "01",
                  std_logic_vector(unsigned(rotate_in) rol 11) when "10",
                  rotate_in                                    when "11",
                  (others => '0')                              when others;
with cyc select
    mult_b <= mult_b_c0 when '0',
              mult_b_c1 when '1',
              (others => '0') when others;
------ End of Multiply Operand B Muxing ------

------ Multiply Operand A Muxing ------
with op select
    mult_a_c0 <= PRIME2            when "00",
                 PRIME3            when "01",
                 PRIME5            when "10",
                 PRIME2            when "11",
                 (others => '0')   when others;
with op select
    mult_a_c1 <= PRIME1            when "00",
                 PRIME4            when "01",
                 PRIME1            when "10",
                 PRIME3            when "11",
                 (others => '0')   when others;
with cyc select
    mult_a <= mult_a_c0        when '0',
              mult_a_c1        when '1',
              (others => '0')  when others;
              
              
------ End of Multiply Operand A Muxing ------

--- Accumulators (1-4) ---
with cyc select 
    round_out <= add_out         when '0',
                 mult_p          when '1',
                 (others => '0') when others;
with init select 
    acc1_in <= round_out       when '0',
               PRIME1pP2       when '1',
               (others => '0') when others;        
with init select 
    acc2_in <= round_out       when '0',
               PRIME2          when '1',
               (others => '0') when others; 
with init select 
    acc3_in <= round_out       when '0',
               (others => '0') when '1',
               (others => '0') when others; 
with init select 
    acc4_in <= round_out       when '0',
               PRIME1n         when '1',
               (others => '0') when others; 

               
with acc_stg select
    acc_mux_out <= converge_out                                                 when "00",
                   std_logic_vector(unsigned(acc_out) + unsigned(byte_cnt_out)) when "01",
                   round_out                                                    when "10",
                   avalanche_out                                                when "11",
                   (others => '0')                                              when others;
with init select 
    acc_in <=  acc_mux_out      when '0',
               PRIME5           when '1',
               (others => '0')  when others;
 
 
 --- Avalanche ---
with cyc select 
    avalanche_out <= mult_p xor std_logic_vector(unsigned(mult_p) srl 13) when '0',
                     mult_p xor std_logic_vector(unsigned(mult_p) srl 16) when '1',
                     (others => '0')                                      when others;         
end Datapath;
