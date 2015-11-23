library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.eecs361_gates.all;

entity alu32bit is
  port(
    a : in std_logic_vector(31 downto 0);
    b : in std_logic_vector(31 downto 0);
    opsel : in std_logic_vector(2 downto 0);
    result : out std_logic_vector(31 downto 0);
    carry_out : out std_logic;
    overflow : out std_logic;
    zero_flag  : out std_logic );
  end alu32bit;
    
    architecture structural of alu32bit is
      component alu1bit is
       port(
        a,b,carry_in, binvert : in std_logic;
        opsel : in std_logic_vector(7 downto 0);
        result, carry_out : out std_logic);
    
      end component;
      
      component not_gate is
        port (
         x   : in  std_logic;
          z   : out std_logic
        );
        end component;
        
        component and_gate is
        port (
          x   : in  std_logic;
          y   : in  std_logic;
          z   : out std_logic
        );
      end component;
      
      
      component mux_n is
        generic (
	     n	: integer
        );
        port (
	     sel	  : in	std_logic;
	     src0  :	in	std_logic_vector(n-1 downto 0);
	     src1  :	in	std_logic_vector(n-1 downto 0);
	     z	  : out std_logic_vector(n-1 downto 0)
        );
      end component;




      
      component dec_n is
        generic (
            n	: integer
          );
        port (
          src	: in std_logic_vector(n-1 downto 0);
          z	: out std_logic_vector((2**n)-1 downto 0)
          );
        end component;
        
         component mux_32 is
          port (
	       sel   : in  std_logic;
	       src0  : in  std_logic_vector(31 downto 0);
	       src1  : in  std_logic_vector(31 downto 0);
	         z	    : out std_logic_vector(31 downto 0));
           end component;
           
           component mux is
          port (
	         sel	  : in	std_logic;
	         src0  :	in	std_logic;
	         src1  :	in	std_logic;
	         z	  : out std_logic
            );
          end component;
          
           component or_gate is
          port (
	         x	  : in	std_logic;
	         y  :	in	std_logic;
	         z	  : out std_logic
            );
          end component;

           
          component nor_gate is
          port (
          x   : in  std_logic;
          y   : in  std_logic;
          z   : out std_logic
          );
          end component;

      
        
        signal carry : std_logic_vector(31 downto 0);
        signal artificial_result : std_logic_vector(31 downto 0);
        signal artificial_result1 : std_logic_vector(31 downto 0);
      --  signal zero_det_result : std_logic_vector (31 downto 0);
        signal artificial_zero_det : std_logic_vector(31 downto 0);
        signal zero : std_logic;
        signal opsel_bits : std_logic_vector(7 downto 0);
        signal carry_in_first : std_logic;
        signal binvert_all : std_logic;
        signal arti_overflow : std_logic;
        signal add_or_sub : std_logic;
        signal shifting_result : std_logic_vector(31 downto 0);
        signal zero_detector : std_logic_vector(31 downto 0);
        
        --opsel_signals
        signal opsel_or1 : std_logic;
        signal opsel_or2 : std_logic;
        signal opsel_or3 : std_logic;
        
     
        
       --sll
        signal sll_c1 : std_logic_vector(31 downto 0);
        signal sll_c2 : std_logic_vector(31 downto 0);
        signal sll_c3 : std_logic_vector(31 downto 0);
        signal sll_c4 : std_logic_vector(31 downto 0);  
        signal sll_c5 : std_logic_vector(31 downto 0);   
        signal sll_result : std_logic_vector(31 downto 0); 
       
        signal shift_rest_follower : std_logic_vector(0 to 25);
        signal shifting_b : std_logic_vector(31 downto 0); 
        
         
        
           
       
        --sltu
      --  signal sltu_not_cout : std_logic;
     --   signal sltu_t_f_sel : std_logic;
        signal sltu_true : std_logic;
        signal sltu_result : std_logic_vector(31 downto 0);
        
         --slt
       -- signal slt_not_cout : std_logic;
     --   signal slt_t_f_sel : std_logic;
        signal slt_true : std_logic;
        signal slt_result : std_logic_vector(31 downto 0);
        
        --results
        signal slt_out : std_logic_vector(31 downto 0);
        signal sltu_out : std_logic_vector(31 downto 0);
        signal sll_out : std_logic_vector(31 downto 0);
        
        
        
                
                
        begin
         -- in this ALU, operations are:  add,addi,addu,lw,sw : 111
         --                               sub,subu,beq,bne,bgtz : 001
         --                               sll : 010
         --                               slt : 011
         --                               sltu : 100
         --                               and : 101
         --                               or : 110
         --                               NEEDS TO BE COORDINATED!!
          
        dec_n_map : dec_n generic map (n => 3) port map(src => opsel, z=>opsel_bits);
           
           
           -- carry_in_first <= opsel_bits(3) or opsel_bits(4) or opsel_bits(5) ;
         
          opsel_map1 : or_gate port map ( x => opsel_bits(1), y=> opsel_bits(2), z => opsel_or1);
          opsel_map2 : or_gate port map ( x => opsel_or1, y=> opsel_bits(3), z => opsel_or2);
          opsel_map3 : or_gate port map ( x => opsel_or2, y=> opsel_bits(4),z => opsel_or3);
           
           carry_in_first <= opsel_or3;
            binvert_all <= carry_in_first;  
            
     
          
          artificial_zero_det <= X"00000000";
        --  slt_result <=X"00000000";
       --   sltu_result<=X"00000000";
          --srl_result <=X"00000000";
          
        
          A1 : alu1bit port map (a(0),b(0), carry_in_first, binvert_all,opsel_bits, artificial_result(0), carry(0));
          G1 : for i in 1 to 30 generate 
              ALUs : alu1bit port map (
                  a(i), b(i), carry(i-1), binvert_all, opsel_bits, artificial_result(i), carry(i));
                  
                end generate;
                
          A32 : alu1bit port map(a(31), b(31), carry(30), binvert_all, opsel_bits, artificial_result(31), carry(31));
          
        -- carry_out <= carry(31);
          
          overflow_map : xor_gate port map (x => carry(30), y => carry(31), z => arti_overflow);  
          shifting_result <= a ;
          shifting_b <= b;
       
    
        
        shift_result1 : for i in 31 downto 1 generate
          mux_sll_map1 : mux port map ( sel=> shifting_b(0), src0=> shifting_result(i) , src1=> shifting_result(i-1) , z => sll_c1(i));
          end generate shift_result1;  
         mux_sll_map11 : mux port map ( sel=> shifting_b(0), src0=> shifting_result(0) , src1=> '0' , z => sll_c1(0));  
        
        shift_result2 : for i in 31 downto 2 generate
          mux_sll_map2 : mux port map ( sel=> shifting_b(1), src0=> sll_c1(i) , src1=> sll_c1(i-2) , z => sll_c2(i));
          end generate shift_result2;
           mux_sll_map21 : mux_n generic map(n=>2) port map ( sel=> shifting_b(1), src0=> sll_c1(1 downto 0) , src1=> "00" , z => sll_c2(1 downto 0));  
         
         shift_result3 : for i in 31 downto 4 generate
          mux_sll_map3 : mux port map ( sel=> shifting_b(2), src0=> sll_c2(i) , src1=> sll_c2(i-4) , z => sll_c3(i));
          end generate shift_result3;
           mux_sll_map31 : mux_n generic map(n=>4) port map ( sel=> shifting_b(2), src0=> sll_c2(3 downto 0) , src1=> "0000" , z => sll_c3(3 downto 0));  
         
         shift_result4 : for i in 31 downto 8 generate
          mux_sll_map4 : mux port map ( sel=> shifting_b(3), src0=> sll_c3(i) , src1=> sll_c3(i-8) , z => sll_c4(i));
          end generate shift_result4; 
           mux_sll_map41 : mux_n generic map(n=>8) port map ( sel=> shifting_b(3), src0=> sll_c3(7 downto 0) , src1=> "00000000" , z => sll_c4(7 downto 0));  
         
         shift_result5 : for i in 31 downto 16 generate
          mux_sll_map5 : mux port map ( sel=> shifting_b(4), src0=> sll_c4(i) , src1=> sll_c4(i-16) , z => sll_c5(i));
          end generate shift_result5;
           mux_sll_map51 : mux_n generic map(n=>16) port map ( sel=> shifting_b(4), src0=> sll_c4(15 downto 0) , src1=> "0000000000000000" , z => sll_c5(15 downto 0));  
           
            
           mux_sll_rest1 : mux port map ( sel=> shifting_b(5), src0=> '0' , src1=> '1' , z => shift_rest_follower(0));
          
          shift_result6 : for i in 0 to 24 generate
          mux_zero_map6 : mux port map ( sel=> shifting_b(6+i), src0=> shift_rest_follower(i) , src1=> '1' , z => shift_rest_follower(i+1));
          end generate shift_result6;
           mux_sll_map61 : mux_32 port map ( sel=> shift_rest_follower(25), src0=> sll_c5, src1=> "00000000000000000000000000000000" , z => sll_result);  
          
        
        --sltu
        
       -- not_cout_map : not_gate port map(x=> carry(31) , z => sltu_not_cout);
      --  sel_and_map  : and_gate port map(x=> sltu_not_cout , y=> artificial_result(31), z=>sltu_t_f_sel);
      --  mux_sltu_map1 : mux port map ( sel=> sltu_t_f_sel, src0=> '0' , src1=> '1' , z => sltu_true);
           mux_sltu_map1 : mux port map ( sel=> artificial_result(31), src0=> '0' , src1=> '1' , z => sltu_true);
          
        sltu_result(0) <= sltu_true;
        sltu_result(31 downto 1) <="0000000000000000000000000000000";
    
    
    
        --slt
        
        --not_cout_map1 : not_gate port map(x=> carry_out , y => slt_not_cout);
      --  sel_and_map1  : and_gate port map(x=>  carry(31), y=> artificial_result(31), z=>slt_t_f_sel);
       -- mux_slt_map1 : mux port map ( sel=> slt_t_f_sel, src0=> '0' , src1=> '1' , z => slt_true);
          mux_slt_map1 : mux port map ( sel=> artificial_result(31), src0=> '1' , src1=> '0' , z => slt_true);
          
        slt_result(0) <= slt_true;
        slt_result(31 downto 1) <="0000000000000000000000000000000";
        
        --mux to decide which result is true (slt, sltu, sll, artificial(that comes from ALUs)
        
        mux_results_map1: mux_32 port map(sel=>opsel_bits(3),  src0=> artificial_result , src1=> slt_result,  z => slt_out);
        mux_results_map2: mux_32 port map(sel=>opsel_bits(4),  src0=> slt_out , src1=> sltu_result,  z => sltu_out);
        mux_results_map3: mux_32 port map(sel=>opsel_bits(2),  src0=> sltu_out , src1=> sll_result,  z => sll_out);
          
        artificial_result1<=  sll_out;
         
              
       --  finialize carry_out, overflow
        
        add_or_sub <= opsel_bits(2) or opsel_bits(3);
        
        mux_overflow_map1: mux port map(sel=>add_or_sub,  src0=>'0'  , src1=> arti_overflow,  z => overflow);
        mux_carry_out_map1: mux port map(sel=>add_or_sub,  src0=>'0'  , src1=> carry(31),  z => carry_out);
           
              
      
      -- zero_flag it is for branch operations
         
         result <= artificial_result1;
        -- zero <= '1';
        
        mux_zero_map1 : mux port map ( sel=> artificial_result1(0), src0=> '0' , src1=> '1' , z => zero_detector(0));

        gen_zero : for i in 1 to 31 generate   
        mux_zero_map2 : mux port map ( sel=> artificial_result1(i), src0=> zero_detector(i-1) , src1=> '1' , z => zero_detector(i));
        end generate gen_zero;
          
          zero_not_gate : not_gate port map(x=>zero_detector(31), z=>zero);
          zero_flag <= zero;

          
         
        end structural;        
      
      
      
    

