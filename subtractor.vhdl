-- 1 BIT SUBTRACTOR
-- this component will subtract one
-- of the 7 bits of the exponent

library ieee;
use ieee.std_logic_1164.all;

entity subtractor is
	port (
		ain, bin, Cin : in std_logic;
		res, Cout : out std_logic
	);
end entity;

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
	Cout <= sig4;

end sub;
	