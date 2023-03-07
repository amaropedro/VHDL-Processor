----------------------------------------------------------
-- A simple 256x8 memory							--
-- myCPU												--
-- Prof. Max Santana (2020)								--
-- CEComp/Univasf										--
----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use std.textio.all;
use ieee.std_logic_textio.all;


entity ram is
  generic(	
    DATA_WIDTH		: integer := 8;
	ADDRESS_WIDTH	: integer := 8;
	DEPTH			: integer := 256
  );
  port (
       clock,reset : in std_logic;
       datain : in std_logic_vector(31 downto 0);
       address : in std_logic_vector(31 downto 0);
       -- write when 1, read when 0
       w_r : in std_logic;
       dataout : out std_logic_vector(31 downto 0)
       );
end entity;

architecture bev of ram is

type mem is array (0 to DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
signal memory : mem;
signal addr : integer range 0 to DEPTH-1;

begin


  process(clock,reset)
    use STD.TEXTIO.all;
    file f: TEXT open READ_MODE is "instructions.data";
    variable l: LINE;
    variable value: std_logic_vector(DATA_WIDTH-1 downto 0);
    variable i: integer := 0;
  begin
    if (falling_edge(reset)) then
      while not endfile(f) loop
        READLINE (f, l);
        READ (l, value);
        memory(i) <= value;
        i:= i+1;
      end loop;	
	elsif (falling_edge(clock)) then

      if(w_r='1')then
        memory(to_integer(signed(address))) <= datain(7 downto 0);
        memory(to_integer(signed(address))+1) <= datain(15 downto 8);
        memory(to_integer(signed(address))+2) <= datain(23 downto 16);
        memory(to_integer(signed(address))+3) <= datain(31 downto 24);
                  
      elsif(w_r='0')then
        dataout(7 downto 0)   <= memory(to_integer(signed(address)));
        dataout(15 downto 8)  <= memory(to_integer(signed(address))+1);
        dataout(23 downto 16) <= memory(to_integer(signed(address))+2);
        dataout(31 downto 24) <= memory(to_integer(signed(address))+3);
      
      else
        dataout<= x"XXXXXXXX";
      end if;
    end if;

  end process;

end bev;
