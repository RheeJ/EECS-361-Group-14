library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.eecs361_gates.all;

entity controlSignals is
  port (
    opcode : in std_logic_vector(5 downto 0);
    funct  : in std_logic_vector(5 downto 0);
    aluop  : out std_logic_vector(2 downto 0);
    regDst : out std_logic;
    aluSrc : out std_logic;
    memToReg : out std_logic;
    regWr : out std_logic;
    memRead : out std_logic;
    memWr : out std_logic;
    branch : out std_logic;
    bne   : out std_logic;
    ext_op : out std_logic
    );
  end controlSignals;
  
  architecture structural of controlSignals is
    
    component or_gate is
      port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
      );
    end component;
    
    component or_gate_n is
  generic (
    n   : integer
  );
  port (
    x   : in  std_logic_vector(n-1 downto 0);
    y   : in  std_logic_vector(n-1 downto 0);
    z   : out std_logic_vector(n-1 downto 0)
  );
end component;
    
    component mux is
          port (
	         sel	  : in	std_logic;
	         src0  :	in	std_logic;
	         src1  :	in	std_logic;
	         z	  : out std_logic
            );
          end component;
    
    
    signal r_type : std_logic;
    signal lw : std_logic;
    signal sw : std_logic;
    signal beq : std_logic;
    signal bneq : std_logic;
    signal bgtz : std_logic;
    signal addi : std_logic;
    
    signal aluSrc_or1 : std_logic;
    signal regWr_or1 : std_logic;
    signal branch_or1 : std_logic;
    
    signal r_type_func : std_logic_vector(5 downto 0);
    
    signal is_it_sll : std_logic_vector(11 downto 0);
    signal sll_bit : std_logic;
    
    signal alu_op1 : std_logic;
    signal alu_op11 : std_logic;
    signal alu_op12 : std_logic;
    signal alu_op13 : std_logic;
    
    
    signal alu_op2 : std_logic;
    signal alu_op21 : std_logic;
    signal alu_op22 : std_logic;
    signal alu_op23 : std_logic;
    
   
    
    signal aluop_or1: std_logic_vector(2 downto 0);
    signal aluop_or2: std_logic_vector(2 downto 0);
    signal aluop_or3: std_logic_vector(2 downto 0);
    signal aluop_or4: std_logic_vector(2 downto 0);
    signal aluop_or5: std_logic_vector(2 downto 0);
 
    
    signal aluop_add : std_logic_vector(2 downto 0);
    signal aluop_sub : std_logic_vector(2 downto 0);
    signal aluop_sllf : std_logic_vector(2 downto 0);
    signal aluop_slt : std_logic_vector(2 downto 0);
    signal aluop_sltu : std_logic_vector(2 downto 0);
    signal aluop_and1 : std_logic_vector(2 downto 0);
    signal aluop_or11 : std_logic_vector(2 downto 0);
    
    
    --r_type operations for alu control signals
    signal add : std_logic;
    signal addu : std_logic;
    signal sub : std_logic;
    signal subu : std_logic;
    signal sll_first : std_logic;
    signal sllf : std_logic;
    signal slt : std_logic;
    signal sltu : std_logic;
    signal and1 : std_logic;
    signal or1 : std_logic;
    
    begin
      r_type <= '1' when opcode = "000000" else '0';
      lw <= '1' when opcode = "100011" else '0';
      sw <= '1' when opcode = "101011" else '0';
      beq <= '1' when opcode = "000100" else '0';
      bneq <= '1' when opcode = "000101" else '0';
      bgtz <= '1' when opcode = "000111" else '0';
      addi <= '1' when opcode = "001000" else '0';
      
      or_gate_map0 : or_gate port map(x => beq, y => bneq , z=>branch_or1);
      or_gate_map01 : or_gate port map(x => branch_or1, y => bgtz , z=>branch);
      
      or_gate_for_bne : or_gate port map(x => bneq, y => bgtz , z=>bne);
        
      memToReg <= lw;
      
      or_gate_map1 : or_gate port map(x => lw, y => sw , z=>aluSrc_or1);
      or_gate_map2 : or_gate port map(x => aluSrc_or1, y => addi , z=>aluSrc);
      
     
      regDst <= r_type;
      memRead <=lw;
      memWr <= sw;
      
      or_gate_map3 : or_gate port map(x => addi, y => r_type , z=>regWr_or1);
      or_gate_map4 : or_gate port map(x => aluSrc_or1, y => lw, z=>regWr);
      
      or_gate_map5 : or_gate port map(x => lw, y => sw, z=> ext_op);
        
      -- alu operations
      -- decide whether it is r_type or not
      
       r_type_funct_decider : for i in 5 downto 0 generate
      mux_r_type_map : mux port map ( sel=> r_type, src0=> '0' , src1=> funct(i) , z => r_type_func(i));
        end generate r_type_funct_decider;
        
      add <= '1' when r_type_func = "100000" else '0';
      addu <= '1' when r_type_func = "100001" else '0';
      sub <= '1' when r_type_func = "100010" else '0';
      subu <= '1' when r_type_func = "100011" else '0';
      sll_first <= '1' when r_type_func = "000000" else '0'; -- needs to be cleaned
      slt <= '1' when r_type_func = "101010" else '0';
      sltu <= '1' when r_type_func = "101011" else '0';
      and1 <= '1' when r_type_func = "100100" else '0';
      or1 <= '1' when r_type_func = "100101" else '0';
      
      -- sll finalize
      
      mux_sll_map1 : mux port map ( sel=> opcode(0), src0=> '0' , src1=> '1' , z => is_it_sll(0));
      sll_funct_decider1 : for i in 1 to 5 generate
      mux_sll_map11 : mux port map ( sel=> opcode(i), src0=> is_it_sll(i-1) , src1=> '1' , z => is_it_sll(i));
        end generate sll_funct_decider1;
        
      sll_funct_decider2 : for j in 0 to 5 generate
      mux_sll_map22 : mux port map ( sel=>funct(j), src0=> is_it_sll(j+5) , src1=> '1' , z => is_it_sll(j+6));
        end generate sll_funct_decider2;
        
       sll_bit <= is_it_sll(11); 
      
      sllf <= '1' when sll_bit = '0' else '0';
      
      -- then for the all operations that go to alu
      
      or_gate_for_op_000_1 : or_gate port map(x => add, y => addi, z=> alu_op11);
      or_gate_for_op_000_2 : or_gate port map(x => alu_op11, y => addu, z=> alu_op12);
      or_gate_for_op_000_3 : or_gate port map(x => alu_op12, y => lw, z=> alu_op13);
      or_gate_for_op_000_4 : or_gate port map(x => alu_op13, y => sw, z=> alu_op1);
    
      aluop_add <= "111" when alu_op1 = '1' else "000";
      
      
      or_gate_for_op_001_1 : or_gate port map(x => sub, y => subu, z=> alu_op21);
      or_gate_for_op_001_2 : or_gate port map(x => alu_op21, y => beq, z=> alu_op22);
      or_gate_for_op_001_3 : or_gate port map(x => alu_op22, y => bneq, z=> alu_op23);
      or_gate_for_op_001_4 : or_gate port map(x => alu_op23, y => bgtz, z=> alu_op2);
    
      aluop_sub <= "001" when alu_op2 = '1' else "000";
      
      aluop_sllf <= "010" when sllf ='1' else "000";
      aluop_slt <= "011" when slt ='1' else "000";
      aluop_sltu <= "100" when sltu ='1' else "000";
      aluop_and1 <= "101" when and1 ='1' else "000";
      aluop_or11 <= "110" when or1 ='1' else "000";
      
      -- finialize the aluop
      
      
      or_gate_for_aluop_1 : or_gate_n generic map(n=>3) port map(x => aluop_add, y => aluop_sub, z=> aluop_or1);
      or_gate_for_aluop_2 : or_gate_n generic map(n=>3) port map(x => aluop_or1, y => aluop_sllf, z=> aluop_or2);
      or_gate_for_aluop_3 : or_gate_n generic map(n=>3) port map(x => aluop_or2, y => aluop_slt, z=> aluop_or3);
      or_gate_for_aluop_4 : or_gate_n generic map(n=>3) port map(x => aluop_or3, y => aluop_sltu, z=> aluop_or4);
      or_gate_for_aluop_5 : or_gate_n generic map(n=>3) port map(x => aluop_or4, y => aluop_and1, z=> aluop_or5);
      or_gate_for_aluop_6 : or_gate_n generic map(n=>3) port map(x => aluop_or5, y => aluop_or11, z=> aluop);
      
      
      
    end structural;
      
