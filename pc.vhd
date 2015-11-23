Library ieee;
USE ieee.std_logic_1164.all;

entity pc is 
port (
		clk : in std_logic; 
		rst : in std_logic;
		input : in std_logic_vector(31 downto 0); 
		output : out std_logic_vector(31 downto 0)
		);
end pc;

architecture struct of pc is 

component dffr_a is
   port (
	clk	   : in  std_logic;
  arst   : in  std_logic;
  aload  : in  std_logic;
  adata  : in  std_logic;
	d	   : in  std_logic;
  enable : in  std_logic;
	q	   : out std_logic
  );
end component;
signal zero : std_logic_vector(31 downto 0);
signal output1 : std_logic_vector(31 downto 0);
begin
zero <= X"00400020";

pc_loop : for i in 0 to 31 generate
      dffr_a_map : dffr_a port map (
                          clk => clk,
                          arst => '0',
                          aload => rst,
                          adata => zero(i),
                          d => input(i),
                          enable => clk,
                          q => output1(i)
                      
                        );
   end generate pc_loop;

--output1 <= X"00400020" when rst ='1' else output1;

output <= output1;

--p_c: dffr_32bit_PC port map(clk=>clk, 
--		     d=>input, 
--		     q=>output, 
--		     arst=>rst, 
--		     aload=>'0', 
--		    adata=>zero,
--		   enable=>clk);
--counter: for i in 0 to 29 generate begin
	--p_c: dffr_a port map(clk=>clk, d=>input(i), q=>output(i), arst=>rst, aload=>'0', adata=>'0',enable=>clk);
--end generate counter;
end architecture struct;