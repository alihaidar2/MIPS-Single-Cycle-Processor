library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;

-- 32 bits adder for address computation

entity adder32 is
port (
	CarryIn, aluIn1, aluIn2 : in std_logic_vector(31 downto 0);
	aluOut : out std_logic_vector(31 downto 0);
	carryOut : out std_logic
);
end entity;
	
architecture alu32Arch of adder32 is
	
	component adder 
	PORT ( Cin, x, y : IN STD_LOGIC ;
			s, Cout : OUT STD_LOGIC );
	end component;
	
	signal carry: std_logic_vector(30 downto 0);
		
begin
	
	outerloop: for i in 0 to 31 generate
		
		innerloop1: if (i = 0) generate
			add0: adder port map(x => aluIn1(i), y => aluIn2(i), Cin => '0', Cout => carry(i+1), s =>aluOut(i));
		end generate innerloop1;
		
		innerloop2: if (i>0 and i<31) generate 
				add: adder port map(x => aluIn1(i), y => aluIn2(i), Cin => carry(i), Cout => carry(i+1), s =>aluOut(i));
		end generate innerloop2;
		
		innerloop3: if (i=31) generate
			add31: adder port map (x => aluIn1(i), y => aluIn2(i), Cin => carry(i), Cout => carryOut, s =>aluOut(i));
		end generate innerloop3;
		
	end generate outerloop;

end architecture;

	