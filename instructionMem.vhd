library ieee;
use iee.std_logic_1164.all;

entity instructionMem is
	port (
		pcAddIn : in std_logic_vector(7 downto 0);
		instructionOut: out std_logic_vector(31 downto 0)
	);
end entity;