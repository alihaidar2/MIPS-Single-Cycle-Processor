library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;

entity regFile is
port (

	readReg1, readReg2, writeReg : in std_logic_vector(4 downto 0);
	clk, writeCtl: in std_logic;
	writeData : in std_logic_vector(7 downto 0);
	readData1, readData2 : out std_logic_vector(7 downto 0)	
);
end entity;
	
architecture regFilebehave of regFile is
	
component reg8bits is
	port(
		clk, load : in std_logic;
		din: in std_logic_vector(7 downto 0);
		dout: out std_logic_vector(7 downto 0));
end component;

component mux8x8 is
	port(r0, r1, r2, r3, r4, r5, r6, r7 : in std_logic_vector(7 downto 0);
		sel :in stdl_logic_vector(2 downto 0);
		dataRead: out std_logic_vector(7 downto 0));
end component;

component demux8x8 is
	port(sel :in stdl_logic_vector(2 downto 0);
		dataWrite: int std_logic_vector(7 downto 0);
		r0, r1, r2, r3, r4, r5, r6, r7 : out std_logic_vector(7 downto 0));
end component;

signal regOut0: std_logic_vector(7 downto 0);
signal regOut1: std_logic_vector(7 downto 0);
signal regOut2: std_logic_vector(7 downto 0);
signal regOut3: std_logic_vector(7 downto 0);
signal regOut4: std_logic_vector(7 downto 0);
signal regOut5: std_logic_vector(7 downto 0);
signal regOut6: std_logic_vector(7 downto 0);
signal regOut7: std_logic_vector(7 downto 0);

signal regIn0: std_logic_vector(7 downto 0);
signal regIn1: std_logic_vector(7 downto 0);
signal regIn2: std_logic_vector(7 downto 0);
signal regIn3: std_logic_vector(7 downto 0);
signal regIn4: std_logic_vector(7 downto 0);
signal regIn5: std_logic_vector(7 downto 0);
signal regIn6: std_logic_vector(7 downto 0);
signal regIn7: std_logic_vector(7 downto 0);

begin
	read1: mux8x8 port map(r0 => regOut0, r1 => regOut1,r2 => regOut2,r3 => regOut3,r4 => regOut4,
		r5 => regOut5,r6 => regOut6,r7 => regOut7,sel => readReg1(2 downto 0), dataRead => readData1
	);
	
	read2: mux8x8 port map(r0 => regOut0, r1 => regOut1,r2 => regOut2,r3 => regOut3,r4 => regOut4,
		r5 => regOut5,r6 => regOut6,r7 => regOut7, sel => readReg2(2 downto 0), dataRead => readData2
	);
	
	writeIn: demux8x8 port map(r0 => regIn0, r1 => regIn1,r2 => regIn2,r3 => regIn3,r4 => regIn4,
		r5 => regIn5,r6 => regIn6,r7 => regIn7, sel => writeReg(2 downto 0), dataWrite => writeData
	);
	
	reg0 : reg8bits port map(clk => clk, load => writeCtl, din => regIn0, dout => regOut0);
	reg1 : reg8bits port map(clk => clk, load => writeCtl, din => regIn1, dout => regOut1);
	reg2 : reg8bits port map(clk => clk, load => writeCtl, din => regIn2, dout => regOut2);
	reg3 : reg8bits port map(clk => clk, load => writeCtl, din => regIn3, dout => regOut3);
	reg4 : reg8bits port map(clk => clk, load => writeCtl, din => regIn4, dout => regOut4);
	reg5 : reg8bits port map(clk => clk, load => writeCtl, din => regIn5, dout => regOut5);
	reg6 : reg8bits port map(clk => clk, load => writeCtl, din => regIn6, dout => regOut6);
	reg7 : reg8bits port map(clk => clk, load => writeCtl, din => regIn7, dout => regOut7);
			
end architecture;
	