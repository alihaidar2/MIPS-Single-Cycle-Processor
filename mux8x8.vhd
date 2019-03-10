library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Eight 8 bits input mux
--Mux used inside the Register file.
--selects which register to read from. 
--Will be generated two times for the 2 read outputs.

entity mux8x8 is
	
	port(r0, r1, r2, r3, r4, r5, r6, r7 : in std_logic_vector(7 downto 0);
		sel :in stdl_logic_vector(2 downto 0);
		dataRead: out std_logic_vector(7 downto 0));
		
end entity mux8x8;

architecture muxBehave of mux8x8 is
begin
	dataRead <= ( (r0 and not sel(2) and not sel(1) and not sel(0)) or 
	(r1 and not sel(2) and not sel(1) and sel(0)) or
	(r2 and not sel(2) and sel(1) and not sel(0)) or
	(r3 and not sel(2) and sel(1) and sel(0)) or
	(r4 and sel(2) and not sel(1) and not sel(0)) or
	(r5 and sel(2) and not sel(1) and sel(0)) or
	(r6 and sel(2) and sel(1) and not sel(0)) or
	(r7 and sel(2) and sel(1) and sel(0)) );
	
end muxBehave;
