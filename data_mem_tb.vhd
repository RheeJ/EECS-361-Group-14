Library ieee;
USE ieee.std_logic_1164.all;

entity data_mem_tb is
end data_mem_tb;

architecture struct of data_mem_tb is

component data_mem is
port (
	  clk : in std_logic;
	--	cs : in std_logic;
	   we : in std_logic;
		oe : in std_logic;		
		data_input : in std_logic_vector(31 downto 0);
		address : in std_logic_vector(31 downto 0);
		data_output : out std_logic_vector(31 downto 0)
	);

end component;

signal clk_in, MemWr_in, output_en_in: std_logic;
signal data, addr, data_o: std_logic_vector(31 downto 0);

begin 
dut: data_mem
port map(clk_in,MemWr_in, output_en_in, data, addr, data_o);
stim_datamem: process
begin
clk_in <= '0';
MemWr_in <= '0';
output_en_in <= '1';
data <= X"00000000";
addr <= X"10000000";
wait for 2 ns;
clk_in <= '1';
wait for 2 ns;
end process stim_datamem;
end architecture struct;

