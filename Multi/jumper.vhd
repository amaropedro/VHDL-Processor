----------------------------------------------------------
-- Jumper	 											--
-- myMIPS												--
-- Prof. Max Santana (2022)								--
-- CEComp/Univasf										--
----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity jumper is 
  port(
    addr  	 :in  std_logic_vector(25 downto 0);
    pc		 :in  std_logic_vector(31 downto 0);
    jumpaddr :out std_logic_vector(31 downto 0) := x"00000000"
  );
end entity;

architecture behv of jumper is 
begin
  process(addr, pc) begin 
    jumpaddr(27 downto 2) <= addr(25 downto 0) ;
    jumpaddr(31 downto 28) <= pc(31 downto 28);
  end process;
end behv;