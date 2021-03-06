library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--8 inputs mux (8 bits)
--Mux used inside the Register file.
--selects which register to read from. 
--Will be generated two times for the 2 read outputs.

entity mux8x8 is
	
	port(r0, r1, r2, r3, r4, r5, r6, r7 : in std_logic_vector(7 downto 0);
		sel :in std_logic_vector(2 downto 0);
		dataRead: out std_logic_vector(7 downto 0));
		
end entity mux8x8;

architecture muxBehave of mux8x8 is
	
component mux1x8 is	
port(in0, in1, in2, in3, in4, in5, in6, in7 : in std_logic;
		sel :in std_logic_vector(2 downto 0);
		muxOut: out std_logic);		
end component;	

begin
	
	generate8: for i in 0 to 7 generate
	
	mux_gen: mux1x8 port map(in0 => r0(i), in1 => r1(i), in2 => r2(i), 
					in3 => r3(i), in4 => r4(i), in5 => r5(i),
					 in6 => r6(i), in7 => r7(i), sel => sel, muxOut => dataRead(i));	
	end generate;	
end muxBehave;

-- Linking of components and top level entity
configuration conf_mux8x8 of mux8x8 is
	for muxBehave
		for all : mux1x8
			use entity work.mux1x8(muxBehave);
		end for;
	end for;
end conf_mux8x8;