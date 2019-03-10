library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- this mux is generated once, for Write Register input

entity mux5 is
port (
	in0, in1: in std_logic_vector(4 downto 0);
	muxOut : out std_logic_vector(4 downto 0);
	ctlMux : in std_logic
	);
end entity;
	