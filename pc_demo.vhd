library ieee;
use ieee.std_logic_1164.all;

entity pc_demo is
  port (
    dout : out std_logic_vector (31 downto 0));
end pc_demo;

architecture structural of pc_demo is

component pc is
  port (
    pc_out   : out std_logic_vector (31 downto 0);  -- output instruction of pc
	pre_out  : in  std_logic_vector (31 downto 0);  -- previous instruction address
  c_branch : in  std_logic_vector (15 downto 0);  -- conditional branch result
	adata    : in  std_logic_vector (31 downto 0);  -- initial load address
	aload    : in  std_logic_vector (31 downto 0);  -- control of initial load address
	clk      : in  std_logic;                       -- clock cycle
	reset    : in  std_logic;                       -- control of reset
  mux      : in  std_logic                        -- (0)--choose next address, (1)--choose load
  );
end component pc;

signal pre_out  : std_logic_vector (31 downto 0)
                := (3=>'1', 4=>'1', 6=>'1',23=>'1', others=>'0');
signal c_branch : std_logic_vector (15 downto 0)
                := (3=>'1', 4=>'1', 5=>'1', 6=>'1', others=>'0');
signal adata    : std_logic_vector (31 downto 0)
                := (others=>'0');
signal aload    : std_logic_vector (31 downto 0)
                := (others=>'0');
signal clk      : std_logic;
signal reset    : std_logic := '0';
signal mux      : std_logic := '0';

begin
  pc_map : pc port map
         (dout, pre_out, c_branch, adata, aload, clk, reset, mux);
  
  test_proc : process
  begin
    clk <= '1';
	wait for 5 ns;
	clk <= '0';
	wait for 5 ns;
	clk <= '1';
	wait for 5 ns;
	clk <= '0';
	wait for 5 ns;
	mux <= '1';
	clk <= '1';
	wait for 5 ns;
	clk <= '0';
	wait for 5 ns;
	clk <= '1';
	wait for 5 ns;
	clk <= '0';
	wait for 5 ns;
	wait;
  end process;
end architecture structural;

