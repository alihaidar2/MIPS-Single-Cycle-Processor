library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

--MIPS Single Cycle CPU
--This file is the top level entity
entity top is
port (
	--inputs
	GClock, GReset : in std_logic;
	ValueSelect : in std_logic_vector(2 downto 0);
	
	--outputs
	RegWriteOut, MemWriteOut, ZeroOut, BranchOut : out std_logic;
	InstructionOut : out std_logic_vector(31 downto 0);
	MuxOut : out std_logic_vector(31 downto 0)-- PC remains 32 bits. 
);
end entity;

architecture topArch of top is
	
--components---------------------
component PCreg -- once
port(
  clk    : in STD_LOGIC;
  rst    : in STD_LOGIC;
  PC_in  : in STD_LOGIC_VECTOR (31 downto 0);
  PC_out : out STD_LOGIC_VECTOR (31 downto 0));
end component;
	
	component instructionMem -- once
	port (
		pcAddIn : in std_logic_vector(7 downto 0);
		instructionOut: out std_logic_vector(31 downto 0)
	);
	end component;
	
component regFile -- once
port (
	readReg1, readReg2, writeReg : in std_logic_vector(4 downto 0);
	clk, writeCtl: in std_logic;
	writeData : in std_logic_vector(7 downto 0);
	readData1, readData2 : out std_logic_vector(7 downto 0)	
);
end component;
	
component aluMain -- once
port (
	aluOP : in std_logic_vector(2 downto 0); --Most significant bit of aluOP (aluOP(2)) will determine Cin for add/sub operation. Cin=1 for sub
	aluIn1, aluIn2 : in std_logic_vector(31 downto 0);
	aluOut : out std_logic_vector(31 downto 0); -- for a 256x8 data mem, output will be sliced to 8 bits
	CarryOut : out std_logic;
	ovrFlw : out std_logic;
	zero : out std_logic
);
end component;
	
	component dataMem -- once
	port (
		addressIn : in std_logic_vector(7 downto 0); 
		writeDataIn : in std_logic_vector(7 downto 0);
		readDataOut : out std_logic_vector(7 downto 0);
		
		--control signals
		memRead, memWrite : out std_logic
	);
	end component;
	
component adder32 -- once
generic(g_carry_in : std_logic := '0');	
port (
	CarryIn : in std_logic := g_carry_in;
	aluIn1, aluIn2 : in std_logic_vector(31 downto 0);
	aluOut : out std_logic_vector(31 downto 0);
	carryOut : out std_logic
);
end component;

component PC_adder32 -- once
	
generic(g_next_instr : std_logic_vector(31 downto 0) := x"0004";
		g_carry_in : std_logic := '0');	
		
port (
	CarryIn : in std_logic := g_carry_in; 
	aluIn1 : in std_logic_vector(31 downto 0);
	aluOut : out std_logic_vector(31 downto 0);
	carryOut : out std_logic
);
end component;
	
component jumpShiftLeft2 -- once
port (
	slIn : in std_logic_vector(25 downto 0);
	slOut : out std_logic_vector(27 downto 0) 
);
end component;
	
component branchShiftLeft2 -- once
port (
	slIn : in std_logic_vector(31 downto 0);
	slOut : out std_logic_vector(31 downto 0) 
);
end component;
	 
	component signExtend -- once
	port (
		seIn : in std_logic_vector(15 downto 0);
		seOut : out std_logic_vector(31 downto 0)
	);
	end component;
	
component mux5x2 -- once
port (
		sel : in std_logic;
		a, b : in std_logic_vector(4 downto 0);
		z : out std_logic_vector(4 downto 0)
	);
end component;
	
component mux8x2 -- once
port(
		sel : in std_logic;
		a, b : in std_logic_vector(7 downto 0);
		z : out std_logic_vector(7 downto 0)
	);
end component;
	
component mux32x2 -- twice
port(
		sel : in std_logic;
		a, b : in std_logic_vector(31 downto 0);
		z : out std_logic_vector(31 downto 0)
	);
end component;
	
component aluCtrl -- once
port (
		-- not sure about these lengths
		aluOpIn : in std_logic_vector(1 downto 0);
		functionBits : in std_logic_vector(5 downto 0);
		aluOpOut : out std_logic_vector(2 downto 0)
	);
end component;

component signExtend8
	port (
	seIn : in std_logic_vector(7 downto 0);
	seOut : out std_logic_vector(31 downto 0)
	);
end component;
	
component ctrlUnit -- once
port (
		Opcode : in std_logic_vector(5 downto 0);
		RegDst, Jump, Branch, MemRead, MemToReg : out std_logic;
		MemWrite, ALUSrc, RegWrite: out std_logic;
		ALUOp: out std_logic_vector(1 downto 0)
	);
end component;
	
	
	
	signal sigPCIn, sigPCOut, sig4AddOut, sigInstruction, sigSEOut, sigSLAdd, sigAddOut, sigJump, sigMUXTop1 : std_logic_vector(31 downto 0);
	signal sigMUX5Out : std_logic_vector(4 downto 0);
	signal sigWD, sigRD1, sigRD2, sigMUXALU, sigALURes, sigRD : std_logic_vector(7 downto 0);
	signal sigZero : std_logic;
	signal sigSLOut : std_logic_vector(27 downto 0);
	signal clk, rst : std_logic;
	signal ctlRegDest, ctlJump, ctlBranch, ctlMemRead, ctlMemToReg, ctlMemWrite, ctlALUSrc, ctlRegWrite : std_logic;  
	signal ctlALUOp : std_logic_vector(1 downto 0);
	signal ctlALUtoControl : std_logic_vector(2 downto 0);
	signal ctlMuxBranch :std_logic;

	signal jumpAddress : std_logic_vector(31 downto 0);

begin
	
	-- add clocks and resets on combinational logic
	-- need to do Control Units mapping
	---- involves adding control ports to all necessary components and readjusting
	
	jumpAddress <= sig4AddOut(31 downto 28) & sigSLOut;
	ctlMuxBranch <= ctlBranch and zero;  
	
	PC : PCreg port map(sigPCIn, sigPCOut);
	IM : instrcutionMem port map(sigPCOut, sigInstruction);
	regFile: regFile port map(sigInstruction(25 downto 21), sigInstruction(20 downto 16), sigMUX5Out, sigWD, sigRD1, sigRD2, ctlRegWrite);
	aluMain : aluMain port map(sigRD1, sigMUXALU, sigALURes, sigZero, ctlALUtoControl);
	dataMem : dataMem port map(sigALURes, sigRD2, sigRD, ctlMemRead, ctlMemWrite);
	aluBranch : adder32 port map(sig4AddOut, sigSLAdd, sigAddOut);
	aluPC : PC_adder32 port map(sigPCOut, "0000000000000100", sig4AddOut); -- PC + 4 adder
	jumpShiftLeft2 : jumpShiftLeft2 port map(sigInstruction(25 downto 0), sigSLOut);
	branchShiftLeft2 : branchShiftLeft2 port map(sigSEOut, sigSLAdd);
	signExtend : signExtend port map(sigInstruction(15 downto 0), sigSEOut);
	muxInstruction : mux5x2 port map(sigInstruction(20 downto 16), sigInstruction(15 downto 11), sigMUX5Out, ctlRegDst);
	
	-- why is this taking the 32 bits of sign extend
	muxOp2 : mux8 port map(sigRD2, "sigSEOut", sigMUXALU, ctlALUSrc);
	muxWrite : mux8x2 port map(sigRD, sigALURes, sigWD);
	muxBranch : mux32x2 port map(sig4AddOut, sigAddOut, sigMUXTop1, ctlMuxBranch);
	muxNextPC : mux32x2 port map(jumpAddress, sigMUXTop1, sigPCIn, ctlJump);
	
	
	ctrlUnit : ctrlUnit port map(sigInstruction(31 downto 26), ctlRegDest, ctlJump, ctlBranch, ctlMemRead, ctlMemToReg, ctlALUPOp, ctlMemWrite, ctlALUSrc, ctlRegWrite, ctlALUOp);
	
	aluCtrl : aluCtrl port map(ctlALUOp, sigInstruction(5 downto 0), ctlALUtoControl);
		
end topArch;

-- Linking of components and top level entity------------
configuration conf_top of top is
	for topArch
		for all : PCreg
			use entity work.PCreg(reg);
		end for;
		for all : regFile
			use entity work.regFile(regFilebehave);
		end for;
		for all : ALUMain
			use entity work.ALUMain(aluMainArch);
		end for;
		for all : adder32
			use entity work.adder32(adder32behave);
		end for;
		for all : jumpShiftLeft2
			use entity work.jumpShiftLeft2(jsl);
		end for;
		for all : branchShiftLeft2
			use entity work.branchShiftLeft2(bsl);
		end for;
		for all : signExtend
			use entity work.signExtend(behave);
		end for;
		for all : mux5x2
			use entity work.mux5x2(muxBehave);
		end for;
		for all : mux8x2
			use entity work.mux8x2(muxBehave);
		end for;
		for all : mux32x2
			use entity work.mux32x2(muxBehave);
		end for;
		for all : aluCtrl
			use entity work.aluCtrl(ALUCtrlArch);
		end for;
		for all : signExtend8
			use entity work.signExtend8(behave);
		end for;
		for all : ctrlUnit
			use entity work.ctrlUnit(ctrLogic);
		end for;
	end for;
end conf_top;
