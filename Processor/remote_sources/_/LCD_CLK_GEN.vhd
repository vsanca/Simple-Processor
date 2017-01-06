----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:45:30 12/12/2014 
-- Design Name: 
-- Module Name:    LCD_CLK_GEN - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LCD_CLK_GEN is
    Port ( iCLK : in  STD_LOGIC;
           inRST : in  STD_LOGIC;
           oCLK : out  STD_LOGIC;
           onRST : out  STD_LOGIC);
end LCD_CLK_GEN;

architecture Behavioral of LCD_CLK_GEN is

signal sCNT : STD_LOGIC_VECTOR (6 downto 0);
signal snRST : STD_LOGIC;

begin

-----------------------------------------
--24M/128=187.5k		1/128=1/2^7
--generator sporijeg takta od 187.5kHz:
-----------------------------------------
process(iCLK)begin
	if(iCLK'event and iCLK='1')then
		if(inRST='0')then
			sCNT<=(others=>'0');
		else
			sCNT<=sCNT+1;
		end if;
	end if;
end process;

oCLK<='1' when(sCNT(6)='1') else '0';
-----------------------------------------

---------------------------------------------------------------------------
--generator sporijeg odziva na inRST, i to odziv kao da je takt 187.5kHz:
---------------------------------------------------------------------------
process(iCLK,inRST)begin
	if(inRST='0')then
		snRST<='0';
	elsif(iCLK'event and iCLK='1')then
		if(sCNT(6)='1')then
			snRST<='1';
		end if;
	end if;
end process;

onRST <= snRST;
---------------------------------------------------------------------------

end Behavioral;

