library ieee;
use ieee.std_logic_1164.all;

entity ALU is
port (
	aluIn1, aluIn2 : in std_logic_vector(7 downto 0);
	aluOut : out std_logic_vector(7 downto 0);
	
	-- control signal
	aluOP : in std_logic_vector(2 downto 0)
);
end entity;
	