library ieee;
use ieee.std_logic_1164.all;

--Sign extend from 8 bits to 32
entity signExtend8 is
	port (
	seIn : in std_logic_vector(7 downto 0);
	seOut : out std_logic_vector(31 downto 0)
	);
end entity;

architecture behave of signExtend8 is
begin

seOut(31 downto 8) <=(others=>seIn(7));
seOut(7 downto 0) <= seIn;

end architecture;
