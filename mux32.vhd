library ieee;
use ieee.std_logic_1164.all;

-- this multiplexor will be generated 2 times:
-- * PC next value (jump vs branch)
-- * 2nd input of that ^ multiplexor

entity mux32 is
port (
	in0, in1 : in std_logic_vector(31 downto 0);
	muxOut : out std_logic_vector(31 downto 0);
	ctlMux : in std_logic
	);
end entity
	