library ieee;
use ieee.numeric_std.all;

--Main ALU. Composed of add&sub, three 32 bits muxes
entity ALUMain is
port (
	Cin : std_logic;
	aluOP : in std_logic_vector(2 downto 0);
	aluIn1, aluIn2 : in std_logic_vector(31 downto 0);
	aluOut : out std_logic_vector(7 downto 0); --Output should be 8 bits as we're using 256x8 data mem.
	Cout : std_logic;
	zero : out std_logic
);
end entity;

architecture aluMainArch of ALUMain is
	
component add_sub
	PORT ( Cin, x, y : IN STD_LOGIC ;
			s, Cout : OUT STD_LOGIC );
end component;

component mux32
	port(
		sel :in std_logic; 
		a, b: in std_logic_vector(31 downto 0);
		z: out std_logic_vector(31 downto 0)
	);
end component;

-- Signals needed to extend operands to 32 bits.
	signal sig_aluIn1: std_logic_vector(31 downto 0);
	signal sig_aluIn2: std_logic_vector(31 downto 0); 
	signal sig_aluOut: std_logic_vector(31 downto 0);  
begin
	
	-- this is left
	--
	-- need to create 16 bit AND, OR, add, subtract and SOLT circuits
	
	-- If ALUOp = 000
	aluOut <= aluIn1 and aluIn2;
	
	-- If ALUOp = 001
	aluOut <= aluIn1 or aluIn2;
	
	-- If ALUOp = 010
	-- add
	-- generate 8 adder
	
	-- If ALUOp = 110
	-- subtract
	
	-- If ALUOp = 010
	-- Compare and "aluOut = 1" if 1 > 2
	