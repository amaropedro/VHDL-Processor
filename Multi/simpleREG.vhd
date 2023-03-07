----------------------------------------------------------
-- Simple REGISTER          							--
-- Amaro			 (2023)								--
-- CEComp/Univasf										--
----------------------------------------------------------

library ieee ;
use ieee.std_logic_1164.all;

entity simpleREG is
  port(
  	clock : in std_logic;
    i : in std_logic_vector(31 downto 0);
    o : out std_logic_vector(31 downto 0);
  );
end simpleREG;

architecture behv of simpleREG is
begin
  process(clock)
  begin
    if (falling_edge(clock)) then
		o <= i;
    end if;
  end process;
 end behv;