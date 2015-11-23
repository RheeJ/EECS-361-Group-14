library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity instruction_decoder is
  port (
    x      : in  std_logic_vector (31 downto 0);
	opcode : out std_logic_vector ( 5 downto 0);
	rs     : out std_logic_vector ( 4 downto 0);
	rt     : out std_logic_vector ( 4 downto 0);
	rd     : out std_logic_vector ( 4 downto 0);
	shamt  : out std_logic_vector ( 4 downto 0);
	funct  : out std_logic_vector ( 5 downto 0);
	addr   : out std_logic_vector (15 downto 0)
  );
end instruction_decoder;

architecture structural of instruction_decoder is

begin
  opcode <= x(31 downto 26);
  rs     <= x(25 downto 21);
  rt     <= x(20 downto 16);
  rd     <= x(15 downto 11);
  shamt  <= x(10 downto  6);
  funct  <= x( 5 downto  0);
  addr   <= x(15 downto  0);

end structural;
