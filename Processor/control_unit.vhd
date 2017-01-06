----------------------------------------------------------------------------------
--Author: Viktor Šanca (viktor.sanca@gmail.com)

--Description: Control Unit
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity control_unit is
    Port ( iCLK : in  STD_LOGIC;
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
end control_unit;

architecture Behavioral of control_unit is

type tCU is (FETCH, DECODE, EXECUTE, WRITE_BACK);
signal sCU : tCU;
signal sMEM_WE, sA_WE, sB_WE, sC_WE, sIR_WE, sPC_LOAD, sPC_EN, sCARRY, sSIGN, sZERO, sPC_LOAD1 : STD_LOGIC;
signal sMUXA_SEL, sMUXB_SEL, sALU_SEL, sMUXA_SEL1, sALU_SEL1 : STD_LOGIC_VECTOR(3 downto 0);
signal sREG_WE, sREG_WE_Z : STD_LOGIC_VECTOR(7 downto 0);
signal sIR : STD_LOGIC_VECTOR(14 downto 0);
signal sPC_IN : STD_LOGIC_VECTOR(15 downto 0);

signal sCMP : STD_LOGIC;

begin

--prevezivanje signala:
--ulazi:
sIR<=iIR;
sZERO<=iZERO;
sSIGN<=iSIGN;
sCARRY<=iCARRY;

oCMP<=sCMP;


--izlazi:
oPC_EN<=sPC_EN;
oPC_LOAD<=sPC_LOAD;
oREG_WE<=sREG_WE;
oA_WE<=sA_WE;
oB_WE<=sB_WE;
oC_WE<=sC_WE;
oIR_WE<=sIR_WE;
oPC_IN<=sPC_IN;
oMUXA_SEL<=sMUXA_SEL;
oMUXB_SEL<=sMUXB_SEL;
oALU_SEL<=sALU_SEL;
oMEM_WE<=sMEM_WE;

process(iCLK)begin
	if(iCLK'event and iCLK='1')then
		if(inRST='0')then
			--pocetno stanje:
			sCU<=FETCH;
		else
			--automat:
			case(sCU)is
				when FETCH=>
					sCU<=DECODE;
				when DECODE=>
					sCU<=EXECUTE;
				when EXECUTE=>
					sCU<=WRITE_BACK;
				when others=>
					sCU<=FETCH;
			end case;
			
		end if;
	end if;
end process;



--------------------------------------
process(sCU,sIR,sALU_SEL1, sMUXA_SEL, sPC_LOAD1, sREG_WE_Z, sMUXA_SEL1)begin

	case(sCU)is
		when FETCH=>
			sMEM_WE<='0';
			sA_WE<='0';
			sB_WE<='0';
			sC_WE<='0';
			sIR_WE<='1';
			sPC_LOAD<='0';
			sPC_EN<='0';

			sMUXA_SEL<=(others=>'0');
			sMUXB_SEL<=(others=>'0');
			sALU_SEL<=(others=>'0');
			sREG_WE<=(others=>'0');
			sPC_IN<=(others=>'0');
			
			sCMP<='0';
			
		when DECODE=>
			sMEM_WE<='0';
			----------------------------------
			if(sIR(14 downto 13)="01")then
				sA_WE<='0';--
				sB_WE<='0';--
			else
				sA_WE<='1';
				sB_WE<='1';
			end if;
			----------------------------------
			sC_WE<='0';
			sIR_WE<='0';
			sPC_LOAD<='0';
			sPC_EN<='0';
			
			if(sIR(14 downto 9)="100000" or sIR(14 downto 9)="100001")then		--
				sMUXA_SEL<="1000";
			else
				sMUXA_SEL<='0'&sIR(5 downto 3);
			end if;
			
			
			sMUXB_SEL<='0'&sIR(2 downto 0);
			
			sALU_SEL<=(others=>'0');
			sREG_WE<=(others=>'0');
			sPC_IN<=(others=>'0');
			
			sCMP<='0';
			
		when EXECUTE=>
			sMEM_WE<='0';
			sA_WE<='0';
			sB_WE<='0';
			if(sIR(14 downto 9)="001100" or sIR(14 downto 13)="01")then	
				sC_WE<='0';
			else
				sC_WE<='1';
			end if;
			sIR_WE<='0';
			sPC_LOAD<='0';
			sPC_EN<='0';
			
			
			sALU_SEL<=sALU_SEL1;
			sREG_WE<=(others=>'0');
			
			sPC_IN<=(others=>'0');
			
			if(sIR(14)='1' and sIR(9)='0')then
				sMUXB_SEL<='0'&sIR(2 downto 0);
				sMUXA_SEL<=sMUXA_SEL1;
			else
				sMUXB_SEL<=(others=>'0');
				sMUXA_SEL<=(others=>'0');
			end if;
		
			if(sIR(14 downto 9)="001100")then
				sCMP<='1';
			else 
				sCMP<='0';
			end if;
			
		when others=>
			if(sIR(14 downto 9)="110000")then
				sMEM_WE<='1';
			else
				sMEM_WE<='0';		
			end if;
			
			sA_WE<='0';
			sB_WE<='0';
			sC_WE<='0';
			sIR_WE<='0';
			sPC_LOAD<=sPC_LOAD1;
			sPC_EN<='1';
			
			sALU_SEL<=(others=>'0');
			sREG_WE<=sREG_WE_Z;
			sPC_IN<="0000000"&sIR(8 downto 0);--
			
			if(sIR(14)='1' and sIR(9)='0')then
				sMUXA_SEL<=sMUXA_SEL1;
				sMUXB_SEL<='0'&sIR(2 downto 0);
			else
				sMUXA_SEL<=(others=>'0');
				sMUXB_SEL<=(others=>'0');
			end if;
			
			sCMP<='0';
			
	end case;

end process;
--------------------------------------

--------------------------------------
----instrukcije:
--------------------------------------
--process(sIR(14 downto 9),sZERO,sSIGN,sCARRY)begin
process(iCLK)begin
if(iCLK'event and iCLK='1')then

	case(sIR(14 downto 9))is
		when "010000"=>
			sPC_LOAD1<='1';
			
		when "010001"=>
			if(sZERO='1')then
				sPC_LOAD1<='1';
			else
				sPC_LOAD1<='0';
			end if;
		when "010010"=>
			if(sSIGN='1')then
				sPC_LOAD1<='1';
			else
				sPC_LOAD1<='0';
			end if;
		when "010011"=>
			if(sCARRY='1')then
				sPC_LOAD1<='1';
			else
				sPC_LOAD1<='0';
			end if;
		when "010101"=> 			---------------
			if(sZERO='0')then
				sPC_LOAD1<='1';
			else
				sPC_LOAD1<='0';
			end if;
		when "010110"=>
			if(sSIGN='0')then
				sPC_LOAD1<='1';
			else
				sPC_LOAD1<='0';
			end if;
		when "010111"=>
			if(sCARRY='0')then
				sPC_LOAD1<='1';
			else
				sPC_LOAD1<='0';
			end if;
		when others=>
			sPC_LOAD1<='0';
	end case;
end if;
end process;

--alu selekcija u zavisnosti od instrukcije:
sALU_SEL1<=sIR(12 downto 9) when (sIR(14 downto 13)="00") else "0000"; 	

--mux selekcija u zavisnosti od instrukcije:
sMUXA_SEL1<="1000" when(sIR(14 downto 9)="100000" or sIR(14 downto 13)="01" or sIR(14 downto 9)="100001") else '0'&sIR(5 downto 3);
--------------------------------------

--------------------------------------
--izbor registra Z
--------------------------------------
process(sIR)begin
	if(sIR(14 downto 13)="00" or sIR(14 downto 13)="10")then
		if(sIR(14 downto 9)="001100")then
			sREG_WE_Z<="00000000";
		else
			case(sIR(8 downto 6))is
			when "000"=>
				sREG_WE_Z<="00000001";
			when "001"=>
				sREG_WE_Z<="00000010";
			when "010"=>
				sREG_WE_Z<="00000100";
			when "011"=>
				sREG_WE_Z<="00001000";
			when "100"=>
				sREG_WE_Z<="00010000";
			when "101"=>
				sREG_WE_Z<="00100000";
			when "110"=>
				sREG_WE_Z<="01000000";
			when others=>
				sREG_WE_Z<="10000000";
		end case;
		end if;
	else
		sREG_WE_Z<="00000000";
	end if;
end process;

oPHASE<="00" when (sCU=FETCH) else "01" when (sCU=DECODE) else "10" when (sCU=EXECUTE) else "11";

end Behavioral;

