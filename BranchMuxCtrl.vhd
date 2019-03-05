library ieee;
use ieee,std_logic_1164.all;

entity BranchMuxCtrl is
port (
	zero,BEQ,BNE : in std_logic;
	muxSel: out std_logic_vector(2 downto 0)
	
);
end entity;
architecture logic of BranchMuxCtrl is
signal branchE,branchNE:std_logic; 
begin
    branchE   <= beq and zero;
	branchNE <= BNE and (not zero);
	muxSel    <= branchE or branchNE;
end architecture logic;
      