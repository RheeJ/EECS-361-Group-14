
library ieee;
use work.eecs361_gates.all;
use work.eecs361.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity data_mem is
	port (
	  clk : in std_logic;
	--	cs : in std_logic;
	  we : in std_logic;
		oe : in std_logic;
		data_input : in std_logic_vector(31 downto 0);
		address : in std_logic_vector(31 downto 0);	
		data_output : out std_logic_vector(31 downto 0)
	);

end data_mem;

architecture structure of data_mem is
  
  component sram is 
  generic (
	mem_file : string
  );
  port (
	cs	  : in	std_logic;
	oe	  :	in	std_logic;
	we	  :	in	std_logic;
	addr  : in	std_logic_vector(31 downto 0);
	din	  :	in	std_logic_vector(31 downto 0);
	dout  :	out std_logic_vector(31 downto 0)
  );
end component;
  
begin
	sram_map : syncram
	generic map (mem_file => "sort_corrected_branch.dat") port map (clk,'1', oe,  we,  address, data_input,  data_output);
end structure;