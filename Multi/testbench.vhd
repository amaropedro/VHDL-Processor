library ieee;
use ieee.std_logic_1164.all;

entity testbench is
end entity testbench;

architecture tb of testbench is
  signal clock, reset 	: std_logic := '0';
  constant clock_period : time := 20 ns;
  
begin
  myMIPS: entity work.myMIPS port map (
    clk => clock, 
    rst => reset
  );
    
  geradorFuncoes : process
  begin
    for i in 0 to 10 loop
      Clock <= '0';
      wait for clock_period/2;
      Clock <= '1';
      wait for clock_period/2;
	end loop;
    wait;
  end process;

  process
  begin    
    reset <= '1';
    wait for 10 ns;
    
    reset <= '0';
    wait;
  end process;
end tb;