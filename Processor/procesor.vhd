----------------------------------------------------------------------------------
--Author: Viktor Šanca (viktor.sanca@gmail.com)

--Description: Processor top level 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity procesor is
    Port ( iCLK : in  STD_LOGIC;
           inRST : in  STD_LOGIC;
			  iINSTR : in STD_LOGIC_VECTOR (14 downto 0);
           iDATA : in  STD_LOGIC_VECTOR (15 downto 0);
           oPC : out STD_LOGIC_VECTOR (15 downto 0);
			  oDATA : out  STD_LOGIC_VECTOR (15 downto 0);
			  oADDR : out STD_LOGIC_VECTOR (15 downto 0);
			  
			  oREG0 : out STD_LOGIC_VECTOR(15 downto 0);
			  oREG1 : out STD_LOGIC_VECTOR(15 downto 0);
			  oREG2 : out STD_LOGIC_VECTOR(15 downto 0);
			  oREG3 : out STD_LOGIC_VECTOR(15 downto 0);
			  oREG4 : out STD_LOGIC_VECTOR(15 downto 0);
			  oREG5 : out STD_LOGIC_VECTOR(15 downto 0);
			  oREG6 : out STD_LOGIC_VECTOR(15 downto 0);
			  oREG7 : out STD_LOGIC_VECTOR(15 downto 0);
			  
			  oMEM_WE : out STD_LOGIC;
			  oPHASE : out STD_LOGIC_VECTOR(1 downto 0));
end procesor;

architecture Behavioral of procesor is

------------------------------------------
--deklaracija komponenti:
------------------------------------------

--registar:
component reg is
Port ( iCLK : in  STD_LOGIC;
       inRST : in  STD_LOGIC;
       iD : in  STD_LOGIC_VECTOR (15 downto 0);
       iWE : in  STD_LOGIC;
       oQ : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

--mux:
component MUX is
Port ( iD0 : in  STD_LOGIC_VECTOR (15 downto 0);
       iD1 : in  STD_LOGIC_VECTOR (15 downto 0);
       iD2 : in  STD_LOGIC_VECTOR (15 downto 0);
       iD3 : in  STD_LOGIC_VECTOR (15 downto 0);
       iD4 : in  STD_LOGIC_VECTOR (15 downto 0);
       iD5 : in  STD_LOGIC_VECTOR (15 downto 0);
       iD6 : in  STD_LOGIC_VECTOR (15 downto 0);
       iD7 : in  STD_LOGIC_VECTOR (15 downto 0);
       iD8 : in  STD_LOGIC_VECTOR (15 downto 0);
       iSEL : in  STD_LOGIC_VECTOR (3 downto 0);
       oQ : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

--alu:
component ALU is
Port ( iA : in  STD_LOGIC_VECTOR (15 downto 0);
       iB : in  STD_LOGIC_VECTOR (15 downto 0);
       iSEL : in  STD_LOGIC_VECTOR (3 downto 0);
       oC : out  STD_LOGIC_VECTOR (15 downto 0);
       oZERO : out  STD_LOGIC;
       oSIGN : out  STD_LOGIC;
       oCARRY : out  STD_LOGIC);
end component;

--brojac:
component CNT is
Port (iCLK : in  STD_LOGIC;
      inRST : in  STD_LOGIC;
      iD : in  STD_LOGIC_VECTOR (15 downto 0);
      iEN : in  STD_LOGIC;
      iLOAD : in  STD_LOGIC;
      oQ : out  STD_LOGIC_VECTOR (15 downto 0)
);
end component;

--control unit:
component control_unit is
Port (  iCLK : in  STD_LOGIC;
		  inRST : in  STD_LOGIC;
		  iIR : in  STD_LOGIC_VECTOR (14 downto 0);
		  iZERO : in  STD_LOGIC;
		  iSIGN : in  STD_LOGIC;
		  iCARRY : in  STD_LOGIC;
		  oPC_EN : out  STD_LOGIC;
		  oPC_LOAD : out  STD_LOGIC;
		  oREG_WE : out  STD_LOGIC_VECTOR (7 downto 0);
		  oA_WE : out  STD_LOGIC;
		  oB_WE : out  STD_LOGIC;
		  oC_WE : out  STD_LOGIC;
		  oIR_WE : out  STD_LOGIC;
		  oPC_IN : out  STD_LOGIC_VECTOR (15 downto 0);
		  oMUXA_SEL : out  STD_LOGIC_VECTOR (3 downto 0);
		  oMUXB_SEL : out  STD_LOGIC_VECTOR (3 downto 0);
		  oALU_SEL : out  STD_LOGIC_VECTOR (3 downto 0);
		  oMEM_WE : out  STD_LOGIC;
		  
		  oCMP : out STD_LOGIC;
		  
		  oPHASE : out STD_LOGIC_VECTOR(1 downto 0));
end component;

------------------------------------------
--signali:
------------------------------------------
--top level:

--registri:
signal sR0, sR1, sR2, sR3, sR4, sR5, sR6, sR7, sA, sB, sC, sDATA : STD_LOGIC_VECTOR(15 downto 0);
signal sREG_WE : STD_LOGIC_VECTOR(7 downto 0);
signal sC_WE, sA_WE, sB_WE : STD_LOGIC;

--mux:
signal sMUXA, sMUXB : STD_LOGIC_VECTOR(15 downto 0);
signal sMUXA_SEL, sMUXB_SEL : STD_LOGIC_VECTOR(3 downto 0);

--alu:
signal sRESULT : STD_LOGIC_VECTOR(15 downto 0);
signal sALU_SEL : STD_LOGIC_VECTOR(3 downto 0);
signal sOZERO, sOSIGN, sOCARRY : STD_LOGIC;

--zsc:
signal sZERO, sSIGN, sCARRY : STD_LOGIC;

--pc:
signal sPC_IN, sPC_OUT : STD_LOGIC_VECTOR(15 downto 0);
signal sPC_EN, sPC_LOAD : STD_LOGIC;

--ir:
signal sIR, sINSTR : STD_LOGIC_VECTOR(15 downto 0);
signal sIR_WE : STD_LOGIC;

--control unit:
signal sMEM_WE : STD_LOGIC;

signal sCMP : STD_LOGIC;

------------------------------------------
begin

------------------------------------------
--instanciranje komponenti:
------------------------------------------

--registri:
R0: reg port map(
	iCLK=>iCLK,
	inRST=>inRST,
	iD=>sDATA,
	iWE=>sREG_WE(0),
	oQ=>sR0
);

R1: reg port map(
	iCLK=>iCLK,
	inRST=>inRST,
	iD=>sDATA,
	iWE=>sREG_WE(1),
	oQ=>sR1
);

R2: reg port map(
	iCLK=>iCLK,
	inRST=>inRST,
	iD=>sDATA,
	iWE=>sREG_WE(2),
	oQ=>sR2
);

R3: reg port map(
	iCLK=>iCLK,
	inRST=>inRST,
	iD=>sDATA,
	iWE=>sREG_WE(3),
	oQ=>sR3
);

R4: reg port map(
	iCLK=>iCLK,
	inRST=>inRST,
	iD=>sDATA,
	iWE=>sREG_WE(4),
	oQ=>sR4
);

R5: reg port map(
	iCLK=>iCLK,
	inRST=>inRST,
	iD=>sDATA,
	iWE=>sREG_WE(5),
	oQ=>sR5
);

R6: reg port map(
	iCLK=>iCLK,
	inRST=>inRST,
	iD=>sDATA,
	iWE=>sREG_WE(6),
	oQ=>sR6
);

R7: reg port map(
	iCLK=>iCLK,
	inRST=>inRST,
	iD=>sDATA,
	iWE=>sREG_WE(7),
	oQ=>sR7
);

A: reg port map(
	iCLK=>iCLK,
	inRST=>inRST,
	iD=>sMUXA,
	iWE=>sA_WE,
	oQ=>sA
);

B: reg port map(
	iCLK=>iCLK,
	inRST=>inRST,
	iD=>sMUXB,
	iWE=>sB_WE,
	oQ=>sB
);

C: reg port map(
	iCLK=>iCLK,
	inRST=>inRST,
	iD=>sRESULT,
	iWE=>sC_WE,
	oQ=>sDATA
);

IR: reg port map(
	iCLK=>iCLK,
	inRST=>inRST,
	iD=>sINSTR,
	iWE=>sIR_WE,
	oQ=>sIR
);

sINSTR<='0'&iINSTR;

--mux:
MUXA: MUX port map(
	iD0=> sR0,
   iD1=> sR1,
   iD2=> sR2,
   iD3=> sR3,
	iD4=> sR4,
	iD5=> sR5,
	iD6=> sR6,
	iD7=> sR7,
	iD8=> iDATA,
   iSEL=> sMUXA_SEL,
   oQ=> sMUXA
);

MUXB: MUX port map(
	iD0=> sR0,
   iD1=> sR1,
   iD2=> sR2,
   iD3=> sR3,
	iD4=> sR4,
	iD5=> sR5,
	iD6=> sR6,
	iD7=> sR7,
	iD8=> iDATA,
   iSEL=> sMUXB_SEL,
   oQ=> sMUXB
);

--alu:

ALU1: ALU port map(
	iA=>sA,
	iB=>sB,
	iSEL=>sALU_SEL,
	oC=>sRESULT,
	oZERO=>sOZERO,
	oSIGN=>sOSIGN,
	oCARRY=>sOCARRY
);

--zsc flip flopovi:

process(iCLK)begin
	if(iCLK'event and iCLK='1')then
		if(inRST='0')then
			sZERO<='0';
			sSIGN<='0';
			sCARRY<='0';
		else
			if(sC_WE='1')then
				sZERO<=sOZERO;
				sSIGN<=sOSIGN;
				sCARRY<=sOCARRY;
			elsif(sCMP='1')then
				sZERO<=sOZERO;
				sSIGN<=sOSIGN;
				sCARRY<=sOCARRY;
			end if;	
		end if;
	end if;
end process;

--brojac:

PC: CNT port map(
	iCLK=>iCLK,
	inRST=>inRST,
	iD=>sPC_IN,
	iEN=>sPC_EN,
	iLOAD=>sPC_LOAD,
	oQ=>sPC_OUT
);

--control unit:

CU: control_unit port map(
	iCLK=>iCLK,
	inRST=>inRST,
	iIR=>sIR(14 downto 0),
	iZERO=>sZERO,
	iSIGN=>sSIGN,
	iCARRY=>sCARRY,
	oPC_EN=>sPC_EN,
	oPC_LOAD=>sPC_LOAD,
	oREG_WE=>sREG_WE,
	oA_WE=>sA_WE,
	oB_WE=>sB_WE,
	oC_WE=>sC_WE,
	oIR_WE=>sIR_WE,
	oPC_IN=>sPC_IN,
	oMUXA_SEL=>sMUXA_SEL,
	oMUXB_SEL=>sMUXB_SEL,
	oALU_SEL=>sALU_SEL,
	oMEM_WE=>sMEM_WE,
	
	oCMP=>sCMP,
	
	oPHASE=>oPHASE
);

------------------------------------------
--prevezivanje signala:
------------------------------------------

oDATA<=sDATA;	
oPC<=sPC_OUT;
oMEM_WE<=sMEM_WE;
oADDR<=sMUXB;

oREG0<=sR0;
oREG1<=sR1;
oREG2<=sR2;
oREG3<=sR3;
oREG4<=sR4;
oREG5<=sR5;
oREG6<=sR6;
oREG7<=sR7;

end Behavioral;

