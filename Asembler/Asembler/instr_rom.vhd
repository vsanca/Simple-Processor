library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity instr_rom is
    Port ( iA : in  STD_LOGIC_VECTOR (4 downto 0);
           oQ : out  STD_LOGIC_VECTOR (14 downto 0));
end instr_rom;

architecture Behavioral of instr_rom is

type tINSTR is array (0 to 31) of STD_LOGIC_VECTOR(14 downto 0);
signal sINSTRUKCIJE : tINSTR;

--konstante za instrukcije:
constant mov 	: STD_LOGIC_VECTOR(5 downto 0) := "000000";
constant add 	: STD_LOGIC_VECTOR(5 downto 0) := "000001";
constant sub 	: STD_LOGIC_VECTOR(5 downto 0) := "000010";
constant i_and	: STD_LOGIC_VECTOR(5 downto 0) := "000011";
constant i_or 	: STD_LOGIC_VECTOR(5 downto 0) := "000100";
constant i_not : STD_LOGIC_VECTOR(5 downto 0) := "000101";
constant inc 	: STD_LOGIC_VECTOR(5 downto 0) := "000110";
constant dec 	: STD_LOGIC_VECTOR(5 downto 0) := "000111";
constant shl 	: STD_LOGIC_VECTOR(5 downto 0) := "001000";
constant shr 	: STD_LOGIC_VECTOR(5 downto 0) := "001001";
constant ashl 	: STD_LOGIC_VECTOR(5 downto 0) := "001010";
constant ashr 	: STD_LOGIC_VECTOR(5 downto 0) := "001011";
constant jmp 	: STD_LOGIC_VECTOR(5 downto 0) := "010000";
constant jmpz 	: STD_LOGIC_VECTOR(5 downto 0) := "010001";
constant jmps 	: STD_LOGIC_VECTOR(5 downto 0) := "010010";
constant jmpc 	: STD_LOGIC_VECTOR(5 downto 0) := "010011";
constant jmpnz	: STD_LOGIC_VECTOR(5 downto 0) := "010101";
constant jmpns	: STD_LOGIC_VECTOR(5 downto 0) := "010110";
constant jmpnc	: STD_LOGIC_VECTOR(5 downto 0) := "010111";
constant i_ld 	: STD_LOGIC_VECTOR(5 downto 0) := "100000";
constant i_st	: STD_LOGIC_VECTOR(5 downto 0) := "110000";
constant cmp	: STD_LOGIC_VECTOR(5 downto 0) := "001100";

--konstante za registre:
constant R0	: STD_LOGIC_VECTOR(2 downto 0) := "000";
constant R1	: STD_LOGIC_VECTOR(2 downto 0) := "001";
constant R2	: STD_LOGIC_VECTOR(2 downto 0) := "010";
constant R3	: STD_LOGIC_VECTOR(2 downto 0) := "011";
constant R4	: STD_LOGIC_VECTOR(2 downto 0) := "100";
constant R5	: STD_LOGIC_VECTOR(2 downto 0) := "101";
constant R6	: STD_LOGIC_VECTOR(2 downto 0) := "110";
constant R7	: STD_LOGIC_VECTOR(2 downto 0) := "111";


begin

		sINSTRUKCIJE(0)<=inc&r1&r1&"000";
		sINSTRUKCIJE(1)<=movc&r0&std_logic_vector(to_unsigned(4,6));
		sINSTRUKCIJE(2)<=jmpz&"000000110";
		sINSTRUKCIJE(3)<=shl&r1&r1&"000";
		sINSTRUKCIJE(4)<=dec&r0&r0&"000";
		sINSTRUKCIJE(5)<=jmpnz&"000000011";
		sINSTRUKCIJE(6)<=mov&r1&r1&"000";
		sINSTRUKCIJE(7)<=jmp&"000000110";
		sINSTRUKCIJE(8)<=(others=>'0');
		sINSTRUKCIJE(9)<=(others=>'0');
		sINSTRUKCIJE(10)<=(others=>'0');
		sINSTRUKCIJE(11)<=(others=>'0');
		sINSTRUKCIJE(12)<=(others=>'0');
		sINSTRUKCIJE(13)<=(others=>'0');
		sINSTRUKCIJE(14)<=(others=>'0');
		sINSTRUKCIJE(15)<=(others=>'0');
		sINSTRUKCIJE(16)<=(others=>'0');
		sINSTRUKCIJE(17)<=(others=>'0');
		sINSTRUKCIJE(18)<=(others=>'0');
		sINSTRUKCIJE(19)<=(others=>'0');
		sINSTRUKCIJE(20)<=(others=>'0');
		sINSTRUKCIJE(21)<=(others=>'0');
		sINSTRUKCIJE(22)<=(others=>'0');
		sINSTRUKCIJE(23)<=(others=>'0');
		sINSTRUKCIJE(24)<=(others=>'0');
		sINSTRUKCIJE(25)<=(others=>'0');
		sINSTRUKCIJE(26)<=(others=>'0');
		sINSTRUKCIJE(27)<=(others=>'0');
		sINSTRUKCIJE(28)<=(others=>'0');
		sINSTRUKCIJE(29)<=(others=>'0');
		sINSTRUKCIJE(30)<=(others=>'0');
		sINSTRUKCIJE(31)<=(others=>'0');

oQ<=sINSTRUKCIJE(conv_integer(iA));


end Behavioral;
