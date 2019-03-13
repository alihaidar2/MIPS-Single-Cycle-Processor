library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 2 inputs mux (8 bits)
-- this mux is generated once
-- * for writeData input

entity mux8x2 is
port(
		sel : in std_logic;
		a, b : in std_logic_vector(7 downto 0);
		z : out std_logic_vector(7 downto 0)
	);
end entity;

architecture muxBehave of mux8x2 is
	
component mux1x2 is	
port(
		sel : in std_logic;
		a, b : in std_logic;
		z : out std_logic
	);	
end component;	

begin
	
	generate8: for i in 0 to 7 generate
	
	mux_gen: mux1x2 port map(a => a(i), b => b(i), sel => sel, z => z(i));	
	end generate;
end architecture muxBehave;

-- Linking of components and top level entity
configuration conf_mux8x2 of mux8x2 is
	for muxBehave
		for all : mux1x2
			use entity work.mux1x2(muxBehave);
		end for;
	end for;
end conf_mux8x2;library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 2 inputs mux (8 bits)
-- this mux is generated once
-- * for writeData input

entity mux8x2 is
port(
		sel : in std_logic;
		a, b : in std_logic_vector(7 downto 0);
		z : out std_logic_vector(7 downto 0)
	);
end entity;

architecture muxBehave of mux8x2 is
	
component mux1x2 is	
port(
		sel : in std_logic;
		a, b : in std_logic;
		z : out std_logic
	);	
end component;	

begin
	
	generate8: for i in 0 to 7 generate
	
	mux_gen: mux1x2 port map(a => a(i), b => b(i), sel => sel, z => z(i));	
	end generate;
end architecture muxBehave;

-- Linking of components and top level entity
configuration conf_mux8x2 of mux8x2 is
	for muxBehave
		for all : mux1x2
			use entity work.mux1x2(muxBehave);
		end for;
	end for;
end conf_mux8x2;