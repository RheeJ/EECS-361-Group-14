library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity pc is
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
end pc;

architecture structural of pc is

signal shift   : std_logic_vector (31 downto 0);  -- 4*c_branch, shifted address
signal extend  : std_logic_vector (31 downto 0);  -- extend 32bit from 16bit branch address
signal reg_dec : std_logic_vector (31 downto 0);  -- regular decision, pre_out + 4
signal four    : std_logic_vector (31 downto 0)
               := (3=>'1', others=>'0');          -- 4 (32bit)
signal dec     : std_logic_vector (31 downto 0);
signal add_out : std_logic_vector (31 downto 0);

begin
-- 16bit to 32bit extension
  low_order_extend : for i in 0 to 15 generate
    extend(i) <= c_branch(i);
  end generate low_order_extend;
  high_order_extend : for i in 0 to 15 generate
    extend(i) <= c_branch(15);
  end generate high_order_extend;

-- shift 2bit left
  shift_2_bits : for i in 0 to 15 generate
    shift(i+2) <= extend(i);
  end generate shift_2_bits;
  shift(1 downto 0) <= "00";

-- regular decision = previous address + 4
  reg_dec <= pre_out + four;
-- control of addression
-- (0)--choose next address, (1)--choose load
  process(mux)
  begin
    case mux is
      when '0' => dec<=reg_dec;
      when '1' => dec<=reg_dec + shift;
      when others => dec<=(others=>'0');
    end case;
  end process;

-- make sure it is a address (which%4 == 0)
  add_out <= dec(31 downto 2) & "00";
  
-- inside of PC
-- when reset == 1, return all output to '0' (reset)
   -- when aload == 1, return adata (initialize or manaully set)
     -- when clock(rising) & enable, return input address
  ff_gen:
  for i in 0 to 31 generate
    diffint_map : dffr_a port map
				  (clk, reset, aload(i), adata(i), add_out(i), '1', pc_out(i));
  end generate ff_gen;
  
end structural;