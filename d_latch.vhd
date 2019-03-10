library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity d_latch is
   port(d, clk, rst: in std_logic; q: out std_logic);
end d_latch;

architecture basic of d_latch is
begin
     latch_behavior: process is
     begin
        if rst = '1' then
        	q <= '0' after 2 ns;
        elsif clk = '1' then	
    		q <= d after 2ns;
    	end if;
        wait on clk, d, rst;
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