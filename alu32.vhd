-- this ALU is used for 
-- * Branch Target Address
-- * PC incrementor

library ieee;
use ieee.std_logic_1164.all;

entity ALU32 is
port (
	aluIn1, aluIn2 : in std_logic_vector(31 downto 0);
	aluOut : out std_logic_vector(31 downto 0);
	carryOut : out std_logic
);
end entity;

	
architecture alu32Arch of ALU32 is
	
	-- signals and components
	component adder 
	port (
		ain, bin, Cin : in std_logic;
		res, Cout : out std_logic
	);
	end component;
	
	-- didnt use OFDetector component, just a regular adder
	-- might need to make it an OF detector

	signal sigLink : std_logic_vector(30 downto 0);
	
begin
	
	outerloop: for i in 0 to 31 generate
		
		innerloop1: if (i = 0) generate
			add: adder port map(aluIn1(i), aluIn2(i), 0, aluOut(i), sigLink(0));
		end generate innerloop1;
		
		innerloop2: if (i=1|i=2|i=3|i=4|i=5|i=6|i=7|i=8|i=9|i=10|i=11|
						i=12|i=13|i=14|i=15|i=16|i=17|i=18|i=19|i=20|
						i=21|i=22|i=23|i=24|i=25|i=26|i=27|i=28|i=29|i=30) generate 
				add: adder port map(aluIn1(i), aluIn2(i), sigLink(i-1), aluOut(i), sigLink(i+1));
		end generate innerloop2;
		
		innerloop3: if (i=31) generate
			ofD: adder port map (aluIn1(i), aluIn2(i), sigLink(i-1), aluOut(i), carryOut);
		end generate innerloop3;
		
	end generate outerloop;

end alu32Arch;

	