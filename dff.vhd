library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d_latch is
   port(d, clk: in std_logic; q: out std_logic);
end d_latch;

architecture basic of d_latch is
begin
     latch_behavior: process is
     begin
        if clk = 1 then
             q <= d after 2 ns;
        end if;
        wait on clk, d;
     end process latch_behavior;
end architecture basic;

entity and2 is
port (clk, load: in std_logic; y: out std_logic);
end and2;

architecture basic of and2 is
begin
    and2_behavior: process is
   begin
       y <= clk and load after 2 ns;
      wait on clk, load;
   end process and2_behavior;
end architecture basic;
