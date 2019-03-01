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
	
		-- control signal, I'll uncomment once im done everything else
		-- regWrite : in std_logic
	);
	
	end component;
	
	component aluMain -- once
	port (
		aluIn1, aluIn2 : in std_logic_vector(7 downto 0);
		aluOut : out std_logic_vector(7 downto 0);
		zero : out std_logic
		-- control signal, will uncomment after im done port mapping for everything else
		--aluOP : in std_logic_vector(2 downto 0)
	);
	end component;
	
	component dataMem -- once
	port (
		addressIn : in std_logic_vector(7 downto 0); 
		writeDataIn : in std_logic_vector(7 downto 0);
		readDataOut : out std_logic_vector(7 downto 0);
		
		-- control signals
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
		seOut : out std_logic_vector(15 downto 0)
	);
	end component;
	
	component mux5 -- once
	port (
		in0, in1: in std_logic_vector(4 downto 0);
		muxOut : out std_logic_vector(4 downto 0)
	);
	end component;
	
	component mux8 -- twice
	port (
		in0, in1 : in std_logic_vector(7 downto 0);
		muxOut : out std_logic_vector(7 downto 0)
	);
	end component;
	
	component mux32 -- twice
	port (
		in0, in1 : in std_logic_vector(31 downto 0);
		muxOut : out std_logic_vector(31 downto 0)
	);
	end component;
	
	component aluCtrl -- once
	port (
		-- not sure about these lengths
		aluOpIn : in std_logic_vector(2 downto 0);
		aluOpOut : out std_logic_vector(2 downto 0)
	);
	end component;
	
	component ctrlUnit -- once
	port (
		RegDst, Jump, Branch, MemRead, MemToReg : out std_logic;
		ALUOp, MemWrite, ALUSrc, RegWrite: out std_logic;
		Opcode : in std_logic(5 downto 0)
	);
	end component;
	
	signal sigPCIn, sigPCOut, sig4AddOut, sigInstruction : std_logic_vector(31 downto 0);
	signal sigMUX5Out : std_logic_vector(4 downto 0);

begin
	
	-- still gotta figure out how to do port
	-- mapping properly
	PC : programCounter port map(x);
	IM : instrcutionMem port map(x);
	
	
	regFile: regFile port map(x);
	
	aluMain : aluMain port map(x);
	
	dataMem : dataMem port map(x);
	
	aluBranch : alu32 port map(x);
	aluPC : alu32 port map(x);
	
	jumpShiftLeft2 : jumpShiftLeft2 port map(x);
	branchShiftLeft2 : branchShiftLeft2 port map(x);
	signExtend : signExtend port map(x);
	muxInstruction : mux5 port map(x);
	
	muxOp2 : mux8 port map(x);
	muxWrite : mux8 port map(x);
	
	muxNextPC : mux32 port map(x);
	muxBranch : mux32 port map(x);
	
	aluCtrl : aluCtrl port map(x);
	ctrlUnit : ctrlUnit port map(x);
	
end topArch;
