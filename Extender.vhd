
Library ieee;
USE ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity Extender is
port (
		imm16_in_ex : in std_logic_vector(15 downto 0);
		imm16_out_ex : out std_logic_vector(31 downto 0)
		);
end Extender;

architecture struct of Extender is

signal and_out: std_logic;

begin

ext: and_gate port map(x=>imm16_in_ex(15), y=>'0', z=>and_out);
imm16_out_ex(15 downto 0) <= imm16_in_ex(15 downto 0);
imm16_out_ex(31)<= and_out;
imm16_out_ex(30)<= and_out;
imm16_out_ex(29)<= and_out;
imm16_out_ex(28)<= and_out;
imm16_out_ex(27)<= and_out;
imm16_out_ex(26)<= and_out;
imm16_out_ex(25)<= and_out;
imm16_out_ex(24)<= and_out;
imm16_out_ex(23)<= and_out;
imm16_out_ex(22)<= and_out;
imm16_out_ex(21)<= and_out;
imm16_out_ex(20)<= and_out;
imm16_out_ex(19)<= and_out;
imm16_out_ex(18)<= and_out;
imm16_out_ex(17)<= and_out;
imm16_out_ex(16)<= and_out;

end architecture struct;
