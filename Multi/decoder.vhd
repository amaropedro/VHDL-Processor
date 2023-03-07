library ieee;
use ieee.std_logic_1164.all;

entity idecoder is
  port(	
    i		: in std_logic_vector(31 downto 0);
    irwrite : in std_logic;
	op		: out std_logic_vector(5 downto 0); 	-- [31..26]
	rs		: out std_logic_vector(4 downto 0); 	-- [25..21]
	rt		: out std_logic_vector(4 downto 0); 	-- [20..16]
	rd		: out std_logic_vector(4 downto 0); 	-- [15..11]
	shamt	: out std_logic_vector(4 downto 0); 	-- [10..6]
	funct	: out std_logic_vector(5 downto 0); 	-- [5..0]
	imm	    : out std_logic_vector(15 downto 0); 	-- [15..0]
	addr	: out std_logic_vector(25 downto 0);	-- [25..0]
);
end idecoder;

architecture behv of idecoder is
begin
  process(irwrite, i)
    begin
      if (irwrite) then
            op 	  <= i(31 DOWNTO 26);
            rs 	  <= i(25 DOWNTO 21);
            rt 	  <= i(20 DOWNTO 16);
            rd 	  <= i(15 DOWNTO 11);
            shamt <= i(10 DOWNTO 6);
            funct <= i(5 DOWNTO 0);
            imm	  <= i(15 DOWNTO 0);
            addr  <= i(25 DOWNTO 0);
       end if;
    end process;
end behv;