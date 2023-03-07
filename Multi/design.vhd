----------------------------------------------------------
-- Multicycle Processor         						--
-- Amaro			 (2023)								--
-- CEComp/Univasf										--
----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity myMIPS is
  port(
    clk   : in std_logic;
    rst   : in std_logic
  );
end myMIPS;

architecture behv of myMIPS is

  signal wireEIMM, wireRESULT, wireDATAOUT, wireDMUX5, wireDMUX6, wireMemDataREG, wireAluOutREG, wireBREG, wireAREG, wireAdress, wireJumpAddr : std_logic_vector(31 downto 0);
  signal wireBRANCH, wireBNE, wireMEMWR, wireZERO, wirePCorMem: std_logic;
  signal wireWR	: std_logic_vector(4 downto 0);
  signal wireOPER 						: std_logic_vector(2 downto 0);
   --pc
  signal wireE : std_logic;
  signal wireD, wirePC : std_logic_vector(31 downto 0);
  
  --register
    signal wireRD1		: std_logic_vector(31 downto 0);
	signal wireRD2	: std_logic_vector(31 downto 0);
  
  --decoder reg
	signal wireRS		:  std_logic_vector(4 downto 0); 	
	signal wireRT		:  std_logic_vector(4 downto 0); 	
	signal wireRD		:  std_logic_vector(4 downto 0); 	
	signal wireSHAMT	:  std_logic_vector(4 downto 0); 	
	signal wireFUNCT	:  std_logic_vector(5 downto 0); 	
	signal wireIMM	    :  std_logic_vector(15 downto 0); 
	signal wireADDR		:  std_logic_vector(25 downto 0);
  
  --control
  	signal wireOP		: std_logic_vector(5 downto 0);
    signal wireIRWrite	: std_logic;
    signal wireALUsrcA	: std_logic;
    signal wireALUsrcB	: std_logic_vector(1 downto 0);
    signal wireALUop	: std_logic_vector(1 downto 0);
    signal wireIorD		: std_logic;
    signal wireMemWrite	: std_logic;
    signal wireMemToReg	: std_logic;
    signal wireRegWrite	: std_logic;
    signal wireRegDst	: std_logic;
    signal wirePcWrite	: std_logic;
    signal wirePcWriteCond	: std_logic;
    signal wirePcSource	: std_logic_vector(1 downto 0);
    ----- verificando estado
    signal wireState	: std_logic_vector(3 downto 0);
    
  -- MUX outs
  signal wireALUa : std_logic_vector(31 downto 0);
  signal wireALUb : std_logic_vector(31 downto 0);
begin
  PC : entity work.rereg32 port map (
    clk		=> clk,
    rst		=> rst,
    e		=> (wireZERO and wirePcWriteCond) or wirePcWrite,
    d		=> wireD,
    q		=> wirePC
  );
  
  MUXPCorALU:  entity work.mux232 port map (
    d0 => wirePC,
    d1 => wireAluOutREG, 
    s =>  wireIorD,
    y =>  wireAdress
  );
  
  
  DECODER: entity work.idecoder port map (
    i 		=> wireDATAOUT,
    irwrite => wireIRWrite,
	op  	=> wireOP,
	rs		=> wireRS,
	rt		=> wireRT,
	rd		=> wireRD,
	shamt	=> wireSHAMT,
	funct	=> wireFUNCT,
	imm		=> wireIMM,
	addr	=> wireADDR
  );
  
  MUX1: entity work.mux25 port map (
    d0 => wireRT, 
    d1 => wireRD,
    s => wireRegDst, 
    y => wireWR);
    
  REGS: entity work.registers  port map (
    clock => clk,
    reset => rst,
    rr1 => wireRS, 
    rr2 => wireRT, 
    rw => wireRegWrite, 
  	wr => wireWR, 
    wd => wireDMUX5, 
    rd1 => wireRD1, 
    rd2 => wireRD2
  );
  
  SGEXT: entity work.signExtend port map (
    dataIn => wireIMM, 
    dataOut => wireEIMM);
    
  MUXaluB:  entity work.mux432 port map (
    d0 => wireBREG, 
    d1 => x"00000004",
    d2 => wireEIMM,
    d3 => wireEIMM sll 2,
    s  => wireALUsrcB,
    y => wireALUb
  );
  
  MUXaluA: entity work.mux232 port map(
  	d0 => wirePC, 
    d1 => wireAREG,
    s  => wireALUsrcA,
    y  => wireALUa
  );
  
  CTRL: entity work.control port map (
    clock		=> clk,
    reset		=> rst,
    op			=> wireOP,	
    irWrite		=> wireIRWrite,
    aluSrcA		=> wireALUsrcA,	
    aluSrcb		=> wireALUsrcB,	
    aluOp		=> wireALUop,	
    iord		=> wireIorD,		
    memWrite	=> wireMemWrite,	
    memToReg	=> wireMemToReg,	
    regWrite	=> wireRegWrite,	
    regDst		=> wireRegDst,	
    pcWrite		=> wirePcWrite,	
    pcWriteCond	=> wirePcWriteCond,	
    pcSource	=> wirePcSource,
    state		=> wireState
  );
  
  ALUCTRL: entity work.alucontrol port map (
    aluop => wireALUop, 
    ff => wireFUNCT,
    oper => wireOPER
  );
  
  ALU32: entity work.alu port map (
    rega	=> wireALUa,
    regb	=> wireALUb,
    oper	=> wireOPER,
	result 	=> wireRESULT,
    zero 	=> wireZERO
  );
  
  JUMPER: entity work.jumper port map (
    addr => wireADDR,
    pc => wirePC,
    jumpaddr => wireJumpAddr
  );
  
  MUXALU: entity work.mux332 port map(
  	d0		=> wireRESULT,
    d1		=> wireAluOutREG,
    d2		=> wireJumpAddr,
    s		=> wirePcSource,
    y		=> wireD
  );

---RAM MODIFICADA PARA MULTICICLO--------
  RAM: entity work.ram port map (
  	clock		=> clk,
    reset		=> rst,
    datain => wireBREG, --regRD2
    address => wireAdress, 
    -- write when 1, read when 0
    w_r => wireMemWrite,
    dataout => wireDATAOUT
  );
  
  memDataREG: entity work.simpleREG port map(
  	clock => clk,
  	i	=> wireDATAOUT,
    o 	=> wireMemDataREG 
  );
  
  aREG: entity work.simpleREG port map(
  	clock => clk,
    i	=> wireRD1,
    o 	=> wireAREG 
  );
  
  bREG: entity work.simpleREG port map(
  	clock => clk,
    i	=> wireRD2,
    o 	=> wireBREG 
  );
  
  aluOutREG: entity work.simpleREG port map(
  	clock => clk,
    i	=> wireRESULT,
    o	=> wireAluOutREG
  );
  
  MUX5:  entity work.mux232 port map (
    d0 => wireAluOutREG, 
    d1 => wireMemDataREG, 
    s => wireMemToReg, 
    y => wireDMUX5
  );
  
   
end architecture behv;  