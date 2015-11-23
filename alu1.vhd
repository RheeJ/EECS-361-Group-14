library ieee;
use ieee.std_logic_1164.all; 
use work.eecs361_gates.all; 

entity alu1bit is 
  port(
    a,b,carry_in, binvert: in std_logic;
    opsel : in std_logic_vector(7 downto 0);
    result, carry_out : out std_logic);
    
  end alu1bit;
  
  architecture behaviour of alu1bit is
    
    
    component mux is
      port (
	       sel	  : in	std_logic;
	       src0  :	in	std_logic;
	       src1  :	in	std_logic;
	         z	  : out std_logic
   );
    end component;
    
    component fulladder is
      port (     
          x    : in  std_logic;     
          y    : in  std_logic;    
          c    : in  std_logic;     
          z    : out std_logic;     
          cout : out std_logic   ); 
    end component; 
        
    
    
    
    signal xor1 : std_logic; 
    signal and1 : std_logic; 
    signal or1 : std_logic;
    signal adder1 : std_logic;
    signal sub_select : std_logic;
    signal not_b :  std_logic;
    signal and1_out : std_logic;
    signal or_out : std_logic;
    signal adder_out1 : std_logic;
    signal adder_out2 : std_logic;
    signal adder_out3 : std_logic;
    signal adder_out4 : std_logic;
   
    
    
    
    
    begin   
   -- xor1_map : xor_gate port map (x => a, y => b, z => xor1);    
    and1_map : and_gate port map (x => a, y => b, z => and1);   
    or1_map : or_gate port map (x => a, y => b, z => or1);
    not_b_map : not_gate port map(x => b , z => not_b);
    mux1_map : mux port map ( sel=> binvert, src0=> b , src1=> not_b , z => sub_select); 
    adder1_map : fulladder port map (x => a, y => sub_select, c => carry_in , z => adder1, cout => carry_out);     
    
    mux_opsel1 : mux port map (sel => opsel(1) , src0 => '0' , src1 => adder1, z => adder_out1);
    mux_opsel2 : mux port map (sel => opsel(2) , src0 =>  adder_out1 , src1 => adder1, z => adder_out2);  
    mux_opsel3 : mux port map (sel => opsel(3) , src0 => adder_out2 , src1 => adder1, z => adder_out3);
    mux_opsel4 : mux port map (sel => opsel(4) , src0 => adder_out3 , src1 => adder1, z => adder_out4);
    mux_opsel5 : mux port map (sel => opsel(5) , src0 => adder_out4 , src1 => and1, z => and1_out);
    mux_opsel6 : mux port map (sel => opsel(6) , src0 => and1_out , src1 => or1, z => or_out);  
    mux_opsel7 : mux port map (sel => opsel(7) , src0 => or_out , src1 => adder1, z => result);
   
      
      
 end behaviour;

