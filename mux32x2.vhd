library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Two 32 bits input mux. Used 2 times for:
-- branch or jump selection
-- PC input
entity mux32x2 is
	port(
		sel : in std_logic;
		a, b : in std_logic_vector(31 downto 0);
		z : out std_logic_vector(31 downto 0)
	);
end entity mux32x2;

architecture muxBehave of mux32x2 is
	
begin
	z <= (not(sel) and (b)) or (sel and a);

end architecture muxBehave;
