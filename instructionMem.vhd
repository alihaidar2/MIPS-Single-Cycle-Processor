library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instructionMem is
	port (
		pcAddIn : in std_logic_vector(31 downto 0);
		instructionOut: out std_logic_vector(31 downto 0)
	);
end entity;
