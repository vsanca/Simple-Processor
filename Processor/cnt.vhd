----------------------------------------------------------------------------------
--Author: Viktor Šanca (viktor.sanca@gmail.com)

--Description: Counter
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity cnt is
    Port ( iCLK : in  STD_LOGIC;
           inRST : in  STD_LOGIC;
           iD : in  STD_LOGIC_VECTOR (15 downto 0);
           iEN : in  STD_LOGIC;
           iLOAD : in  STD_LOGIC;
           oQ : out  STD_LOGIC_VECTOR (15 downto 0));
end cnt;

architecture Behavioral of cnt is

signal sCNT : STD_LOGIC_VECTOR(15 downto 0);

begin

process(iCLK)begin
	if(iCLK'event and iCLK='1')then
		if(inRST='0')then
			sCNT<=(others=>'0');
		else
			if(iEN='1')then
				if(iLOAD='1')then
					sCNT<=iD;
				else
					sCNT<=sCNT+1;
				end if;
			end if;
		end if;
	end if;
end process;

oQ<=sCNT;

end Behavioral;

