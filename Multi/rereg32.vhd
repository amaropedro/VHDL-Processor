--------------------------------------------------------------
-- myMIPS: 32 bits resettable enabled register  	    --
--                                      		    --
-- Prof. Max Santana  (2020)                		    --
-- CEComp/Univasf                       		    --
--------------------------------------------------------------

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
    if (rst = '1') then
      q <= (q'range => '0');      
	elsif (falling_edge(clk)) then
      if (e = '1') then
	    q <= d;
      end if;
	end if;
  end process;
end behv;