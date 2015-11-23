Library ieee;
USE ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity sign_ext is
port (
		imm16 : in std_logic_vector(15 downto 0);
		output : out std_logic_vector(31 downto 0)
		);
end sign_ext;

architecture struct of sign_ext is

signal and_out: std_logic;

begin

ext: and_gate port map(x=>imm16(15), y=>'1', z=>and_out);
output(15 downto 0) <= imm16(15 downto 0);
output(31)<= and_out;
output(30)<= and_out;
output(29)<= and_out;
output(28)<= and_out;
output(27)<= and_out;
output(26)<= and_out;
output(25)<= and_out;
output(24)<= and_out;
output(23)<= and_out;
output(22)<= and_out;
output(21)<= and_out;
output(20)<= and_out;
output(19)<= and_out;
output(18)<= and_out;
output(17)<= and_out;
output(16)<= and_out;

end architecture struct;
