library ieee;
use ieee.std_logic_1164.all;
entity PCreg is 
port(
  clk    : in STD_LOGIC;
  rst    : in STD_LOGIC;
  PC_in  : in STD_LOGIC_VECTOR (31 downto 0);
  PC_out : out STD_LOGIC_VECTOR (31 downto 0));
end PCreg;

architecture reg of PCreg is

component dFF
	port(
		d, clk, rst: in std_logic;
		q: out std_logic);
end component;
begin
iFF : for i in 0 to 31 generate
FF : dFF port map (clk,rst,PC_in(i),PC_out(i));
end generate iFF;
end architecture reg;
