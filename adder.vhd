-- this component will add 2 bits
-- 1 BIT ADDER

library ieee;
use ieee.std_logic_1164.all;

entity adder is
	port (
		ain, bin, Cin : in std_logic;
		res, Cout : out std_logic
	);
end entity;

architecture addArch of adder is
	
	signal sig0, sig1, sig2: std_logic;
	
begin
	
	-- internal logic
	sig0 <= ain xor bin;
	sig1 <= sig0 and cin;
	sig2 <= ain and bin;

	-- output logic
	res <= sig0 xor cin;
	cout <= sig1 or sig2;
	
end addArch;

	