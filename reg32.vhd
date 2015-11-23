library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.eecs361_gates.all;

entity reg32 is 
port(
  clk : in std_logic;
  arst: in std_logic;
  aload : in std_logic;
  busw : in std_logic_vector(31 downto 0);
  regWr : in std_logic; -- write enable bit
  regDst : in std_logic; -- sel bit for rd/rt
  rs : in std_logic_vector(4 downto 0);
  rt : in std_logic_vector(4 downto 0);
  rd : in std_logic_vector(4 downto 0);
  busA : out std_logic_vector(31 downto 0);
  busB : out std_logic_vector(31 downto 0)
);
end reg32;

architecture structural of reg32 is
  type register_all is array(31 downto 0) of std_logic_vector(31 downto 0); -- 32 arrays for all data
--  type register_all is array(31 downto 0) of std_ulogic;
--  type mem is array(31 downto 0) of register_all;
  
  signal regWrite : register_all;
  
  
  signal zero : std_logic_vector (31 downto 0); -- first array/address
  signal dec_out_rw : std_logic_vector(31 downto 0); -- decoder out for write enable from 5 to 32 
  signal dec_out_rs : std_logic_vector(31 downto 0); -- decoder out for write enable from 5 to 32 
  signal dec_out_rt : std_logic_vector(31 downto 0); -- decoder out for write enable from 5 to 32 
  --signal mux_out : std_logic_vector(31 downto 0); -- mux out for write enable and the write address 
  signal rw : std_logic_vector(4 downto 0); -- either rd or rt
  signal rw_enable_mux : std_logic_vector(31 downto 0);
--  signal regWrite : register_all;
  

--  signal busses_0,busses_1, busses_2,busses_3,busses_4, busses_5,busses_6,busses_7, busses_8,busses_9,busses_10, busses_11,
  --      busses_12,busses_13, busses_14,busses_15,busses_16, busses_17,busses_18,busses_19, busses_20,busses_21,busses_22, 
    --    busses_23,busses_24,busses_25, busses_26,busses_27,busses_28, busses_29,busses_30,busses_31 : std_logic_vector(31 downto 0);
  
  signal rwA : register_all;
  
  signal rwB : register_all;
  
  
--  signal demoo : std_logic_vector(31 downto 0);
--  signal demoo2 : std_logic;
  
  
  
  component dffr is
     port (
	   clk	: in  std_logic;
	   d	: in  std_logic;
	   q	: out std_logic
  );
end component;

component dffr_a is
   port (
	clk	   : in  std_logic;
  arst   : in  std_logic;
  aload  : in  std_logic;
  adata  : in  std_logic;
	d	   : in  std_logic;
  enable : in  std_logic;
	q	   : out std_logic
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
          
          begin
    zero <= "00000000000000000000000000000000";
    regWrite(0) <= zero;
    mux_rd_rt_sel : mux_n generic map(n=>5) port map( sel => regDst , src0=> rt  ,src1=> rd, z => rw);
    
    dec_map_for_rw : dec_n generic map( n=>5) port map( src=> rw, z=> dec_out_rw);
    
  write_addr : for i in 31 downto 0 generate 
           mux_rw_enable_map : mux port map ( sel=> regWr, src0=> '0' , src1=> dec_out_rw(i) , z => rw_enable_mux(i));
  end generate write_addr;
  
  
   
  
  reg_dffr_a_wr_outer_loop : for i in 1 to 31 generate
    reg_dffr_a_wr_inner_loop : for j in 0 to 31 generate
      dffr_a_map : dffr_a port map (
                          clk => clk,
                          arst => arst,
                          aload => aload,
                          adata => zero(j),
                          d => busW(j),
                          enable => rw_enable_mux(i),
                          q => regWrite(i)(j)
                      --   q => demoo(j)
                        );
   end generate reg_dffr_a_wr_inner_loop;
   end generate reg_dffr_a_wr_outer_loop;  
   
   
    dec_map_for_rs : dec_n generic map( n=>5) port map( src=> rs, z=> dec_out_rs);
    dec_map_for_rt : dec_n generic map( n=>5) port map( src=> rt, z=> dec_out_rt);   
   
   
   -- then push rt addr to busA and rs addr to busB with 2 gens loops 32 mux directly, in serial...
   

   
   
    mux_busA_map : mux_32 port map ( sel=> dec_out_rs(0), src0=> "00000000000000000000000000000000" , src1=> regWrite(0)  , z => rwA(0));  
          
   busA_initial : for k in 1 to 31 generate
      mux_busA_map : mux_32 port map ( sel=> dec_out_rs(k), src0=> rwA(k-1) , src1=> regWrite(k) , z => rwA(k));
 end generate busA_initial;
  
  busA <= rwA(31);   
  
  
   mux_busB_map : mux_32 port map ( sel=> dec_out_rt(0), src0=> "00000000000000000000000000000000" , src1=> regWrite(0)  , z => rwB(0));  
          
   busB_initial : for k in 1 to 31 generate
      mux_busB_map : mux_32 port map ( sel=> dec_out_rt(k), src0=> rwB(k-1) , src1=> regWrite(k) , z => rwB(k));
 end generate busB_initial;
  
  busB <= rwB(31);   
  
end architecture structural;           
                  
                    
    
      
    


  