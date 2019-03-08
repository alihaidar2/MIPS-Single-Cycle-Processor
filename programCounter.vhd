library ieee;
use ieee.std_logic_1164.all;

entity programCounter is
	port (
	  clk,rst:in std_logic;
		pcIn   : in std_logic_vector(31 downto 0);
		pcOut  : out std_logic_vector(31 downto 0)
	);
end entity;
architecture pc of programCounter is 
component PCreg is
  port(
  clk    : in STD_LOGIC;
  rst    : in STD_LOGIC;
  PC_in  : in STD_LOGIC_VECTOR (31 downto 0);
  PC_out : out STD_LOGIC_VECTOR (31 downto 0));
end component;
signal clock,reset:std_logic;
begin
  clock=clk;reset<=rst;
  process(clock,reset)
    begin
      if reset='1' then
         pcOut<=(others=>'0');
      elsif clock'event and clock='1' then
         pc_reg:PCreg port map(clock,reset,pcIn,pcOut);
      end if;
    end process;
end pc;
    
      