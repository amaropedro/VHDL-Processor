----------------------------------------------------------
-- 5 bit 3:1 multiplexer								--
-- myCPU												--
-- Alunos tristes (2023)								--
-- CEComp/Univasf										--
----------------------------------------------------------

library ieee ;
use ieee.std_logic_1164.all;

entity mux35 is
  port(	
    d0, d1, d2 : in std_logic_vector(4 downto 0);
    s      : in std_logic_vector(1 downto 0);
    y	   : out std_logic_vector(4 downto 0)
  );
end mux35;

architecture behavior of mux35 is
begin

with s select y <=
	d0 when "00",
	d1 when "01",
	d2 when "10",
	"XXXXX" when "11",
    "XXXXX" when others;
end behavior;