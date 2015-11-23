Library ieee;
USE ieee.std_logic_1164.all;

entity next_inst_tb is
end entity next_inst_tb;

architecture struct of next_inst_tb is

component next_inst is
port (
		clk, branch, zero, rst : in std_logic;
		imm16_in: in std_logic_vector(15 downto 0);
		opcode, func: out std_logic_vector(5 downto 0);
		Rs, Rt, Rd: out std_logic_vector(4 downto 0);
		imm16_out: out std_logic_vector(15 downto 0)
		);
end component;

signal Rs_tb, Rt_tb, Rd_tb: std_logic_vector(4 downto 0);
signal opcode_tb, func_tb: std_logic_vector(5 downto 0);
signal branch_tb, zero_tb, rst_tb: std_logic;
signal imm16_in_tb: std_logic_vector(15 downto 0);
signal imm16_out_tb: std_logic_vector(15 downto 0);

signal clk_tb : std_logic :='0';
constant clk_period : time := 5 ns;

begin
dut: next_inst
port map(
			clk => clk_tb,
			rst => rst_tb,
			branch => branch_tb,
			zero => zero_tb,
			imm16_in => imm16_in_tb,
			imm16_out => imm16_out_tb,
			Rs => Rs_tb,
			Rt => Rt_tb,
			Rd => Rd_tb,
			opcode => opcode_tb,
			func => func_tb
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
	clk_tb <= '1';
	wait for clk_period;
	clk_tb <= '0';
	wait for clk_period;
end process;

ctrl_stim: process
begin
  branch_tb <= '0';
  zero_tb <= '0';
  wait for 10 ns;
  branch_tb <= '1';
  zero_tb <= '1';
  wait for 5 ns;
  branch_tb <= '0';
  zero_tb <= '0';
  wait;
end process;

imm16_in_stim: process
begin
  imm16_in_tb <= "0000000000100000";
  wait;
end process imm16_in_stim;

end architecture struct;
