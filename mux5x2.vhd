library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 8 inputs mux (5 bits). 
-- Generated once, for Write Register input

entity mux5x2 is
port (
		sel : in std_logic;
		a, b : in std_logic_vector(4 downto 0);
		z : out std_logic_vector(4 downto 0)
	);
end entity;

architecture muxBehave of mux5x2 is

component mux1x2 is	
port(
		sel : in std_logic;
		a, b : in std_logic;
		z : out std_logic
	);	
end component;	
begin
	
	generate8: for i in 0 to 4 generate
	
	mux_gen: mux1x2 port map(a => a(i), b => b(i), sel => sel, z => z(i));	
	end generate;
end architecture muxBehave;

-- Linking of components and top level entity
configuration conf_mux5x2 of mux5x2 is
	for muxBehave
		for all : mux1x2
			use entity work.mux1x2(muxBehave);
		end for;
	end for;
end conf_mux5x2;

	