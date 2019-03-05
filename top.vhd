library ieee;
use ieee.std_logic_1164.all;

entity top is
port (
	--inputs
	GClock, GReset : in std_logic;
	ValueSelect : in std_logic_vector(2 downto 0);
	
	--outputs
	RegWriteOut, MemWriteOut, ZeroOut, BranchOut : out std_logic;
	InstructionOut : out std_logic_vector(31 downto 0);
	MuxOut : out std_logic_vector(7 downto 0)
);
end entity;

architecture topArch of top is
	
	--components
	component programCounter -- once
	port (
		pcIn : in std_logic_vector(31 downto 0);
		pcOut : out std_logic_vector(31 downto 0)
	);
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
		writeData : in std_logic_vector(7 downto 0);
		readData1, readData2 : out std_logic_vector(7 downto 0)
		-- control signal
		regWrite : in std_logic
	);
	end component;
	
	component aluMain -- once
	port (
		aluIn1, aluIn2 : in std_logic_vector(7 downto 0);
		aluOut : out std_logic_vector(7 downto 0);
		zero : out std_logic
		-- control signal
		aluOP : in std_logic_vector(2 downto 0)
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
	
	component alu32 -- twice
	port (
		aluIn1, aluIn2 : in std_logic_vector(31 downto 0);
		aluOut : out std_logic_vector(31 downto 0)
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
	
	component mux5 -- once
	port (
		in0, in1: in std_logic_vector(4 downto 0);
		muxOut : out std_logic_vector(4 downto 0);
		ctlMux : in std_logic
	);
	end component;
	
	component mux8 -- twice
	port (
		in0, in1 : in std_logic_vector(7 downto 0);
		muxOut : out std_logic_vector(7 downto 0);
		ctlMux : in std_logic
	);
	end component;
	
	component mux32 -- twice
	port (
		in0, in1 : in std_logic_vector(31 downto 0);
		muxOut : out std_logic_vector(31 downto 0);
		ctlMux : in std_logic
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
	
	component ctrlUnit -- once
	port (
		Opcode : in std_logic(5 downto 0);
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
	signal jumpAddress : std_logic_vector(31 downto 0);

begin
	
	-- add clocks and resets on combinational logic
	-- need to do Control Units mapping
	---- involves adding control ports to all necessary components and readjusting
	
	jumpAddress <= sig4AddOut(31 downto 28) & sigSLOut;  
	
	PC : programCounter port map(sigPCIn, sigPCOut);
	IM : instrcutionMem port map(sigPCOut, sigInstruction);
	regFile: regFile port map(sigInstruction(25 downto 21), sigInstruction(20 downto 16), sigMUX5Out, sigWD, sigRD1, sigRD2, ctlRegWrite);
	aluMain : aluMain port map(sigRD1, sigMUXALU, sigALURes, sigZero);
	dataMem : dataMem port map(sigALURes, sigRD2, sigRD, ctlMemRead, ctlMemWrite);
	aluBranch : alu32 port map(sig4AddOut, sigSLAdd, sigAddOut);
	aluPC : alu32 port map(sigPCOut, "0000000000000100", sig4AddOut); -- PC + 4 adder
	jumpShiftLeft2 : jumpShiftLeft2 port map(sigInstruction(25 downto 0), sigSLOut);
	branchShiftLeft2 : branchShiftLeft2 port map(sigSEOut, sigSLAdd);
	signExtend : signExtend port map(sigInstruction(15 downto 0), sigSEOut);
	muxInstruction : mux5 port map(sigInstruction(20 downto 16), sigInstruction(15 downto 11), sigMUX5Out, ctlRegDst);
	
	-- why is this taking the 32 bits of sign extend
	muxOp2 : mux8 port map(sigRD2, "sigSEOut", sigMUXALU, ctlALUSrc);
	muxWrite : mux8 port map(sigRD, sigALURes, sigWD);
	muxBranch : mux32 port map(sig4AddOut, sigAddOut, sigMUXTop1, "ctlBranch and zero");
	muxNextPC : mux32 port map(jumpAddress, sigMUXTop1, sigPCIn, ctlJump);
	ctrlUnit : ctrlUnit port map(sigInstruction(31 downto 26), ctlRegDest, ctlJump, ctlBranch, ctlMemRead, ctlMemToReg, ctlMemWrite, ctlALUSrc, ctlRegWrite, ctlALUOp);
	
	aluCtrl : aluCtrl port map(ctlALUOp, sigInstruction(5 downto 0), "ALU control");
	
	
	
end topArch;
