library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 8 bits register used in the register file.

library work;
use work.all;

entity reg8bits is
	port(
		clk, load : in std_logic;
		din: in std_logic_vector(7 downto 0);
		dout: out std_logic_vector(7 downto 0));
		
end entity reg8bits;

architecture regbehave of reg8bits is

--components used
component d_latch is
   port(d, clk, rst: in std_logic; q: out std_logic);
end component;

component and2 is
	port (clk, load: in std_logic; y: out std_logic);
end component;

    signal int_clk : std_logic;
    signal zero : std_logic := '0';
--Architecture  
begin
	
	gate: and2 port map(clk => clk, load =>load, y => int_clk);
		
	oneloop: for i in 0 to 7 generate
		
		bits: d_latch port map(d => din(i), clk => int_clk, rst => zero, q => dout(i));
		
	end generate oneloop;

end architecture regbehave;

-- Linking of components and top level entity
configuration basic_level of reg8bits is
	for regbehave
		for all : d_latch
			use entity work.d_latch(basic);
		end for;
		for all : and2
			use entity work.and2(basic);
		end for;
	end for;
end basic_level;


