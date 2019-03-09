library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity nandGate is	
	port(a, b : in std_logic;
		y: out std_logic);		
end nandGate;

architecture nandBehave of nandGate is
begin	
	y <= not (a and b);	
end nandBehave;

