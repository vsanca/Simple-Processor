----------------------------------------------------------------------------------
--Author: Viktor Šanca (viktor.sanca@gmail.com)

--Description: ALU
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity alu is
    Port ( iA : in  STD_LOGIC_VECTOR (15 downto 0);
           iB : in  STD_LOGIC_VECTOR (15 downto 0);
           iSEL : in  STD_LOGIC_VECTOR (3 downto 0);
           oC : out  STD_LOGIC_VECTOR (15 downto 0);
           oZERO : out  STD_LOGIC;
           oSIGN : out  STD_LOGIC;
           oCARRY : out  STD_LOGIC);
end alu;

architecture Behavioral of alu is
signal sC, sA, sB : STD_LOGIC_VECTOR (16 downto 0);

begin

sA<='0'&iA;
sB<='0'&iB;

process(iSEL,sA,sB,sC)begin

	case(iSEL)is
		when "0000" =>
			sC<=sA;
				
		when "0001" =>
			sC<=sA+sB;
			
		when "0010" =>
			sC<=sA-sB;
			
		when "0011" =>
			sC<=sA and sB;
			
		when "0100" =>
			sC<=sA or sB;
			
		when "0101" =>
			sC<=not(sA);
			
		when "0110" =>
			sC<=sA+1;
			
		when "0111" =>
			sC<=sA-1;
			
		when "1000" =>
			sC<=sA(15 downto 0)&'0';
				
		when "1001" =>
			sC<='0'&sA(16 downto 1);
				
		when "1010" =>
			sC<=sA(16 downto 15)&sA(13 downto 0)&'0';
			
		when "1011" =>
			sC<=sA(16 downto 15)&'0'&sA(14 downto 1);
		
		when others =>		--cmp iA iB - samo podesava status bite
			sC<=sA-sB;
			
	end case;

end process;

oC<=sC(15 downto 0);

oZERO<='1' when (sC=0) else '0';
oSIGN<=sC(15);
oCARRY<=sC(16);

end Behavioral;

