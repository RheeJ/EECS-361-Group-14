library ieee;
use work.eecs361_gates.all;
use work.eecs361.all;
use ieee.std_logic_1164.all;

entity ALU is
	port (
		x : in std_logic_vector(31 downto 0);
		y : in std_logic_vector(31 downto 0);
		z : out std_logic_vector(31 downto 0);

		control : in std_logic_vector(4 downto 0);
		cin : in std_logic;
		
		cout : out std_logic;
		overflow : out std_logic;
		zero : out std_logic

	);
end ALU;

architecture Structure of ALU is
signal add_IMM, add_REG : std_logic_vector(31 downto 0);
signal beq, bne, beqbne, bgtz, slt, sltu : std_logic_vector(31 downto 0);
signal and32,or32 : std_logic_vector(31 downto 0);
signal s_add,s_sub,u_add,u_sub : std_logic_vector(31 downto 0);
signal b_condi, s_condi : std_logic_vector(31 downto 0);
signal loadw, storew : std_logic_vector(31 downto 0);
signal andor, l_shift : std_logic_vector(31 downto 0);
signal u_arith, s_arith : std_logic_vector(31 downto 0);
signal arithmetic : std_logic_vector(31 downto 0);
signal logical : std_logic_vector(31 downto 0);
signal dataflow : std_logic_vector(31 downto 0);
signal conditional : std_logic_vector(31 downto 0);
signal arithlogic : std_logic_vector(31 downto 0);
signal datacondi : std_logic_vector(31 downto 0);
begin
	branch1100_map : mux_32 port map (sel => control(0), src0 => beq, src1 => bne, z => beqbne);
	branch0010_map : mux_32 port map (sel => control(0), src0 => add_IMM, src1 => add_REG, z=> s_add);

	branch111_map : mux_32 port map (sel => control(1), src0 => slt, src1 => sltu, z => s_condi);
	branch110_map : mux_32 port map (sel => control(1), src0 => beqbne, src1 => bgtz, z => b_condi);
	branch010_map : mux_32 port map (sel => control(1), src0 => and32, src1 => or32, z => andor);
	branch001_map : mux_32 port map (sel => control(1), src0 => s_add, src1 => s_sub, z => s_arith);
	branch000_map : mux_32 port map (sel => control(1), src0 => u_add, src1 => u_sub, z => u_arith);

	branch11_map : mux_32 port map (sel => control(2), src0 => b_condi, src1 => s_condi, z => conditional);
	branch10_map : mux_32 port map (sel => control(2), src0 => loadw, src1 => storew, z => dataflow);
	branch01_map : mux_32 port map (sel => control(2), src0 => andor, src1 => l_shift, z => logical);
	branch00_map : mux_32 port map (sel => control(2), src0 => u_arith, src1 => s_arith, z => arithmetic); 

	branch1_map : mux_32 port map (sel => control(3), src0 => dataflow, src1 => conditional, z => datacondi);
	branch0_map : mux_32 port map (sel => control(3), src0 => arithmetic, src1 => logical, z => arithlogic);

	branch_map : mux_32 port map (sel => control(4), src0 => arithlogic, src1 => datacondi, z => z);
end Structure;