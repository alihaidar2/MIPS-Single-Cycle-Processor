-- this ALU is used for main calculations

library ieee;
use ieee.std_logic_1164.all;

entity ALUMain is
port (
	aluIn1, aluIn2 : in std_logic_vector(7 downto 0);
	aluOut : out std_logic_vector(7 downto 0);
	zero : out std_logic;
	
	-- control signal
	aluOP : in std_logic_vector(2 downto 0)
);
end entity;

architecture aluMainArch of ALUMain is
	
	-- for add operation
	component adder8bit
	port (
		aluIn1, aluIn2 : in std_logic_vector(7 downto 0);
		aluOut : out std_logic_vector(6 downto 0);
		cOut : out std_logic
		-- control, clk, rst : in std_logic
		);
	end component;
	
	--for subtract operation
	component sub8bit
	port (
		ain, bin, Cin : in std_logic;
		res, Cout : out std_logic
		);
	end component;
	
	
	
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
	