Library ieee;
USE ieee.std_logic_1164.all;

entity pc_tb is
end entity pc_tb;

architecture struct of pc_tb is

component pc is
port (
		clk : in std_logic; 
		rst : in std_logic;
		input : in std_logic_vector(31 downto 0); 
		output : out std_logic_vector(31 downto 0)
		);
end component;

signal input_tb, output_tb: std_logic_vector(31 downto 0);
signal rst_tb: std_logic;
signal clk_tb : std_logic :='0';
constant clk_period : time := 1 ns;

begin
dut: pc 
port map(
			clk => clk_tb,
			rst => rst_tb,
			input => input_tb,
			output => output_tb
			);
rst_stim: process
begin
rst_tb <= '1';
wait for clk_period;
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

pc_stim: process
begin 
input_tb <= "10001000100010001000100010001000";
wait for 10 ns;

input_tb <= "00010001000100010001000100010001";
wait;
end process;

end architecture struct;
