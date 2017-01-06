--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:01:14 01/22/2015
-- Design Name:   
-- Module Name:   D:/FTN/III semestar/ISE/Finalni_Projekat/top_tb.vhd
-- Project Name:  Finalni_Projekat
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY top_tb IS
END top_tb;
 
ARCHITECTURE behavior OF top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         iCLK : IN  std_logic;
         inRST : IN  std_logic;
         oPC : OUT  std_logic_vector(15 downto 0);
         oIR : OUT  std_logic_vector(14 downto 0);
         oPHASE : OUT  std_logic_vector(1 downto 0);
         oREG0 : OUT  std_logic_vector(15 downto 0);
         oREG1 : OUT  std_logic_vector(15 downto 0);
         oREG2 : OUT  std_logic_vector(15 downto 0);
         oREG3 : OUT  std_logic_vector(15 downto 0);
         oREG4 : OUT  std_logic_vector(15 downto 0);
         oREG5 : OUT  std_logic_vector(15 downto 0);
         oREG6 : OUT  std_logic_vector(15 downto 0);
         oREG7 : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal iCLK : std_logic := '0';
   signal inRST : std_logic := '0';

 	--Outputs
   signal oPC : std_logic_vector(15 downto 0);
   signal oIR : std_logic_vector(14 downto 0);
   signal oPHASE : std_logic_vector(1 downto 0);
   signal oREG0 : std_logic_vector(15 downto 0);
   signal oREG1 : std_logic_vector(15 downto 0);
   signal oREG2 : std_logic_vector(15 downto 0);
   signal oREG3 : std_logic_vector(15 downto 0);
   signal oREG4 : std_logic_vector(15 downto 0);
   signal oREG5 : std_logic_vector(15 downto 0);
   signal oREG6 : std_logic_vector(15 downto 0);
   signal oREG7 : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant iCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          iCLK => iCLK,
          inRST => inRST,
          oPC => oPC,
          oIR => oIR,
          oPHASE => oPHASE,
          oREG0 => oREG0,
          oREG1 => oREG1,
          oREG2 => oREG2,
          oREG3 => oREG3,
          oREG4 => oREG4,
          oREG5 => oREG5,
          oREG6 => oREG6,
          oREG7 => oREG7
        );

   -- Clock process definitions
   iCLK_process :process
   begin
		iCLK <= '0';
		wait for iCLK_period/2;
		iCLK <= '1';
		wait for iCLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      inRST<='0';
      wait for iCLK_period;
		
		inRST<='1';
      wait for iCLK_period*500;

      wait;
   end process;

END;
