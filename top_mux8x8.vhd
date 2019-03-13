library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--8 inputs mux (32 bits)
-- Used to output CPU's registers content:

--000 PC The program counter value
--001 ALUResult The result of the current ALU operation
--010 ReadData1 The read data 1 port of the register File
--011 ReadData2 The read data 2 port of the register File
--100 WriteData The write data port of the register File
--Other ['0', RegDst, Jump, MemRead, The remaining
--MemtoReg, AluOp[1..0], AluSrc] control information

entity top_mux8x8 is
	
	port(PC, ALUresult, readData1, readData2, writeData, other, i6, i7: in std_logic_vector(7 downto 0); -- i6 and i7 not used
		sel :in std_logic_vector(2 downto 0);
		muxOut: out std_logic_vector(7 downto 0));
		
end entity top_mux8x8;

architecture muxBehave of top_mux8x8 is
	
component mux1x8 is
	
	port(PC, ALUresult, readData1, readData2, writeData, other, i6, i7: in std_logic;  -- i6 and i7 not used
		sel :in std_logic_vector(2 downto 0);
		muxOut: out std_logic);
		
end component;	

begin
	
	generate8: for i in 0 to 7 generate
	
	mux_gen: mux1x8 port map(PC => PC(i), ALUresult => ALUresult(i), readData1 => readData1(i), 
					readData2 => readData2(i), writeData => writeData(i), other => other(i),
					 i6 => i6(i), i7 => i7(i), sel => sel, muxOut => muxOut(i));	
	end generate;
end muxBehave;

-- Linking of components and top level entity
configuration conf_top_mux8x8 of top_mux8x8 is
	for muxBehave
		for all : mux1x8
			use entity work.mux1x8(muxBehave);
		end for;
	end for;
end conf_reg8bits;
