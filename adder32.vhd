library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

-- 32 bits adder for address computation

entity adder32 is
	
generic(g_carry_in : std_logic := '0');	
port (
	CarryIn : in std_logic := g_carry_in;
	aluIn1, aluIn2 : in std_logic_vector(31 downto 0);
	aluOut : out std_logic_vector(31 downto 0);
	carryOut : out std_logic
);
end entity;
	
architecture adder32behave of adder32 is

--components used	
component adder 
	PORT ( Cin, x, y : IN STD_LOGIC ;
			s, Cout : OUT STD_LOGIC );
end component;
	
	signal carry: std_logic_vector(30 downto 0);

--Architecture	
begin

	outerloop: for i in 0 to 31 generate
		
		innerloop1: if (i = 0) generate
			add0: adder port map(x => aluIn1(i), y => aluIn2(i), Cin => CarryIn, Cout => carry(i), s =>aluOut(i));
		end generate innerloop1;
		
		innerloop2: if (i>0 and i<31) generate 
				add: adder port map(x => aluIn1(i), y => aluIn2(i), Cin => carry(i-1), Cout => carry(i), s =>aluOut(i));
		end generate innerloop2;
		
		innerloop3: if (i=31) generate
			add31: adder port map (x => aluIn1(i), y => aluIn2(i), Cin => carry(i-1), Cout => carryOut, s =>aluOut(i));
		end generate innerloop3;
		
	end generate outerloop;
	
end architecture;

-- Linking of components and top level entity
configuration basic_level of adder32 is
	for adder32behave
		for all : adder
			use entity work.adder(addArch);
		end for;
	end for;
end basic_level;
	