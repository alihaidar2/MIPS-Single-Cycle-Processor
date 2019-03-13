library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity and_gate2 is
port (clk, load: in std_logic; y: out std_logic);
end and_gate2;

architecture basic of and_gate2 is
begin
    and2_behavior: process is
   begin
       y <= clk and load after 2 ns;
      wait on clk, load;
   end process and2_behavior;
end architecture basic;