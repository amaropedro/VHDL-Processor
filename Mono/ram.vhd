----------------------------------------------------------
-- A simple 256x8 data memory							--
-- myCPU												--
-- Prof. Max Santana (2023)								--
-- CEComp/Univasf										--
----------------------------------------------------------

------------- $sp (0xFF)
-- dynamic --
-- data    --
-------------     (0x7F)
-- Global  --
-- data    --
------------- $gp (0x00)

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
	DEPTH			: integer := 640--256
  );
  port (
       datain : in std_logic_vector(31 downto 0);
       address : in std_logic_vector(31 downto 0);
       -- write when 0, read when 1
       w_r : in std_logic;
       dataout : out std_logic_vector(31 downto 0)
       );
end entity;

architecture bev of ram is

type mem is array (0 to DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
signal memory : mem;
signal addr : integer range 0 to DEPTH-1;

--type rom_type is array (0 to DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
--  signal imem : rom_type;


begin

  process(address)
  begin

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
  end process;

end bev;