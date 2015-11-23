library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity inst_mem is
  port (
    addr : in  std_logic_vector (31 downto 0);
    
	inst : out std_logic_vector (31 downto 0)
  );
end inst_mem;

architecture structural of inst_mem is
  
begin
  sram_map  : sram 
      generic map (mem_file => "sort_corrected_branch.dat")
      port map  (cs=>'1', oe=>'1', we=>'0', addr=>addr, din=>(others=>'0'), dout=>inst);
end architecture;