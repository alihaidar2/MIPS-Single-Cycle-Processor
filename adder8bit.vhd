

-- need to add clock and resets

library ieee;
use ieee.std_logic_1164.all;

entity adder8bit is 
port (
	aluIn1, aluIn2 : in std_logic_vector(7 downto 0);
	aluOut : out std_logic_vector(6 downto 0)
	cOut : out std_logic
	-- control, clk, rst : in std_logic
	);
end entity;


architecture archAdder8bit of adder8bit is
	
	component adder 
	port (
		ain, bin, Cin : in std_logic;
		res, Cout : out std_logic
	);
	end component;
	
	signal sigLink : std_logic_vector(6 downto 0);
	
begin
	
	outerloop: for i in 0 to 7 generate
		
		innerloop1: if (i = 0) generate
			add: adder port map(ain <= aluIn1(i), aluIn2(i), 1, aluOut(i), sigLink(0));
		end generate innerloop1;
		
		innerloop2: if (i=1|i=2|i=3|i=4|i=5|i=6) generate 
				add: adder port map(aluIn1(i), aluIn2(i), sigLink(i-1), aluOut(i), sigLink(i+1));
		end generate innerloop2;
		
		innerloop3: if (i=7) generate
			ofD: adder port map (aluIn1(i), aluIn2(i), sigLink(i-1), aluOut(i), carryOut);
		end generate innerloop3;
		
	end generate outerloop;
	
end architecture;
	
		

