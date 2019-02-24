library ieee;
use ieee.std_logic_1164.all;

entity dataMem is
	port (
		addressIn : in std_logic_vector(7 downto 0); 
		writeDataIn : in std_logic_vector(7 downto 0);
		readDataOut : out std_logic_vector(7 downto 0);
		
		-- control signals
		memRead, memWrite : out std_logic
	);
end entity;
	