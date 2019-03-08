library ieee;
use ieee.std_logic_1164.all;

entity dff is
	port(
		d, clk, rst: in std_logic;
		q: out std_logic);
		
end entity dff;

architecture dfflogic of dff is
	
component nandGate
	port(a, b: in std_logic;
		y: out std_logic
	);
	end component;

signal y0, y1, y2, y3: std_logic;
signal compD: std_logic;

begin
  compD<=not d;
	
	q <= not(rst) and y3;
	nand0: nandGate port map(d,clk, y0);
	nand1: nandGate port map(clk,compD,y1);
	nand2: nandGate port map(y1,y3,y2);
	nand3: nandGate port map(y1,y2,y3);

end architecture dfflogic;