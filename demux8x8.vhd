library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Demux used inside the register file.
--Will drive the data to be written in the selected reg.

entity demux8x8 is
	port(sel :in stdl_logic_vector(2 downto 0);
		dataWrite: int std_logic_vector(7 downto 0);
		r0, r1, r2, r3, r4, r5, r6, r7 : out std_logic_vector(7 downto 0));
		
end entity demux8x8;

architecture RTL of demux8x8 is
	
begin
	
	r0 <= (dataWrite and not sel(2) and not sel(1) and not sel(0));
	r1 <= (dataWrite and not sel(2) and not sel(1) and sel(0));
	r2 <= (dataWrite and not sel(2) and sel(1) and not sel(0));
	r3 <= (dataWrite and not sel(2) and sel(1) and sel(0));
	r4 <= (dataWrite and sel(2) and not sel(1) and not sel(0));
	r5 <= (datawrite and sel(2) and not sel(1) and sel(0));
	r6 <= (datawrite and sel(2) and sel(1) and not sel(0));
	r7 <= (dataWrite and sel(2) and sel(1) and sel(0));

end architecture RTL;
