library ieee;
use ieee.std_logic_1164.all;

entity mem_test is
	port (
		cs : in std_logic;
		oe : in std_logic;
		we : in std_logic;
		data_input : in std_logic_vector(31 downto 0);
		data_output : out std_logic_vector(31 downto 0);
		address : in std_logic_vector(31 downto 0)
	);
end mem_test;

architecture structure of mem_test is
component Data_Memory is
	port (
		signal cs : in std_logic;
		signal oe : in std_logic;
		signal we : in std_logic;
		signal data_input : in std_logic_vector(31 downto 0);
		signal data_output : out std_logic_vector(31 downto 0);
		signal address : in std_logic_vector(31 downto 0)
	);
end component Data_Memory;
signal o,c,w : std_logic;
signal addr : std_logic_vector(31 downto 0);
signal din : std_logic_vector(31 downto 0);
begin
	mem_map : Data_Memory port map (cs => c, oe => o, we => w, data_input => din, address => addr);
	test_proc : process
	begin
		o <= 0;
		c <= 0;
		w <= 0;
		addr <= "00000000010000000000000000100000";
		din <=  "00000000000000000000000000000000";
		wait for 5 ns;
		wait;
	end process;
end architecture structure;