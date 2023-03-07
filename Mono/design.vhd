------------------------------------------------------------------
-- myMIPS Design                               					--
--                                      						--
-- Prof. Max Santana  (2022)            						--
-- CEComp/Univasf                 								--
-- www.mymips.univasf.edu.br 									--
------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity myMIPS is
  port(
    clk   : in std_logic;
    rst   : in std_logic
  );
end myMIPS;

architecture behv of myMIPS is

  signal wireD, wireQ, wireOUT, wireWD, wireRD1, 
         wireRD2, wireEIMM, wireBALU, wireRESULT,
         wireJumpAddr, wireOutAdder2, wireTemp,
         wireOutBranch, wirePC, wireAdder2, wireDMUX3, wireDMUX4, wireDATAOUT, wireDMUX5, wireDMUX6 : std_logic_vector(31 downto 0);
  signal wireclk, wireRst, wireREGWRITE, 
         wireALUSRC, wireJUMP, wireBRANCH, wireBNE,
         wireMEMWR, wireMEMTOREG, wireZERO, wirePCorMem, wireJRorADR	: std_logic;
  signal wireOP, wireFUNCT							: std_logic_vector(5 downto 0);
  signal wireRS, wireRT, wireRD, wireSHAMT, wireWR	: std_logic_vector(4 downto 0);
  signal wireIMM 									: std_logic_vector(15 downto 0);
  signal wireADDR									: std_logic_vector(25 downto 0);
  signal wireALUOP, wireREGDST						: std_logic_vector(1 downto 0);
  signal wireOPER									: std_logic_vector(2 downto 0);
begin
  PC : entity work.rreg32 port map (
    clk => clk, 
    rst => rst, 
    d => wireD, 
    q => wireQ
  );
  ADDER1: entity work.adder32 port map (
    a => wireQ,
    b => x"00000004",
    s => wirePC
  );
  
  ADDER2: entity work.adder32 port map (
    a => wirePC,
    b => wireEIMM sll 2,
    s => wireAdder2
  );
  
  MUX3:  entity work.mux232 port map (
    d0 => wirePC, 
    d1 => wireAdder2, 
    s => (wireBRANCH and wireZERO) or (wireBNE and not wireZERO),
    y => wireDMUX3
  );
  
  JUMPER: entity work.jumper port map (
    addr => wireADDR,
    pc => wirePC,
    jumpaddr => wireJumpAddr
  );
  
  MUX4:  entity work.mux232 port map (
    d0 => wireDMUX3, 
    d1 => wireJumpAddr, 
    s => wireJump,
    y => wireDMUX4
  );
  
  MUX7:  entity work.mux232 port map (
  	d0 => wireDMUX4, 
    d1 => wireRD1, 
    s => wireJRorADR,
    y => wireD
  );
  
  IMEMORY: entity work.rom port map (
    address => wireQ,
    data_out => wireOUT
  );
  
  DECODER: entity work.idecoder port map (
    i 		=> wireOUT,
	op  	=> wireOP,
	rs		=> wireRS,
	rt		=> wireRT,
	rd		=> wireRD,
	shamt	=> wireSHAMT,
	funct	=> wireFUNCT,
	imm		=> wireIMM,
	addr	=> wireADDR
  );
  MUX1: entity work.mux35 port map (
    d0 => wireRT, 
    d1 => wireRD,
    d2 => "11111",
    s => wireREGDST, 
    y => wireWR);
  REGS: entity work.registers  port map (
    clock => clk,
    reset => rst,
    rr1 => wireRS, 
    rr2 => wireRT, 
    rw => wireREGWRITE, 
  	wr => wireWR, 
    wd => wireDMUX6, 
    rd1 => wireRD1, 
    rd2 => wireRD2
  );
  SGEXT: entity work.signExtend port map (
    dataIn => wireIMM, 
    dataOut => wireEIMM);
  MUX2:  entity work.mux232 port map (
    d0 => wireRD2, 
    d1 => wireEIMM, 
    s => wireALUSRC, 
    y => wireBALU
  );
  CTRL: entity work.control port map (
    func        => wireFUNCT,
    op			=> wireOP,
	regDst	 	=> wireREGDST,
	jump	 	=> wirejump,
    branch	 	=> wireBRANCH,
    bne		 	=> wireBNE,
    memWR	 	=> wireMEMWR,
    memToReg 	=> wireMEMTOREG,
    aluOp	 	=> wireALUOP,
    aluSrc	 	=> wireALUSRC,
    regWrite 	=> wireREGWRITE,
    PCorMem     => wirePCorMem,
    JRorADR     => wireJRorADR
  );
  
  ALUCTRL: entity work.alucontrol port map (
    aluop => wireALUOP, 
    ff => wireFUNCT,
    oper => wireOPER
  );
  ALU32: entity work.alu port map (
    rega	=> wireRD1,
    regb	=> wireBALU,
    oper	=> wireOPER,
	result 	=> wireRESULT,
    zero 	=> wireZERO
  );
  
  RAM: entity work.ram port map (
    datain => wireRD2,
    address => wireRESULT,
    -- write when 0, read when 1
    w_r => wireMEMWR,
    dataout => wireDATAOUT
  );
  MUX5:  entity work.mux232 port map (
    d0 => wireRESULT, 
    d1 => wireDATAOUT, 
    s => wireMEMTOREG, 
    y => wireDMUX5
  );
  MUX6: entity work.mux232 port map (
  	d0 => wireDMUX5,
    d1 => wirePC,
    s => wirePCorMem,
    y => wireDMUX6
  );
   
end architecture behv;  