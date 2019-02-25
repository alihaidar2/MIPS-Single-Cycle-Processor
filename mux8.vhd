library ieee;
use ieee.std_logic_1164.all;

-- this mux is generated 2 times:
-- * for main ALU input2
-- * for writeData input

entity mux8 is
port(
	in0, in1 : in std_logic_vector(7 downto 0);
	muxOut : out std_logic_vector(7 downto 0)
	);
end entity;