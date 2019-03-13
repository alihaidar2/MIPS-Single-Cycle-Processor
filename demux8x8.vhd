library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Eight 8bits output demux
--Demux used inside the register file.
--Will drive the data to be written in the selected reg.

entity demux8x8 is
	port(sel :in std_logic_vector(2 downto 0);
		dataWrite: in std_logic_vector(7 downto 0);
		r0, r1, r2, r3, r4, r5, r6, r7 : out std_logic_vector(7 downto 0));
		
end entity demux8x8;

architecture RTL of demux8x8 is
	
component demux1x8 is
	port(sel : in std_logic_vector(2 downto 0);
		dataWrite: in std_logic;
		r0, r1, r2, r3, r4, r5, r6, r7 : out std_logic);
		
end component;
	
begin
	
generate32: for i in 0 to 31 generate
	
	mux_gen: demux1x8 port map(dataWrite => dataWrite(i), r0 => r0(i), r1 => r1(i), r2 => r2(i), 
					r3 => r3(i), r4 => r4(i), r5 => r5(i),
					 r6 => r6(i), r7 => r7(i), sel => sel);	
	end generate;

end architecture RTL;

-- Linking of components and top level entity
configuration conf_demux8x8 of demux8x8 is
	for RTL
		for all : demux1x8
			use entity work.demux1x8(RTL);
		end for;
	end for;
end conf_demux8x8;
