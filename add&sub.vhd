library ieee;
use ieee.std_logic_1164.all;

-- 1 bit Full adder/substractor. Integrated in the main ALU. Generated 32 times
-- X - Y = X + (-Y) = X + ~Y + 1
-- For sub, set the initial carry-in to 1 instead of 0, thus adding an extra 1 to the sum
-- And instead of using NOT gates, we will use XOR gates.

entity add_sub is
	PORT ( Cin, x, y : IN STD_LOGIC ;
			s, Cout : OUT STD_LOGIC );
end entity;

architecture behave of add_sub is
	signal op: std_logic;
begin	
	op <= Cin xor y;
	s <= (x XOR op) XOR Cin;
	Cout <= (x AND op) OR (Cin AND (x xor op));
end architecture;
