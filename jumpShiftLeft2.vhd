-- dont actually need shifting hardware, all you do is add
-- 00 to the least significant side (Figure 4.9 textbook p.256)

-- This shift component is used for the Jump operation

library ieee; 
use ieee.std_logic_1164.all;

entity jumpShiftLeft2 is
	-- im thinking this one adds the 00 to LSB
	-- and extends the size and the 
	-- branch one doesnt, but discards 2 MSB
port (
	slIn : in std_logic_vector(25 downto 0);
	slOut : out std_logic_vector(27 downto 0) 
);
end entity;

	