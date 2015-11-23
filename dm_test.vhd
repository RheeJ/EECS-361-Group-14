
library ieee;
use work.eecs361_gates.all;
use work.eecs361.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity dm_test is
	port (
		dout : out std_logic_vector(31 downto 0)
	);
end dm_test;

architecture structural of dm_test is
signal c : std_logic;
signal o : std_logic;
signal w : std_logic;
signal di : std_logic_vector(31 downto 0);
signal do : std_logic_vector(31 downto 0);
signal addr : std_logic_vector(31 downto 0);
signal ctrl_bus : std_logic_vector(2 downto 0);
component Data_Memory is
	port (
		cs : in std_logic;
		oe : in std_logic;
		we : in std_logic;
		address : in std_logic_vector(31 downto 0);
		data_input : in std_logic_vector(31 downto 0);
		data_output : out std_logic_vector(31 downto 0)
	);
end component Data_Memory;
begin
	dm_map : Data_Memory port map (cs => c, oe => o, we => w, address => addr, data_input => di, data_output => dout);
	c <= ctrl_bus(2);
	o <= ctrl_bus(1);
	w <= ctrl_bus(0);
	process
		variable vaddr : integer range 0 to 2147483647;
	begin
		ctrl_bus <= "110";
		for vaddr in 4194336 to 4194376 loop
			addr <= std_logic_vector(to_unsigned(vaddr, 32));
			wait for 5 ns;
		end loop;
		ctrl_bus <= "111";
		addr <= std_logic_vector(to_unsigned(4194336, 32));
		di <= X"00000000";
		wait for 5 ns;
		wait;
	end process;
end; 
