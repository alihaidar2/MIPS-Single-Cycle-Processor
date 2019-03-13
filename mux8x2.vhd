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
	
begin
	z <= (not(sel) and (b)) or (sel and a);

end architecture muxBehave;