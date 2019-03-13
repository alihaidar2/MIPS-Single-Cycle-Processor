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
	MuxOut : out std_logic_vector(7 downto 0)-- PC remains 32 bits. 
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
		pcAddIn : in std_logic_vector(31 downto 0);
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
	
generic(g_next_instr : std_logic_vector(31 downto 0) := "00000000000000000000000000000100";
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
		RegDst, Jump,BEQ,BNE, MemRead, MemToReg : out std_logic;
		MemWrite, ALUSrc, RegWrite: out std_logic;
		ALUOp: out std_logic_vector(1 downto 0)
	);
end component;

component BranchMuxCtrl is
port (
	zero,BEQ,BNE : in std_logic;
	muxSel: out std_logic
	
);  
end component;

component mux32x8 is
  port(PC, ALUresult, readData1, readData2, writeData, other, i6, i7 : in std_logic_vector(7 downto 0); -- i6 and i7 not used
		sel :in stdl_logic_vector(2 downto 0);
		muxOut: out std_logic_vector(7 downto 0));
end component;
	-----------------------------------------------------

	signal AddressJumpSelMuxOut : std_logic_vector(31 downto 0);
	signal PCaddrOut : std_logic_vector(31 downto 0);
	signal InsMemOut,AluBin : std_logic_vector(31 downto 0);
	signal nextPC,Aluout,BranchAluRes,BranchMuxOut : std_logic_vector(31 downto 0);
	signal jumpShLaddr : std_logic_vector(27 Downto 0);
	signal RegDst, Jump, BEQ,BNE, MemRead, MemToReg,MemWrite, ALUSrc, RegWrite: std_logic;
	signal ALUOp:std_logic_vector(1 downto 0);
	signal signExtIns,shLsignExt:std_logic_vector(31 downto 0);
	signal writeReg:std_logic_vector(4 downto 0);
	signal aluOpout:std_logic_vector(2 downto 0);
	signal zero,overflow,carryOut,PCcarryout,BranchCarryout,BranchMuxSelout:std_logic;
	signal jumpAddress:std_logic_vector(31 downto 0);
	signal Data1,Data2,dataMemOut,dataMemMuxOut:std_logic_vector(7 downto 0);
	signal signExtData2,signExtData1,signExtDataMemOut,signExtMemMuxout:std_logic_vector(31 downto 0);
	signal labMuxOut: std_logic_vector(7 downto 0);
	------mif file(not sure correct or not)
	------Instruction Memory mif file
	type mem_Ins is array(0 to 255) of unsigned(31 downto 0);
        signal ramIns : mem_Ins;
        attribute ramIns_init_file : string;
        attribute ramIns_init_file of ramIns : signal is "InstructionMem.mif";
	------Data Memory mif file
	type mem_dat is array(0 to 255) of unsigned(31 downto 0);
        signal ramMem : mem_dat;
        attribute ramMem_init_file : string;
        attribute ramMem_init_file of ramMem : signal is "dataMem.mif";
  
begin 
	jumpAddress(31 downto 28)<=nextPC(31 downto 28);
	jumpAddress(27 downto 0)<=jumpShLaddr;
	PC : PCreg port map(GClock,GReset,AddressJumpSelMuxOut,PCaddrOut);
	PCadder: PC_adder32 port map('0',PCaddrOut,nextPC,PCcarryout);
	InsMem: instructionMem port map(PCaddrOut,InsMemOut);
	shL2Jump:jumpShiftLeft2 port map(InsMemOut(25 downto 0),jumpShLaddr);
	ctrUnit:ctrlUnit port map(InsMemOut(31 downto 26),RegDst, Jump, BEQ,BNE, MemRead, MemToReg,MemWrite, ALUSrc, RegWrite,ALUOp);
        RegDstMux:mux5x2 port map(RegDst,InsMemOut(20 downto 16),InsMemOut(15 downto 11),writeReg);
	InsSignExtend:signExtend port map(InsMemOut(15 downto 0),signExtIns);
	registerFile:regFile port map(InsMemOut(25 downto 21),InsMemOut(20 downto 16),writeReg,GClock,RegWrite,dataMemMuxOut,data1,data2);
        AluControl:aluCtrl port map(ALUOp,InsMemOut(5 downto 0),aluOpout);
	AluMux: mux32x2 port map(ALUSrc,signExtData2,signExtIns,AluBin);
	MainALU:aluMain port map(aluOpout,signExtData1,AluBin,Aluout,carryOut,overflow,zero);
	InsShL2:branchShiftLeft2 port map(signExtIns,shLsignExt);
	BranchAlu:adder32 port map('0',nextPC,shLsignExt,BranchAluRes,BranchCarryout);
	BranchMuxSel:BranchMuxCtrl port map(zero,BEQ,BNE,BranchMuxSelout);
	BranchMux:mux32x2 port map(BranchMuxSelout,nextPC,BranchAluRes,BranchMuxOut);
        JumpMux:mux32x2 port map(Jump,BranchMuxOut,jumpAddress);
	MemData:dataMem port map(Aluout(7 downto 0),data2,dataMemOut);
	DataMemMu:mux32x2 port map(MemToReg,signExtDataMemOut,Aluout,signExtMemMuxout);
	-------SignExtend 8-32
	Data1Ext:signExtend8 port map(data1,signExtData1);
	Data2Ext:signExtend8 port map(data2,signExtData2);
	-------reduce from 32-8
	dataMemOut<=signExtDataMemOut(7 downto 0);
	dataMemMuxOut<=signExtMemMuxout(7 downto 0);	
	--------generate output
	outMux:mux32x8 port map(PCaddrOut(7 downto 0),Aluout(7 downto0),data1,data2,dataMemMuxOut,'0','0','0',ValueSelect,labMuxOut);
    
    RegWriteOut<=RegWrite;
	MemWriteOut<=MemWrite;
	ZeroOut<=zero;
	BranchOut<=BranchMuxSelout;
	InstructionOut<=InsMemOut;
	MuxOut<=labMuxOut;

	-------still misssing one Mux for the MuxOut

end topArch;

-- Linking of components and top level entity------------
configuration conf_top of top is
	for topArch
		for all : PCreg
			use entity work.PCreg(reg);
		end for;
		for all : PC_adder32
			use entity work.PC_adder32(adder32behave);
		end for;
		for all : BranchMuxCtrl
			use entity work.BranchMuxCtrl(logic);
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
		for all : mux32x8
			use entity work.mux32x8(muxBehave);
		end for;
	end for;
end conf_top;



