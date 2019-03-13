library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instructionMem is
	port (
		pcAddIn : in std_logic_vector(31 downto 0);
		instructionOut: out std_logic_vector(31 downto 0)
	);
end entity;
architecture behave of instructionMem is
signal ram_addr: std_logic_vector(31 downto 0);
type mem_Ins is array(0 to 255) of std_logic_vector(31 downto 0);
        signal ramIns : mem_Ins;
        attribute ramIns_init_file : string;
        attribute ramIns_init_file of ramIns : signal is "InstructionMem.mif";
begin
ram_addr<=pcAddIn;
instructionOut<=ramIns(to_integer(unsigned(ram_addr)));
end architecture behave;
