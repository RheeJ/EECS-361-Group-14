library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.mux_n;

entity reg32_tb is 
  port(
    busAd  : out std_logic_vector(31 downto 0);
    busBd  : out std_logic_vector(31 downto 0)
  );
end reg32_tb;

architecture structural of reg32_tb is
  component reg32 is
    port(
  clk : in std_logic;
  arst: in std_logic;
  aload : in std_logic;
  busw : in std_logic_vector(31 downto 0);
  regWr : in std_logic; -- write enable bit
  regDst : in std_logic; -- sel bit for rd/rt
  rs : in std_logic_vector(4 downto 0);
  rt : in std_logic_vector(4 downto 0);
  rd : in std_logic_vector(4 downto 0);
  busA : out std_logic_vector(31 downto 0);
  busB : out std_logic_vector(31 downto 0)
);
end component reg32;

signal Xbus : std_logic_vector(31 downto 0);
signal regW, regD : std_logic;
signal rs_in : std_logic_vector(4 downto 0);
signal rt_in : std_logic_vector(4 downto 0);
signal rd_in : std_logic_vector(4 downto 0);
signal clk_in , arst_in, aload_in : std_logic;
signal busAdS  :  std_logic_vector(31 downto 0);
signal busBdS  :  std_logic_vector(31 downto 0);

begin
  reg_map : reg32 port map
  (
            clk => clk_in,
            arst => arst_in,
            aload => aload_in,
            busW => Xbus,
            regWr => regW,
            regDst => regD,
            rs => rs_in,
            rt => rt_in,
            rd => rd_in,
            busA => busAd,
            busB => busBd
            );
            

test_proc : process
begin

clk_in <= '0';
arst_in <= '1';
aload_in <= '0';
Xbus <= "00000000000000000000000000000001";
regW <= '1';
regD <= '1';
rs_in <= "00001";
rt_in <= "00011";
rd_in <= "00011";
--busAdS <= "00000000000000001000000000000001";
--busBdS <= "00000000000000000000000100000001";
wait for 10 ns;
clk_in <= '1';
arst_in <= '0';
aload_in <= '0';
Xbus <= "00000000000000000100000000000011";
regW <= '1';
regD <= '0';
rs_in <= "00001";
rt_in <= "00001";
rd_in <= "00101";
--busAdS <= "00000000000000001000000000000001";
--busBdS <= "00000000000000000000000100000001";
wait for 10 ns;
clk_in <= '0';
wait for 5 ns;
clk_in <= '1';
arst_in <= '0';
aload_in <= '0';
Xbus <= "00000000000000000000000000000010";
regW <= '1';
regD <= '1';
rs_in <= "00001";
rt_in <= "00101";
rd_in <= "00111";
--busAdS <= "00000000000000001000000000000001";
--busBdS <= "00000000000000000000000100000001";
wait for 10 ns;
clk_in <= '0';
wait for 5 ns;
clk_in <= '1';
arst_in <= '0';
aload_in <= '0';
Xbus <= "00000000000000000000000000000010";
regW <= '0';
regD <= '0';
rs_in <= "00101";
rt_in <= "00111";
rd_in <= "00011";
--busAdS <= "00000000000000001000000000000001";
--busBdS <= "00000000000000000000000100000001";
wait;
end process;
end architecture structural;            

