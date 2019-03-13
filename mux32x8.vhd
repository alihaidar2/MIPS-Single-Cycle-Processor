library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--8 inputs mux (32 bits)
-- Used to output CPU's registers content:

--000 PC The program counter value
--001 ALUResult The result of the current ALU operation
--010 ReadData1 The read data 1 port of the register le
--011 ReadData2 The read data 2 port of the register le
--100 WriteData The write data port of the register le
--Other ['0', RegDst, Jump, MemRead, The remaining
--MemtoReg, AluOp[1..0], AluSrc] control information

entity mux32x8 is
	
	port(PC, ALUresult, readData1, readData2, writeData, other, i6, i7 : in std_logic_vector(7 downto 0); -- i6 and i7 not used
		sel :in stdl_logic_vector(2 downto 0);
		muxOut: out std_logic_vector(7 downto 0));
		
end entity mux32x8;

architecture muxBehave of mux32x8 is
begin
	muxOut <= ( (PC and not sel(2) and not sel(1) and not sel(0)) or 
	(ALUresult and not sel(2) and not sel(1) and sel(0)) or
	(readData1 and not sel(2) and sel(1) and not sel(0)) or
	(readData2 and not sel(2) and sel(1) and sel(0)) or
	(writeData and sel(2) and not sel(1) and not sel(0)) or
	(other and sel(2) and not sel(1) and sel(0)) or
	(i6 and sel(2) and sel(1) and not sel(0)) or
	(i7 and sel(2) and sel(1) and sel(0)) );
	
end muxBehave;
