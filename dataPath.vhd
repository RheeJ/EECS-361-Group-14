
library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
entity DataPath is 
end entity DataPath;

architecture struct of DataPath is

--------------------------------------------------------------------
-----------------------------components-----------------------------
--------------------------------------------------------------------


--component inst_mem is
--port(
--Adr: in std_logic_vector(31 downto 0); 
--opcode, func: out std_logic_vector(5 downto 0);
--Rs, Rt, Rd, shamt: out std_logic_vector(4 downto 0);
--imm16: out std_logic_vector(15 downto 0));
--end component;

component inst_mem is
  port(
 addr : in  std_logic_vector (31 downto 0); 
	inst : out std_logic_vector (31 downto 0));
end component;

component instruction_decoder is
  port (
    x      : in  std_logic_vector (31 downto 0);
	opcode : out std_logic_vector ( 5 downto 0);
	rs     : out std_logic_vector ( 4 downto 0);
	rt     : out std_logic_vector ( 4 downto 0);
	rd     : out std_logic_vector ( 4 downto 0);
	shamt  : out std_logic_vector ( 4 downto 0);
	funct  : out std_logic_vector ( 5 downto 0);
	addr   : out std_logic_vector (15 downto 0)
  );
end component;
    

component next_address_logic is
port (
		clk, branch, zero, rst : in std_logic; 
		instruction : in std_logic_vector(15 downto 0);
		addr : out std_logic_vector(31 downto 0)
		);
end component;




component controlSignals is
    Port (
    opcode : in std_logic_vector(5 downto 0);
    funct  : in std_logic_vector(5 downto 0);
    aluop  : out std_logic_vector(2 downto 0);
    regDst : out std_logic;
    aluSrc : out std_logic;
    memToReg : out std_logic;
    regWr : out std_logic;
    memRead : out std_logic;
    memWr : out std_logic;
    bne  : out std_logic;
    branch : out std_logic;
    ext_op : out std_logic
);
end component;

component reg32 is
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
end component;

component Extender is
port (
		imm16_in_ex : in std_logic_vector(15 downto 0);
		imm16_out_ex : out std_logic_vector(31 downto 0)
		);
end component;

component alu32bit is
  port (
	  a : in std_logic_vector(31 downto 0);
    b : in std_logic_vector(31 downto 0);
    opsel : in std_logic_vector(2 downto 0);
    result : out std_logic_vector(31 downto 0);
    carry_out : out std_logic;
    overflow : out std_logic;
    zero_flag  : out std_logic
  );
end component;

--component data_mem is 
--port(
	
--	  clk : in std_logic;
--	  we : in std_logic;
--		oe : in std_logic;
--		data_input : in std_logic_vector(31 downto 0);
--		address : in std_logic_vector(31 downto 0);	
--		data_output : out std_logic_vector(31 downto 0)
--	);

--end component;

component Data_Memory is
	port (
		cs : in std_logic;
		oe : in std_logic;
		we : in std_logic;
		address : in std_logic_vector(31 downto 0);
		data_input : in std_logic_vector(31 downto 0);
		data_output : out std_logic_vector(31 downto 0)
	);

end component;

component sign_ext is
 port (
		imm16 : in std_logic_vector(15 downto 0);
		output : out std_logic_vector(31 downto 0)
		);
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

component or_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component;



component mux_32 is
  port (
	sel   : in  std_logic;
	src0  : in  std_logic_vector(31 downto 0);
	src1  : in  std_logic_vector(31 downto 0);
	z	    : out std_logic_vector(31 downto 0)
  );
end component;


--------------------------------------------------------------------
------------------------------signals-------------------------------
--------------------------------------------------------------------

-------------------------Instruction Fetch----------------------
--next_address
signal addr_inst : std_logic_vector(31 downto 0);

--inst_mem
signal instruc : std_logic_vector(31 downto 0);
-------------------------Instruction Decode---------------------

signal opcode, funct    : std_logic_vector (5 downto 0);
signal rs,rt,rd       : std_logic_vector(4 downto 0);

signal shamt       : std_logic_vector(4 downto 0);

signal imm16       : std_logic_vector(15 downto 0);


--controlSignals
signal aluop     : std_logic_vector(2 downto 0);
signal regDst    : std_logic;
signal aluSrc    : std_logic;
signal memToReg  : std_logic;
signal regWr     : std_logic;
signal memRead   : std_logic;
signal memWr     : std_logic;
signal bne       : std_logic;
signal branch    : std_logic;
signal ext_op    : std_logic;
signal be_out    : std_logic;
signal bne_out   : std_logic;
signal b_out   : std_logic;

--reg32
--signal regWr,  regDst : std_logic;
signal busw : std_logic_vector (31 downto 0);
signal busA : std_logic_vector (31 downto 0);
signal busB : std_logic_vector (31 downto 0);

--Extender
signal imm16_out_ex : std_logic_vector(31 downto 0);

-- Sign extender
signal imm16_sign_ex_out : std_logic_vector(31 downto 0);

-- Mux1 output
signal mux0_out  : std_logic_vector(31 downto 0);
signal mux1_out_alu_binput : std_logic_vector(31 downto 0);

------------------------------Execution-------------------------
--alu32bit
--signal b          :  std_logic_vector(31 downto 0);
signal result     : std_logic_vector(31 downto 0);
signal carry_out  : std_logic;
signal zero_flag  :  std_logic;
signal not_zero_flag  :  std_logic ; 

--------------------------------Memory--------------------------
--Data_Memory
signal data_output : std_logic_vector(31 downto 0);



signal clk_tb : std_logic :='0';
signal clk_lw : std_logic := '0';
constant clk_period : time := 6ns;
constant clk_lw_period : time := 3 ns;
constant rst_period : time := 6ns;
signal rst_tb : std_logic;

--------------------------------------------------------------------
-----------------------------datapath-------------------------------
--------------------------------------------------------------------

-------------------------Instruction Fetch----------------------
begin
  
next_logic : next_address_logic port map(clk =>clk_tb,
              branch => b_out,
              zero => b_out,
              rst => rst_tb,
              instruction => imm16,
              addr => addr_inst);
              
              

--instruction_memory
--inst_mem_map : inst_mem port map
--             (addr_inst, opcode, funct, rs,rt,rd, shamt, imm16);

inst_mem_map : inst_mem port map
             (addr_inst, instruc);
-------------------------Instruction Decode---------------------

inst_decoder : instruction_decoder port map( instruc, opcode, rs,rt,rd,shamt,funct, imm16);



--controlSignals
con_sig_map : controlSignals port map
            (opcode=>opcode, funct=>funct, aluop=>aluop, regDst=>regDst,
			aluSrc=>aluSrc, memToReg=>memToReg, regWr=>regWr, memRead=>memRead,
			memWr=>memWr, bne=>bne, branch=>branch,
			ext_op=>ext_op);

not_zero_gate : not_gate port map(x=>zero_flag, z=> not_zero_flag);
and_gate1 : and_gate port map(bne, not_zero_flag, bne_out);
and_gate2 : and_gate port map(branch, zero_flag, be_out);  
or1_gate : or_gate port map(be_out,bne_out, b_out);
--reg32
reg32_map : reg32 port map
          (clk=> clk_tb, arst=> rst_tb, aload=> '0', RegWr=>regWr, RegDst=>regDst,
		  busw=> busW, rs=>rs, rt=>rt, rd=>rd, busA=>busA, busB=>busB);

--Extender
extend_map : Extender port map
           (imm16_in_ex=>imm16, imm16_out_ex=>imm16_out_ex);

-- sign extender
  sign_ex_map : sign_ext port map(imm16 => imm16, output => imm16_sign_ex_out);          
           
           
 -- Mux0 sig_op extender decider
 mux_map : mux_32 port map(sel=> ext_op  , src0=>imm16_out_ex   , src1=> imm16_sign_ex_out, z=> mux0_out);                
           
 -- Mux1 busB and Extender output
 mux_map1 : mux_32 port map(sel=> aluSrc  , src0=>busB   , src1=> mux0_out, z=> mux1_out_alu_binput);       

------------------------------Execution-------------------------
--alu32bit
alu32bit_map : alu32bit port map
             (a=> busA, b=> mux1_out_alu_binput, opsel=>aluop, result=>result, carry_out=>carry_out,
			  zero_flag=>zero_flag);

--------------------------------Memory--------------------------
--Data_Memory
data_mem_map : Data_Memory port map
             (cs=>'1', oe=>memRead, we=>memWr ,address=>result, data_input=>busB  ,  
			 data_output=>data_output);

-- Mux2 alu resutl and mem file output
 mux_map2 : mux_32 port map(sel=> memToReg  , src0=>result   , src1=> data_output, z=> busW);       



rst_stim: process
begin
  rst_tb <= '1';
  wait for rst_period;
  rst_tb <= '0';
  wait;
end process;			
clk_stim: process 
begin 
	clk_tb <= '0';
	wait for clk_period;
	clk_tb <= '1';
	wait for clk_period;
end process;
clk_lw_stim: process 
begin 
	clk_lw <= '0';
	wait for clk_lw_period;
	clk_lw <= '1';
	wait for clk_lw_period;
end process;

end architecture struct;