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
	
begin
	z <= (not(sel) and (b)) or (sel and a);

end architecture muxBehave;
	