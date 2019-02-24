library ieee;
use ieee.std_logic_1164.all;

entity regFile is
port (

	readReg1, readReg2, writeReg : in std_logic_vector(4 downto 0);
	writeData : in std_logic_vector(7 downto 0);
	readData1, readData2 : out std_logic_vector(7 downto 0);
	
	-- control signal
	regWrite : in std_logic
	
);
end entity;
	

	