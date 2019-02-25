-- this ALU is used for 
-- * Branch Target Address
-- * PC incrementor

library ieee;
use ieee.std_logic_1164.all;

entity ALU32 is
port (
	aluIn1, aluIn2 : in std_logic_vector(31 downto 0);
	aluOut : out std_logic_vector(31 downto 0)
	);
end entity;
	