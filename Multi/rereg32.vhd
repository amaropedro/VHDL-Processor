library ieee;
use ieee.std_logic_1164.all;

entity rereg32 is
  port(
    clk   : in std_logic;
    rst   : in std_logic;
    e	  : in std_logic;
    d     : in std_logic_vector(31 downto 0);
    q	  : out std_logic_vector(31 downto 0)
  );
end rereg32;

architecture behv of rereg32 is
begin
  process(clk, rst)
  begin
    if (falling_edge(rst)) then
      q <= (q'range => '0');      
	elsif (falling_edge(clk)) then
      if (e = '1') then
	    q <= d;
      end if;
	end if;
  end process;
end behv;