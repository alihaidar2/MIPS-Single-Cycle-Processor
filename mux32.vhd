library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

-- Four 32 bits inputs mux used in the main ALU for operation selection
entity mux32x4 is
	port(
		sel :in std_logic_vector(1 downto 0); 
		logicAND, logicOR, add_sub, SLT: in std_logic_vector(31 downto 0);
		z: out std_logic_vector(31 downto 0)
	);
end entity mux32x4;

architecture muxBehave of mux32x4 is
	
begin
	z <= ( (not sel(1) and not sel(0) and logicAND) or (not sel(1) and sel(0) and logicOR) or
		(sel(1) and sel(0) and add_sub) or (sel(1) and sel(0) and SLT) );

end architecture muxBehave;
