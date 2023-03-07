----------------------------------------------------------
-- Simple REGISTER          							--
-- Amaro			 (2023)								--
-- CEComp/Univasf										--
----------------------------------------------------------

library ieee ;
use ieee.std_logic_1164.all;

entity control is
  port(
    clock 		: in std_logic;
    reset 		: in std_logic;
    op			: in std_logic_vector(5 downto 0);
    irWrite		: out std_logic;
    aluSrcA		: out std_logic;
    aluSrcb		: out std_logic_vector(1 downto 0);
    aluOp		: out std_logic_vector(1 downto 0);
    iord		: out std_logic;
    memWrite	: out std_logic;
    memToReg	: out std_logic;
    regWrite	: out std_logic;
    regDst		: out std_logic;
    pcWrite		: out std_logic;
    pcWriteCond	: out std_logic;
    pcSource	: out std_logic_vector(1 downto 0);
    state		: out std_logic_Vector(3 downto 0);
  );
end control;

architecture behv of control is

  type FSM is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, s11);

  signal current_state, next_state: FSM;
  
begin

  process(clock, reset)
  begin
    if (falling_edge(reset)) then
	   current_state <= S0;
	 elsif (clock = '1' and clock'event) then
	   current_state <= next_state;
	 end if;    
  end process;
 
  process(current_state)
  begin
    case(current_state) is
      when S0 =>
        memWrite    <= '0';
        irwrite     <= '1';
        aluSrcA     <= '0';
        iord        <= '0';
        aluSrcB	    <= "01";
        aluOp       <= "00";
        pcWrite	    <= '1';
        pcSource    <= "00";
        pcwritecond <= '0';
        regdst	    <= 'X';
        memtoreg    <= 'X';
        regwrite    <= '0';
		state		<= "0000";
        next_state <= S1;
        
      when S1 =>
      	memWrite    <= 'X';
        irwrite     <= 'X';
        aluSrcA     <= '0';
        iord        <= 'X';
        aluSrcB	    <= "11";
        aluOp       <= "00";
        pcWrite	    <= 'X';
        pcSource    <= "XX";
        pcwritecond <= 'X';
        regdst	    <= 'X';
        memtoreg    <= 'X';
        regwrite    <= 'X';
      	state		<= "0001";
			
            case(op) is
            	when "000010" => --j
                	next_state <= S11;
                when "001000" => -- addi
                	next_state <= S9;
                when "000100" => -- beq
                	next_state <= S8;
                when "000000" => -- R type
                	next_state <= S6;
                when "100011" => -- lw
                	next_state <= S2;
                when "101011" => -- sw
                	next_state <= S2;
                when others =>
                	next_state <= S0;
            end case;
            
      when S2 =>
      	memWrite    <= 'X';
        irwrite     <= 'X';
        aluSrcA     <= '1';
        iord        <= 'X';
        aluSrcB	    <= "10";
        aluOp       <= "00";
        pcWrite	    <= 'X';
        pcSource    <= "XX";
        pcwritecond <= 'X';
        regdst	    <= 'X';
        memtoreg    <= 'X';
        regwrite    <= 'X';
        state		<= "0010";
        case(op) is
            	when "100011" => -- lw
                	next_state <= S3;
                when "101011" => -- sw
                	next_state <= S5;
                when others =>
                	next_state <= S0;
        end case;

      when S3 =>
      	memWrite    <= 'X';
        irwrite     <= 'X';
        aluSrcA     <= 'X';
        iord        <= '1';
        aluSrcB	    <= "XX";
        aluOp       <= "XX";
        pcWrite	    <= 'X';
        pcSource    <= "XX";
        pcwritecond <= 'X';
        regdst	    <= 'X';
        memtoreg    <= 'X';
        regwrite    <= 'X';
        state		<= "0011";
        next_state <= S4;

      when S4 =>
      	memWrite    <= 'X';
        irwrite     <= 'X';
        aluSrcA     <= 'X';
        iord        <= 'X';
        aluSrcB	    <= "XX";
        aluOp       <= "XX";
        pcWrite	    <= 'X';
        pcSource    <= "XX";
        pcwritecond <= 'X';
        regdst	    <= '0';
        memtoreg    <= '1';
        regwrite    <= '1';
        state		<= "0100";
        next_state <= S0;
        
      when S5 =>
		memWrite    <= '1';
        irwrite     <= 'X';
        aluSrcA     <= 'X';
        iord        <= '1';
        aluSrcB	    <= "XX";
        aluOp       <= "XX";
        pcWrite	    <= 'X';
        pcSource    <= "XX";
        pcwritecond <= 'X';
        regdst	    <= 'X';
        memtoreg    <= 'X';
        regwrite    <= 'X';
        state		<= "0101";
        next_state <= S0;
        
      when S6 =>
		memWrite    <= 'X';
        irwrite     <= 'X';
        aluSrcA     <= '1';
        iord        <= 'X';
        aluSrcB	    <= "00";
        aluOp       <= "10";
        pcWrite	    <= 'X';
        pcSource    <= "XX";
        pcwritecond <= 'X';
        regdst	    <= 'X';
        memtoreg    <= 'X';
        regwrite    <= 'X';
        state		<= "0110";
        next_state <= S7;
        
      when s7 =>
      	memWrite    <= 'X';
        irwrite     <= 'X';
        aluSrcA     <= 'X';
        iord        <= 'X';
        aluSrcB	    <= "XX";
        aluOp       <= "XX";
        pcWrite	    <= 'X';
        pcSource    <= "XX";
        pcwritecond <= 'X';
        regdst	    <= '1';
        memtoreg    <= '0';
        regwrite    <= '1';
        state		<= "0111";
        next_state <= S0;

      when s8 =>
      	memWrite    <= 'X';
        irwrite     <= 'X';
        aluSrcA     <= '1';
        iord        <= 'X';
        aluSrcB	    <= "00";
        aluOp       <= "10";
        pcWrite	    <= 'X';
        pcSource    <= "10";
        pcwritecond <= 'X';
        regdst	    <= 'X';
        memtoreg    <= 'X';
        regwrite    <= 'X';
        state		<= "1000";
        next_state <= S0;

      when s9 =>
      	memWrite    <= 'X';
        irwrite     <= 'X';
        aluSrcA     <= '1';
        iord        <= 'X';
        aluSrcB	    <= "10";
        aluOp       <= "00";
        pcWrite	    <= 'X';
        pcSource    <= "XX";
        pcwritecond <= 'X';
        regdst	    <= 'X';
        memtoreg    <= 'X';
        regwrite    <= 'X';
        state		<= "1001";
        next_state <= S10;

      when s10 =>
      	memWrite    <= 'X';
        irwrite     <= 'X';
        aluSrcA     <= 'X';
        iord        <= 'X';
        aluSrcB	    <= "XX";
        aluOp       <= "XX";
        pcWrite	    <= 'X';
        pcSource    <= "XX";
        pcwritecond <= 'X';
        regdst	    <= '0';
        memtoreg    <= '0';
        regwrite    <= '1';
        state		<= "1010";
        next_state <= S0;

      when S11 =>
      	memWrite    <= 'X';
        irwrite     <= 'X';
        aluSrcA     <= 'X';
        iord        <= 'X';
        aluSrcB	    <= "XX";
        aluOp       <= "XX";
        pcWrite	    <= '1';
        pcSource    <= "10";
        pcwritecond <= 'X';
        regdst	    <= 'X';
        memtoreg    <= 'X';
        regwrite    <= 'X';
        state		<= "1010";
        next_state <= S0;
        
    end case;
  end process;   
end behv;