library ieee;
use ieee.numeric_std.all;

--Main ALU. Composed of add&sub, three 32 bits muxes, 2 sign extends
entity ALUMain is
	
port (
	--CarryIN : std_logic; --Not needed for now.
	aluOP : in std_logic_vector(2 downto 0);
	aluIn1, aluIn2 : in std_logic_vector(31 downto 0);
	aluOut : out std_logic_vector(7 downto 0); --Output should be 8 bits as we're using 256x8 data mem.
	CarryOut : std_logic;
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

--carry signal through full adders
	signal carry: std_logic_vector(30 downto 0);
-- Signals needed to extend operands to 32 bits.
	signal sig_aluIn1: std_logic_vector(31 downto 0);
	signal sig_aluIn2: std_logic_vector(31 downto 0); 
	signal sig_aluOut: std_logic_vector(31 downto 0); 
-- signals for operations
	signal sig_OR: std_logic_vector(31 downto 0);
	signal sig_AND: std_logic_vector(31 downto 0);
	signal sig_SLT: std_logic_vector(31 downto 0);	 
begin
	
		outerloop: for i in 0 to 31 generate

--Most significant bit of aluOP (aluOP(2)) will determine Cin for add/sub operation. Cin=1 for sub
-- Set the initial Cin to 1 instead of 0, thus adding an extra 1 to the sum	for a sub operation	
		innerloop1: if (i = 0) generate
			addSub0: add_sub port map(Cin => aluOP(2), x => aluIn1(i), y => aluIn2(i),
										s => sig_aluOut(i), Cout => carry(i));
		end generate innerloop1;
		
		innerloop2: if (i>0 and i<31) generate 
				addsub: add_sub port map(Cin => carry(i-1), x => aluIn1(i), y => aluIn2(i),
										s => sig_aluOut(i), Cout => carry(i));
		end generate innerloop2;
		
		innerloop3: if (i=31) generate
			add31: add_sub port map (Cin => carry(i-1), x => aluIn1(i), y => aluIn2(i),
										s => sig_aluOut(i), Cout => CarryOut);
		end generate innerloop3;
		
	end generate outerloop;
	
	sig_OR <= aluIn1 or aluIn2;
	sig_AND <= aluIn1 and aluIn2;

end architecture;	
	
	
	
	

	