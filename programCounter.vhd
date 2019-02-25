library ieee;
use ieee.std_logic_1164.all;

entity programCounter is
	port (
		pcIn : in std_logic_vector(31 downto 0);
		pcOut : out std_logic_vector(31 downto 0)
	);
end entity;



		