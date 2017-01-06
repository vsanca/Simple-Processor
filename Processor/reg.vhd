----------------------------------------------------------------------------------
--Author: Viktor Šanca (viktor.sanca@gmail.com)

--Description: Register
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
    Port ( iCLK : in  STD_LOGIC;
           inRST : in  STD_LOGIC;
           iD : in  STD_LOGIC_VECTOR (15 downto 0);
           iWE : in  STD_LOGIC;
           oQ : out  STD_LOGIC_VECTOR (15 downto 0));
end reg;

architecture Behavioral of reg is
	signal sREG : STD_LOGIC_VECTOR(15 downto 0);
begin

process(iCLK)begin
	if(iCLK'event and iCLK='1')then
		if(inRST='0')then
			sREG<=(others=>'0');
		else
			if(iWE='1')then
				sREG<=iD;
			end if;
		end if;
	end if;
end process;

oQ<=sREG;

end Behavioral;

