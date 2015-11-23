
library ieee;
use work.eecs361_gates.all;
use work.eecs361.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity Data_Memory is
	port (
		cs : in std_logic;
		oe : in std_logic;
		we : in std_logic;
		address : in std_logic_vector(31 downto 0);
		data_input : in std_logic_vector(31 downto 0);
		data_output : out std_logic_vector(31 downto 0)
	);

end Data_Memory;

architecture Structure of Data_Memory is
begin
	sram_map : sram generic map (mem_file => "sort_corrected_branch.dat")
		port map (cs => cs, oe => oe, we => we, addr => address, din => data_input, dout => data_output);
end Structure;


