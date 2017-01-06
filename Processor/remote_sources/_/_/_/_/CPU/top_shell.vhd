
----------------------------------------------------------------------------------
-- Logicko projektovanje racunarskih sistema 1
-- 2011/2012
-- Lab 7
--
-- LCD handler
--
-- author: Ivan Kastelan (ivan.kastelan@rt-rk.com)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity top_shell is
    Port ( iCLK : in  STD_LOGIC;
           inRST : in  STD_LOGIC;
           iPB : in  STD_LOGIC;
           iSW : in  STD_LOGIC_VECTOR (7 downto 0);
           oLCD_D : out  STD_LOGIC_VECTOR (3 downto 0);
           oLCD_EN : out  STD_LOGIC;
           oLCD_RW : out  STD_LOGIC;
           oLCD_RS : out  STD_LOGIC);
end top_shell;

architecture Behavioral of top_shell is

    component top is
    Port ( iCLK : in  STD_LOGIC;
           inRST : in  STD_LOGIC;
           -- Lab 7 ports for LCD handler
           oPC : out  STD_LOGIC_VECTOR (15 downto 0);
           oIR : out  STD_LOGIC_VECTOR (14 downto 0);
           oPHASE : out  STD_LOGIC_VECTOR (1 downto 0);
           oREG0, oREG1, oREG2, oREG3, oREG4, oREG5, oREG6, oREG7 : out  STD_LOGIC_VECTOR (15 downto 0));
    end component;
    
    component LCD_DRIVER is
    generic (WIDTH : NATURAL := 4;
            WIDTH_DISPLAY	 : integer := 16;
            WIDTH_OUTSIDE: integer:= 8;
            SIMULATION : boolean:= FALSE
            ); 
    
    port
    (
        CLR_IP		: in  STD_LOGIC;
        CLK_IP_DR	: in  STD_LOGIC; -- Running at 187500 kHz
        EN_IP			: in  STD_LOGIC; -- Detect if there is any incoming message
        MSG_IPV		: in  STD_LOGIC_VECTOR(WIDTH_OUTSIDE-1 downto 0); -- Message from outside
        LCD_DAT_OPV	: out STD_LOGIC_VECTOR(WIDTH-1 downto 0); -- LCD Data Bus Line
        LCD_EN_OP	: out STD_LOGIC; -- LCD Enable
        LCD_SEL_OP	: out STD_LOGIC; -- LCD Regiser Select
        LCD_RW_OP	: out STD_LOGIC;  -- LCD Data Read/Write
            READY 		: out std_logic 
    );
    end component;
    
    component CPU_CLK_GEN is
    port ( iCLK       : in   STD_LOGIC;
          inRST      : in   STD_LOGIC;
          iPB        : in   STD_LOGIC;
          oCLK       : out  STD_LOGIC;
          onRST      : out  STD_LOGIC;
          oCPU_CLK   : out  STD_LOGIC
        );
    end component;
    
    function HEX_TO_DIGIT (iX : std_logic_vector(3 downto 0)) return std_logic_vector is
        variable sRET : std_logic_vector(7 downto 0);
    begin
        if (iX < 10) then
            sRET := iX + x"30";
        else
            sRET := iX + x"37";
        end if;
        return sRET;
    end function HEX_TO_DIGIT;

    signal sCLK_LCD : std_logic;
    signal sCLK_CPU : std_logic;
    signal snRST : std_logic;
    
    signal sPC : std_logic_vector(15 downto 0);
    signal sIR : std_logic_vector(14 downto 0);
    signal sPHASE : std_logic_vector(1 downto 0);
    signal sR0, sR1, sR2, sR3, sR4, sR5, sR6, sR7 : std_logic_vector(15 downto 0);
    
    signal sLCD_EN : std_logic;
    signal sLCD_DATA : std_logic_vector(7 downto 0);
    signal sREADY : std_logic;
    
    type tSTATES is (WAIT_READY, SEND_CHAR, DELAY);
    signal sSTATE : tSTATES;
    type tMEM is array(0 to 32) of std_logic_vector(7 downto 0);
    signal sMEM : tMEM;
    signal sINDEX : std_logic_vector(5 downto 0);
    
    signal sREG_SEL : std_logic_vector(2 downto 0);
    signal sREG_VAL : std_logic_vector(15 downto 0);

begin

    i_CPU_CLK_GEN : CPU_CLK_GEN port map (
        iCLK       => iCLK,
        inRST      => inRST,
        iPB        => iPB,
        oCLK       => sCLK_LCD,
        onRST      => snRST,
        oCPU_CLK   => sCLK_CPU
    );
    
    i_TOP : top port map (
        iCLK    => sCLK_CPU,
        inRST   => snRST,
        oPC     => sPC,
        oIR     => sIR,
        oPHASE  => sPHASE,
        oREG0     => sR0,
        oREG1     => sR1,
        oREG2     => sR2,
        oREG3     => sR3,
        oREG4     => sR4,
        oREG5     => sR5,
        oREG6     => sR6,
        oREG7     => sR7
    );
    
    i_LCD_DRIVER : LCD_DRIVER port map (
        CLR_IP		=> snRST,
        CLK_IP_DR	=> sCLK_LCD,
        EN_IP		=> sLCD_EN,
        MSG_IPV		=> sLCD_DATA,
        LCD_DAT_OPV	=> oLCD_D,
        LCD_EN_OP	=> oLCD_EN,
        LCD_SEL_OP	=> oLCD_RS,
        LCD_RW_OP	=> oLCD_RW,
        READY 		=> sREADY
    );
    
    -- LCD handler FSM --
    
    process (sCLK_LCD, snRST) begin
        if (snRST = '0') then
            sSTATE <= WAIT_READY;
        elsif (sCLK_LCD'event and sCLK_LCD = '1') then
            case (sSTATE) is
                when WAIT_READY =>
                    if (sREADY = '1') then
                        sSTATE <= SEND_CHAR;
                    end if;
                when SEND_CHAR =>
                    if (sREADY = '0') then
                        if (sINDEX = "100000") then
                            sSTATE <= DELAY;
                        else
                            sSTATE <= WAIT_READY;
                        end if;
                    end if;
                when DELAY =>
                    sSTATE <= WAIT_READY;
            end case;
        end if;
    end process;
    
    process (sCLK_LCD, snRST) begin
        if (snRST = '0') then
            sINDEX <= (others => '0');
        elsif (sCLK_LCD'event and sCLK_LCD = '1') then
            if (sSTATE = SEND_CHAR and sREADY = '0') then
                sINDEX <= sINDEX + 1;
            end if;
        end if;
    end process;
    
    sLCD_EN <= '1' when sSTATE = SEND_CHAR else '0';
    sLCD_DATA <= sMEM(conv_integer(sINDEX));
    
    process (sCLK_LCD, snRST) begin
        if (snRST = '0') then
            sMEM <= (x"1B", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20",
                            x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20",     
                            x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20",
                            x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20");
        elsif (sCLK_LCD'event and sCLK_LCD = '1') then
            if (sSTATE = DELAY) then
                sMEM(1) <= x"41";
                sMEM(2) <= HEX_TO_DIGIT(sPC(15 downto 12));
                sMEM(3) <= HEX_TO_DIGIT(sPC(11 downto 8));
                sMEM(4) <= HEX_TO_DIGIT(sPC(7 downto 4));
                sMEM(5) <= HEX_TO_DIGIT(sPC(3 downto 0));
                sMEM(6) <= x"20";
                sMEM(7) <= x"49";
                sMEM(8) <= HEX_TO_DIGIT('0' & sIR(14 downto 12));
                sMEM(9) <= HEX_TO_DIGIT(sIR(11 downto 8));
                sMEM(10) <= HEX_TO_DIGIT(sIR(7 downto 4));
                sMEM(11) <= HEX_TO_DIGIT(sIR(3 downto 0));
                sMEM(12) <= x"20";
                sMEM(13) <= x"50";
                sMEM(14) <= HEX_TO_DIGIT("00" & sPHASE);
                sMEM(15) <= x"20";
                sMEM(16) <= x"20";
                sMEM(17) <= x"52";
                sMEM(18) <= x"30";
                sMEM(19) <= x"2D";
                sMEM(20) <= HEX_TO_DIGIT(sR0(15 downto 12));
                sMEM(21) <= HEX_TO_DIGIT(sR0(11 downto 8));
                sMEM(22) <= HEX_TO_DIGIT(sR0(7 downto 4));
                sMEM(23) <= HEX_TO_DIGIT(sR0(3 downto 0));
                sMEM(24) <= x"20";
                sMEM(25) <= x"52";
                sMEM(26) <= HEX_TO_DIGIT('0' & sREG_SEL);
                sMEM(27) <= x"2D";
                sMEM(28) <= HEX_TO_DIGIT(sREG_VAL(15 downto 12));
                sMEM(29) <= HEX_TO_DIGIT(sREG_VAL(11 downto 8));
                sMEM(30) <= HEX_TO_DIGIT(sREG_VAL(7 downto 4));
                sMEM(31) <= HEX_TO_DIGIT(sREG_VAL(3 downto 0));
                sMEM(32) <= x"20";
            end if;
        end if;
    end process;
    
    sREG_SEL <= "001" when iSW(1) = '1' else
                "010" when iSW(2) = '1' else
                "011" when iSW(3) = '1' else
                "100" when iSW(4) = '1' else
                "101" when iSW(5) = '1' else
                "110" when iSW(6) = '1' else
                "111" when iSW(7) = '1' else
                "001";
    
    sREG_VAL <= sR1 when iSW(1) = '1' else
                sR2 when iSW(2) = '1' else
                sR3 when iSW(3) = '1' else
                sR4 when iSW(4) = '1' else
                sR5 when iSW(5) = '1' else
                sR6 when iSW(6) = '1' else
                sR7 when iSW(7) = '1' else
                sR1;

end Behavioral;
