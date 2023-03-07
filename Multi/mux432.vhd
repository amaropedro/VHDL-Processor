----------------------------------------------------------
-- Simple REGISTER          							--
-- Amaro			 (2023)								--
-- CEComp/Univasf										--
----------------------------------------------------------

library ieee ;
use ieee.std_logic_1164.all;

entity mux432 is
  port(	
    d0, d1, d2, d3 : in std_logic_vector(31 downto 0);
    s      : in std_logic_vector (1 downto 0);
    y	   : out std_logic_vector(31 downto 0)
  );
end mux432;

architecture behavior of mux432 is
begin
  with s select y <=
	d0 when "00",
	d1 when "01",
	d2 when "10",
	d3 when "11",
    "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" when others;
end behavior;