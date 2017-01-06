----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:05:23 01/18/2015 
-- Design Name: 
-- Module Name:    top - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Port ( iCLK : in  STD_LOGIC;
       inRST : in  STD_LOGIC;
		 oPC : out STD_LOGIC_VECTOR(15 downto 0);
		 oIR : out STD_LOGIC_VECTOR(14 downto 0);
		 oPHASE : out STD_LOGIC_VECTOR(1 downto 0);
		 oREG0 : out STD_LOGIC_VECTOR(15 downto 0);
		 oREG1 : out STD_LOGIC_VECTOR(15 downto 0);
		 oREG2 : out STD_LOGIC_VECTOR(15 downto 0);
		 oREG3 : out STD_LOGIC_VECTOR(15 downto 0);
		 oREG4 : out STD_LOGIC_VECTOR(15 downto 0);
		 oREG5 : out STD_LOGIC_VECTOR(15 downto 0);
		 oREG6 : out STD_LOGIC_VECTOR(15 downto 0);
		 oREG7 : out STD_LOGIC_VECTOR(15 downto 0));
end top;

architecture Behavioral of top is

component procesor is
Port ( iCLK : in  STD_LOGIC;
       inRST : in  STD_LOGIC;
		 iINSTR : in STD_LOGIC_VECTOR (14 downto 0);
       iDATA : in  STD_LOGIC_VECTOR (15 downto 0);
       oPC : out STD_LOGIC_VECTOR (15 downto 0);
		 oDATA : out  STD_LOGIC_VECTOR (15 downto 0);
		 oADDR : out STD_LOGIC_VECTOR (15 downto 0);
		 oMEM_WE : out STD_LOGIC;
		 oREG0 : out STD_LOGIC_VECTOR(15 downto 0);
	    oREG1 : out STD_LOGIC_VECTOR(15 downto 0);
	    oREG2 : out STD_LOGIC_VECTOR(15 downto 0);
	    oREG3 : out STD_LOGIC_VECTOR(15 downto 0);
	    oREG4 : out STD_LOGIC_VECTOR(15 downto 0);
	    oREG5 : out STD_LOGIC_VECTOR(15 downto 0);
	    oREG6 : out STD_LOGIC_VECTOR(15 downto 0);
	    oREG7 : out STD_LOGIC_VECTOR(15 downto 0);
	    oPHASE : out STD_LOGIC_VECTOR(1 downto 0));
end component;

component data_ram is
Port ( iCLK : in  STD_LOGIC;
       inRST : in  STD_LOGIC;
       iA : in  STD_LOGIC_VECTOR (4 downto 0);
       iD : in  STD_LOGIC_VECTOR (15 downto 0);
       iWE : in  STD_LOGIC;
       oQ : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

component instr_rom is
Port ( iA : in  STD_LOGIC_VECTOR (4 downto 0);
       oQ : out  STD_LOGIC_VECTOR (14 downto 0));
end component;

signal sMEM_WE : STD_LOGIC;
signal sINSTR : STD_LOGIC_VECTOR(14 downto 0);
signal sADDR, sDATA_ST, sDATA_LD, sPC, sDATA_LD1 : STD_LOGIC_VECTOR(15 downto 0);

begin

sDATA_LD1<="0000000000"&sINSTR(5 downto 0) when (sINSTR(14 downto 9)="100001") else sDATA_LD;

P : procesor port map(
	iCLK=>iCLK,
	inRST=>inRST,
	iINSTR=>sINSTR,
	iDATA=>sDATA_LD1,
	oPC=>sPC,
	oDATA=>sDATA_ST,
	oADDR=>sADDR,
	oMEM_WE=>sMEM_WE,
	
	oREG0=>oREG0,
	oREG1=>oREG1,
	oREG2=>oREG2,
	oREG3=>oREG3,
	oREG4=>oREG4,
	oREG5=>oREG5,
	oREG6=>oREG6,
	oREG7=>oREG7,
	
	oPHASE=>oPHASE
);

D_R : data_ram port map(
	iCLK=>iCLK,
	inRST=>inRST,
	iA=>sADDR(4 downto 0),
	iD=>sDATA_ST,
	iWE=>sMEM_WE,
	oQ=>sDATA_LD
);

I_R : instr_rom port map(
	iA=>sPC(4 downto 0),
	oQ=>sINSTR
);

--izlazi:
oPC<=sPC;
oIR<=sINSTR;

end Behavioral;

