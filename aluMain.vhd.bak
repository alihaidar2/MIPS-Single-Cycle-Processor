library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

--Main ALU. Composed of add&sub, ofDetector, mux32x4
--The ALU is design to operate with 32 bits operands. In the 8 bits data version, 
--sign extends for operands will be needed to extend operands to 32 bits.
--Similarly, the 32 bits ALU output will have to be sliced to 8 bits when data mem is 256x8.
entity ALUMain is
	
port (
	aluOP : in std_logic_vector(2 downto 0); --Most significant bit of aluOP (aluOP(2)) will determine Cin for add/sub operation. Cin=1 for sub
	aluIn1, aluIn2 : in std_logic_vector(31 downto 0);
	aluOut : out std_logic_vector(31 downto 0); -- for a 256x8 data mem, output will be sliced to 8 bits
	CarryOut : out std_logic;
	ovrFlw : out std_logic;
	zero : out std_logic
);
end entity;

architecture aluMainArch of ALUMain is

--components used--------	
component add_sub
	PORT ( Cin, x, y : IN STD_LOGIC ;
			s, Cout : OUT STD_LOGIC );
end component;

component mux32x4
	port(
		sel :in std_logic_vector(1 downto 0); 
		logicAND, logicOR, add_sub, SLT: in std_logic_vector(31 downto 0);
		z: out std_logic_vector(31 downto 0)
	);
end component;

component ofDetector
	port (
		a, b, result : in std_logic;
		ovrflw : out std_logic
	);
end component;

--carry signal through full adders
	signal carry: std_logic_vector(30 downto 0);
-- Signal for result of add/sub operation
	signal sig_aluOut: std_logic_vector(31 downto 0); 
-- signals for operations
	signal sig_OR: std_logic_vector(31 downto 0);
	signal sig_AND: std_logic_vector(31 downto 0);
	signal sig_SLT: std_logic_vector(31 downto 0);	 
	signal sig_zero: std_logic;
	
--Architecture------------	
begin
	
		outerloop: for i in 0 to 31 generate

--Most significant bit of aluOP (aluOP(2)) will determine Cin for add/sub operation. Cin=1 for sub
-- Set the initial Cin to 1 instead of 0, thus adding an extra 1 to the sum	for a sub operation	
		innerloop1: if (i = 0) generate
			addSub0: add_sub port map(Cin => aluOP(2), x => aluIn1(i), y => aluIn2(i),
										s => sig_aluOut(i), Cout => carry(i));
		end generate innerloop1;
		
		innerloop2: if (i>0 and i<31) generate 
				addsub: add_sub port map(Cin => carry(i-1), x => aluIn1(i), y => aluIn2(i),
										s => sig_aluOut(i), Cout => carry(i));
		end generate innerloop2;
		
		innerloop3: if (i=31) generate
			add31: add_sub port map (Cin => carry(i-1), x => aluIn1(i), y => aluIn2(i),
										s => sig_aluOut(i), Cout => CarryOut);
		end generate innerloop3;
		
	end generate outerloop;
	
	overflow: ofDetector port map(a => aluIn1(31), b => aluIn2(31), result => sig_aluOut(31), ovrflw => ovrflw);
	operation: mux32x4 port map(sel => aluOP(1 downto 0), logicAND => sig_AND, logicOR => sig_OR, add_sub => sig_aluOut, 
									SLT => sig_SLT, z => aluOut);
	
	sig_OR <= aluIn1 or aluIn2;
	sig_AND <= aluIn1 and aluIn2;
	
	sig_zero <= not(aluOut(0) or aluOut(1) or aluOut(2) or aluOut(3) or aluOut(4) or aluOut(5) or
		 aluOut(6) or aluOut(7) or aluOut(8) or aluOut(9) or aluOut(10) or aluOut(11) or aluOut(12) or
		  aluOut(13) or aluOut(14) or aluOut(15) or aluOut(16) or aluOut(17) or aluOut(18) or aluOut(19) or
		   aluOut(20) or aluOut(21) or aluOut(22) or aluOut(23) or aluOut(24) or aluOut(25) or aluOut(26) or
		    aluOut(27) or aluOut(28) or aluOut(29) or aluOut(30) or aluOut(31));
		    	
	sig_SLT(31 downto 1) <= (others=>'0');
	sig_SLT(0) <= sig_aluOut(31); --For the least significant bit, SLT value should be sign of (aluIn1 – aluIn2)
	
end architecture;	

-- Linking of components and top level entity-----------
configuration basic_level of aluMain is
	for aluMainArch
		for all : add_sub
			use entity work.add_sub(behave);
		end for;
		for all : ofDetector
			use entity work.ofDetector(behave);
		end for;
		for all : mux32x4
			use entity work.mux32x4(muxBehave);
		end for;
	end for;
end basic_level;	
	
	
	

	