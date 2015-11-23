
library ieee;
use ieee.std_logic_1164.all;

entity alu32_tb is
  port ( 
   result        : out std_logic_vector(31 downto 0);
  carry_out      : out std_logic  ;  
  overflow      : out std_logic;
  zero          : out std_logic
 
  );
end alu32_tb;    

architecture structural of alu32_tb is

component alu32bit is
   port(
    a : in std_logic_vector(31 downto 0);
    b : in std_logic_vector(31 downto 0);
    opsel : in std_logic_vector(2 downto 0);
    result : out std_logic_vector(31 downto 0);
    carry_out : out std_logic;
    overflow : out std_logic;
    zero_flag  : out std_logic 
    );
  end component;


  signal a_in   : std_logic_vector(31 downto 0);
  signal b_in   : std_logic_vector(31 downto 0);
  
  signal opsel_in   : std_logic_vector(2 downto 0);

  

  begin   
  alu32_map : alu32bit port map (a => a_in, b => b_in, opsel => opsel_in, result => result, carry_out => carry_out,
  overflow => overflow, zero_flag => zero);   
--  cin <= inbus(2);   
--  yin <= inbus(1);   
--  xin <= inbus(0);   
  test_proc : process   
  begin  
  wait for 5 ns; 
  a_in <= "10000000000000000000000000000000";
          -- 10000000100000001000000010000000
  b_in <= "01110000000000000000000000000000";
  opsel_in <= "011";  
 
--  wait for 5 ns; 
--  a_in <= "10000000000000000000000000000000";
--          -- 10000000100000001000000010000000
--  b_in <= "01110000000000000000000000000000";
--  opsel_in <= "100"; 
    
--  wait for 5 ns;     
--  inbus <= "010";     
--  wait for 5 ns;     
--  inbus <= "011";     
  --wait for 5 ns;     
  --inbus <= "100";     
 -- wait for 5 ns;     
  --inbus <= "101";     
  --wait for 5 ns;     
  --inbus <= "110";     
  --wait for 5 ns;     
  --inbus <= "111";     
  wait for 5 ns;     
  wait;   
  end process;
  end architecture structural;