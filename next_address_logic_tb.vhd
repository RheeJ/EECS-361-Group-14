Library ieee;
USE ieee.std_logic_1164.all;

entity next_address_logic_tb is
end entity next_address_logic_tb;

architecture struct of next_address_logic_tb is

component next_address_logic is
port (
		clk, branch, zero, rst : in std_logic; 
		instruction : in std_logic_vector(15 downto 0);
		addr : out std_logic_vector(31 downto 0)
		);
end component;

signal branch_tb, zero_tb: std_logic;
signal instruction_tb: std_logic_vector(15 downto 0);
signal addr_tb: std_logic_vector(31 downto 0);
signal rst_tb: std_logic;
signal clk_tb : std_logic :='0';
constant clk_period : time := 1 ns;

begin
dut: next_address_logic
port map(
			clk => clk_tb,
			rst => rst_tb,
			branch => branch_tb,
			zero => zero_tb,
			instruction => instruction_tb,
			addr => addr_tb
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

ctrl_stim: process
begin
  branch_tb <= '1';
  zero_tb <= '1';
  wait for 10 ns;
  branch_tb <= '1';
  zero_tb <= '1';
  wait for 2 ns;
  branch_tb <= '1';
  zero_tb <= '1';
  wait for 2 ns;
  branch_tb <= '0';
  zero_tb <= '0';
  wait for 2 ns;
  branch_tb <= '0';
  zero_tb <= '0';
  wait;
end process;

instruction_stim: process
begin
  instruction_tb <= X"FFFC";
  wait;
end process instruction_stim;

end architecture struct;
