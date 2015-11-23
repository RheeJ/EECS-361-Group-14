

library ieee;
use ieee.std_logic_1164.all;

entity alu1_tb is
  port ( 
   result        : out std_logic;
  carry_out      : out std_logic    
 
  );
end alu1_tb;    

architecture structural of alu1_tb is

component alu1bit is
   port(
    a,b,carry_in, binvert: in std_logic;
    opsel : in std_logic_vector(7 downto 0);
    result, carry_out : out std_logic   );
  end component;


  signal a_in   : std_logic;
  signal b_in   : std_logic;
  signal binvert_in : std_logic;
  signal carry_in : std_logic;
  signal opsel_in   : std_logic_vector(7 downto 0);

  

  begin   
  alu1_map : alu1bit port map (a => a_in, b => b_in, carry_in => carry_in, binvert => binvert_in, opsel => opsel_in, result => result, carry_out => carry_out  );   
--  cin <= inbus(2);   
--  yin <= inbus(1);   
--  xin <= inbus(0);   
  test_proc : process   
  begin  
  a_in <= '0';
  b_in <= '1';
  binvert_in <= '0';
  carry_in <= '1';
  opsel_in <= "00001000";
    
  wait for 5 ns;   
   a_in <= '0';
  b_in <= '1';
  binvert_in <= '0';
  carry_in <= '1';
  opsel_in <= "00001000";
  wait for 5 ns; 
   
    
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
