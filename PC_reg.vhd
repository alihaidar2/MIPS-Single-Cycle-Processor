library ieee;
use ieee.std_logic_1164.all;

-- PC register

entity PCreg is 
port(
  clk    : in STD_LOGIC;
  rst    : in STD_LOGIC;
  PC_in  : in STD_LOGIC_VECTOR (31 downto 0);
  PC_out : out STD_LOGIC_VECTOR (31 downto 0));
end PCreg;

architecture reg of PCreg is

--components used
component d_latch is
   port(d, clk, rst: in std_logic; q: out std_logic);
end component;

--Behavior 
begin
iFF : for i in 0 to 31 generate
FF : d_latch port map (d => PC_in(i), clk => clk, rst => rst, q => PC_out(i));
end generate iFF;

end architecture reg;

-- Linking of components and top level entity
configuration basic_level of PCreg is
	for reg
		for all : d_latch
			use entity work.d_latch(basic);
		end for;
	end for;
end basic_level;