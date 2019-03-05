library ieee;
use ieee,std_logic_1164.all;

entity aluCtrl is
port (
	aluOpIn : in std_logic_vector(1 downto 0);
	functionBits : in std_logic_vector(5 downto 0);
	aluOpOut : out std_logic_vector(2 downto 0)
	
);
end entity;

architecture ALUCtrlArch of aluctrl is 
	
--signals and components
	signal sig0, sig1, op2, op1, op0 : std_logic;

begin
	
	-- internal logic
	-- does this work this way?
	sig0 <= functionbits(0) or functionBits(3);
	sig1 <= aluOp(1) and functionBits(1);
	op2 <= aluOp(0) or sig1;
	op1 <= not(aluOp(1)) or not(functionBits(2));
	op0 <= aluop(1) and sig0;
	
	-- output logic
	aluOpOut <= aluOp(2)&aluOp(1)&aluOp(0);
	
end architecture;