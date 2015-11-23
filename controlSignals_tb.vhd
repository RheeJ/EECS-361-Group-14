library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.mux_n;

entity controlSignals_tb is 
  port(
    aluop  : out std_logic_vector(2 downto 0);
    regDst : out std_logic;
    aluSrc : out std_logic;
    memToReg : out std_logic;
    regWr : out std_logic;
    memRead : out std_logic;
    memWr : out std_logic;
    branch : out std_logic;
    ext_op : out std_logic
  );
end controlSignals_tb;

architecture structural of controlSignals_tb is
  component controlSignals is
    port (
    opcode : in std_logic_vector(5 downto 0);
    funct  : in std_logic_vector(5 downto 0);
    aluop  : out std_logic_vector(2 downto 0);
    regDst : out std_logic;
    aluSrc : out std_logic;
    memToReg : out std_logic;
    regWr : out std_logic;
    memRead : out std_logic;
    memWr : out std_logic;
    branch : out std_logic;
    ext_op : out std_logic
    );
 
end component controlSignals;

signal opcode,funct : std_logic_vector(5 downto 0);



begin
  reg_map : controlSignals port map
  (
    opcode => opcode,
    funct => funct,
    aluop => aluop,
    regDst => regDst,
    aluSrc => aluSrc,
    memToReg => memToReg,
    regWr => regWr,
    memRead => memRead,
    memWr => memWr,
    branch => branch,
    ext_op => ext_op
            );
            

test_proc : process
begin

opcode <= "001000";
funct <= "100001";

--busAdS <= "00000000000000001000000000000001";
--busBdS <= "00000000000000000000000100000001";
wait for 10 ns;
opcode <= "000000";
funct <= "100000";
--busAdS <= "00000000000000001000000000000001";
--busBdS <= "00000000000000000000000100000001";
wait for 10 ns;
opcode <= "001000";
funct <= "000000";
wait;
end process;
end architecture structural;            



