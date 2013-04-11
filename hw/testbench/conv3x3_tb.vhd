--------------------------------------------------------------------------------
-- Company:LAAS-CNRS 
-- Author:Jonathan Piat <piat.jonathan@gmail.com>
--
-- Create Date:   13:58:03 09/07/2012
-- Design Name:   
-- Module Name:   /home/jpiat/development/FPGA/projects/fpga-cam/hdl/test_benches/conv3x3_tb.vhd
-- Project Name:  SPARTCAM
-- Target Device:  
-- Tool versions: ISE 14.1  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: conv3x3
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
USE ieee.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
library WORK;
use WORK.CAMERA.ALL;
use WORK.generic_components.ALL;
 
 
 
ENTITY conv3x3_tb IS
END conv3x3_tb;
 
ARCHITECTURE behavior OF conv3x3_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
	
	

   --Inputs
   signal clk : std_logic := '0';
   signal resetn : std_logic := '0';
   signal new_block : std_logic := '0';
   signal block3x3 : mat3;

 	--Outputs
   signal new_conv : std_logic;
   signal busy : std_logic;
   signal abs_res : std_logic_vector(7 downto 0);
   signal raw_res : signed(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	block3x3 <=  (( to_signed(1, 9), to_signed(1, 9), to_signed(1, 9)), 
										(to_signed(1, 9), to_signed(1, 9), to_signed(1, 9)), 
										(to_signed(1, 9), to_signed(1, 9), to_signed(1, 9)));
 
	-- Instantiate the Unit Under Test (UUT)
   uut: conv3x3 PORT MAP (
          clk => clk,
          resetn => resetn,
          new_block => new_block,
          block3x3 => block3x3,
          new_conv => new_conv,
          busy => busy,
          abs_res => abs_res,
          raw_res => raw_res
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
      resetn <= '0' ;
      wait for 100 ns;	
		resetn <= '1' ;
      wait for clk_period*5;
		new_block <= '1' ;
		wait for clk_period;
		new_block <= '0' ;
		wait for clk_period*5;
      -- insert stimulus here 

      wait;
   end process;

END;
