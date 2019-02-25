library ieee;
use ieee.std_logic_1164.all;

entity ctrlUnit is
	port (
	RegDst, Jump, Branch, MemRead, MemToReg : out std_logic;
	ALUOp, MemWrite, ALUSrc, RegWrite: out std_logic;
	Opcode : in std_logic(5 downto 0)
);
end entity;