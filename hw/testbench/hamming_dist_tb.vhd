--------------------------------------------------------------------------------
-- Company:LAAS-CNRS 
-- Author:Jonathan Piat <piat.jonathan@gmail.com>
--
-- Create Date:   14:25:32 10/09/2012
-- Design Name:   
-- Module Name:   /home/jpiat/development/FPGA/projects/fpga-cam/hdl/test_benches/hamming_dist_tb.vhd
-- Project Name:  SPARTCAM
-- Target Device:  
-- Tool versions: ISE 14.1  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: HAMMING_DIST
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
 
ENTITY hamming_dist_tb IS
END hamming_dist_tb;
 
ARCHITECTURE behavior OF hamming_dist_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT HAMMING_DIST
    PORT(
         clk : IN  std_logic;
         resetn : IN  std_logic;
         en : IN  std_logic;
         vec1 : IN  std_logic_vector(63 downto 0);
         vec2 : IN  std_logic_vector(63 downto 0);
         dv : OUT  std_logic;
         distance : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal resetn : std_logic := '0';
   signal en : std_logic := '0';
   signal vec1 : std_logic_vector(63 downto 0) := (others => '0');
   signal vec2 : std_logic_vector(63 downto 0) := (others => '0');

 	--Outputs
   signal dv : std_logic;
   signal distance : std_logic_vector(5 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: HAMMING_DIST PORT MAP (
          clk => clk,
          resetn => resetn,
          en => en,
          vec1 => vec1,
          vec2 => vec2,
          dv => dv,
          distance => distance
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		resetn <= '0' ;
      wait for 100 ns;	
		resetn <= '1' ;
      wait for clk_period*10;
		vec1 <= X"FFFFFFFF8FFFFFFF" ;
		vec2 <= X"FFFFFFFFFFFFFFFF" ;
		en <= '1';
		wait for clk_period ;
		en <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
