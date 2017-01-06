----------------------------------------------------------------------------------
--Author: Viktor Šanca (viktor.sanca@gmail.com)

--Description: Data RAM
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity data_ram is
    Port ( iCLK : in  STD_LOGIC;
           inRST : in  STD_LOGIC;
           iA : in  STD_LOGIC_VECTOR (4 downto 0);
           iD : in  STD_LOGIC_VECTOR (15 downto 0);
           iWE : in  STD_LOGIC;
           oQ : out  STD_LOGIC_VECTOR (15 downto 0));
end data_ram;

architecture Behavioral of data_ram is

type tRAM is array (0 to 31) of STD_LOGIC_VECTOR(15 downto 0);
signal sRAM : tRAM;

begin

process(iCLK)begin
	if(iCLK'event and iCLK='1')then
		if(inRST='0')then
			sRAM(0)<="0000000000000011";					------konstanta N
			--sRAM(0)<=(others=>'0');
			sRAM(1)<=(others=>'0');
			sRAM(2)<=(others=>'0');
			sRAM(3)<=(others=>'0');
			sRAM(4)<=(others=>'0');
			sRAM(5)<=(others=>'0');
			sRAM(6)<=(others=>'0');
			sRAM(7)<=(others=>'0');
			sRAM(8)<=(others=>'0');
			sRAM(9)<=(others=>'0');
			sRAM(10)<=(others=>'0');
			sRAM(11)<=(others=>'0');
			sRAM(12)<=(others=>'0');
			sRAM(13)<=(others=>'0');
			sRAM(14)<=(others=>'0');
			sRAM(15)<=(others=>'0');
			sRAM(16)<=(others=>'0');
			sRAM(17)<=(others=>'0');
			sRAM(18)<=(others=>'0');
			sRAM(19)<=(others=>'0');
			sRAM(20)<=(others=>'0');
			sRAM(21)<=(others=>'0');
			sRAM(22)<=(others=>'0');
			sRAM(23)<=(others=>'0');
			sRAM(24)<=(others=>'0');
			sRAM(25)<=(others=>'0');
			sRAM(26)<=(others=>'0');
			sRAM(27)<=(others=>'0');
			sRAM(28)<=(others=>'0');
			sRAM(29)<=(others=>'0');
			sRAM(30)<=(others=>'0');
			sRAM(31)<=(others=>'0');
			
		else
			if(iWE='1')then
				sRAM(conv_integer(iA))<=iD;
			end if;
		end if;
	end if;
end process;

oQ<=sRAM(conv_integer(iA));

end Behavioral;

