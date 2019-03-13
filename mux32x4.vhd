library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

-- 4 inputs mux (32 bits)
-- Used in the main ALU for operation selection
entity mux32x4 is
	port(
		sel :in std_logic_vector(1 downto 0); 
		logicAND, logicOR, add_sub, SLT: in std_logic_vector(31 downto 0);
		z: out std_logic_vector(31 downto 0)
	);
end entity mux32x4;

architecture muxBehave of mux32x4 is
	
component mux1x4 is	
	port(
		sel :in std_logic_vector(1 downto 0); 
		logicAND, logicOR, add_sub, SLT: in std_logic;
		z: out std_logic
	);	
end component;	

begin
	
	generate32: for i in 0 to 31 generate
	
	mux_gen: mux1x4 port map(logicAND => logicAND(i), logicOR => logicOR(i), add_sub => add_sub(i), 
		SLT => SLT(i), sel => sel, z => z(i)
	);	
	end generate;
end architecture muxBehave;

-- Linking of components and top level entity
configuration conf_mux32x4 of mux32x4 is
	for muxBehave
		for all : mux1x4
			use entity work.mux1x4(muxBehave);
		end for;
	end for;
end conf_mux32x4;

