library ieee;
use ieee,std_logic_1164.all;

entity aluCtrl is
port (
	-- not sure about these lengths
	aluOpIn : in std_logic_vector(2 downto 0);
	aluOpOut : out std_logic_vector(2 downto 0)
);
end entity;