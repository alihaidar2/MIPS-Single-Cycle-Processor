library ieee;
use ieee.std_logic_1164.all;

entity signExtend is
	port (
	seIn : in std_logic_vector(15 downto 0);
	seOut : out std_logic_vector(31 downto 0)
	);
end entity;