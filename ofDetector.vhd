library ieee;
use ieee.std_logic_1164.all;

entity ofDetector is
	port (
		a, b : in std_logic;
		res, overflow : out std_logic
	);
end entity;

-- this component is gonna be the same as the subtractor except
-- the Cout is  gonna be an overflow bit that
-- is gonna be implemented in a different way

-- you will call this for the last bit of the small ALU

architecture sub of subtractor is

	signal sig0, sig1, sig2, sig3, sig4, b: std_logic;
	
begin
	
	b <= 1 xor bin; -- to invert the bits
	sig0 <= ain xor b;
	sig1 <= ain and bin;
	sig2 <= Cin xor sig0;
	sig3 <= Cin and sig0;
	sig4 <= sig1 or sig3;
	
	--outputs
	res <= sig2;
	Cout <= (not(ain) and not(b) and res) or (ain and b and not(res));

end sub;