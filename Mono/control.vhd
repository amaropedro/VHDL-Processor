----------------------------------------------------------
-- Control              								--
-- myMIPS												--
-- Prof. Max Santana (2022)								--
-- CEComp/Univasf										--
----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity control is
  port(
    op, func : in std_logic_vector(5 downto 0);
	regDst	 : out std_logic_vector(1 downto 0);
	jump	 : out std_logic;
    branch	 : out std_logic;
    bne		 : out std_logic;
    memWR	 : out std_logic; -- when 0 (write), 1 (read)
    memToReg : out std_logic;
    aluOp	 : out std_logic_vector(1 downto 0); -- when 10 (R-type), 00 (addi, lw, sw), 01 (beq, bne), xx (j)
    aluSrc	 : out std_logic;
    regWrite : out std_logic;
    PCorMem  : out std_logic;
    JRorADR  : out std_logic
  );
end control;

architecture behavior of control is
begin
  process(op, func)
  begin
    case (op) is
      when "000000" => -- R type			   
	    regDst	 <= "01";
	    jump	 <= '0';
        branch	 <= '0';
        bne	 	 <= '0';
        memWR	 <= 'X';
        memToReg <= '0';
        aluOp	 <= "10";
        aluSrc	 <= '0';
        regWrite <= '1';
        PCorMem  <= '0';
        if (func = "001000") then
        	JRorADR <= '1';
        else
        	JRorADR <= '0';
        end if;
 	  when "100011" => -- lw
        regDst	 <= "00";
	    jump	 <= '0';
        branch	 <= '0';        
        bne	 	 <= '0';
        memWR	 <= '0'; -- read
        memToReg <= '1';
        aluOp	 <= "00";
        aluSrc	 <= '1';
        regWrite <= '1';
        PCorMem  <= '0';
        JRorADR  <= '0';
      when "101011" => -- sw
        regDst	 <= "00";
	    jump	 <= '0';
        branch	 <= '0';        
        bne	 	 <= '0';
        memWR	 <= '1'; -- write
        memToReg <= '1';
        aluOp	 <= "00";
        aluSrc	 <= '1';
        regWrite <= '0';
        PCorMem  <= '0';
        JRorADR  <= '0';
      when "000100" => -- beq
        regDst	 <= "XX";
	    jump	 <= '0';
        branch	 <= '1';
        bne	 	 <= 'X';
        memWR	 <= 'X';
        memToReg <= 'X';
        aluOp	 <= "01";
        aluSrc	 <= '0';
        regWrite <= '0';
        PCorMem  <= '0';
        JRorADR  <= '0';
      when "000101" => -- bne
      regDst	 <= "XX";
	    jump	 <= '0';
        branch	 <= 'X';
        bne	 	 <= '1';
        memWR	 <= 'X';
        memToReg <= 'X';
        aluOp	 <= "01";
        aluSrc	 <= '0';
        regWrite <= '0';
        PCorMem  <= '0';
        JRorADR  <= '0';
      when "001000" => -- addi
        regDst	 <= "00";
	    jump	 <= '0';
        branch	 <= '0';        
        bne	 	 <= '0';
        memWR	 <= 'X';
        memToReg <= '0';
        aluOp	 <= "00";
        aluSrc	 <= '1';
        regWrite <= '1';
        PCorMem  <= '0';
        JRorADR  <= '0';
      when "000010" => -- j
        regDst	 <= "XX";
	    jump	 <= '1';
        branch	 <= 'X';        
        bne	 	 <= 'X';
        memWR	 <= 'X';
        memToReg <= 'X';
        aluOp	 <= "XX";
        aluSrc	 <= 'X';
        regWrite <= 'X';
        PCorMem  <= '0';
        JRorADR  <= '0';
      when "000011" => -- jal      
      	regDst	 <= "10";
	    jump	 <= '1';
        branch	 <= 'X';        
        bne	 	 <= 'X';
        memWR	 <= 'X';
        memToReg <= 'X';
        aluOp	 <= "XX";
        aluSrc	 <= 'X';
        regWrite <= '1';
        PCorMem  <= '1';
        JRorADR  <= '0';
	  when others =>
        regDst	 <= "XX";
	    jump	 <= 'X';
        branch	 <= 'X';
        bne	 	 <= 'X';
        memWR	 <= 'X';
        memToReg <= 'X';
        aluOp	 <= "XX";
        aluSrc	 <= 'X';
        regWrite <= '0';
        PCorMem  <= '0';
        JRorADR  <= '0';
    end case;	    
  end process;

end behavior;