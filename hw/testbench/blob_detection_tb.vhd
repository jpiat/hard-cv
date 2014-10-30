--------------------------------------------------------------------------------
-- Company:LAAS-CNRS 
-- Author:Jonathan Piat <piat.jonathan@gmail.com>
--
-- Create Date:   16:29:52 03/15/2012
-- Design Name:   
-- Module Name:   /home/jpiat/development/FPGA/projects/fpga-cam/platform/papilio/SPARTCAM/blob_detection_tb.vhd
-- Project Name:  SPARTCAM
-- Target Device:  
-- Tool versions: ISE 14.1  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: blob_detection
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
USE ieee.std_logic_unsigned.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY blob_detection_tb IS
END blob_detection_tb;
 
ARCHITECTURE behavior OF blob_detection_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT blob_detection
	 GENERIC(LINE_SIZE : natural := 640);
    PORT(
         clk : IN  std_logic;
         resetn : IN  std_logic;
         pixel_in_clk : IN  std_logic;
        pixel_in_hsync : IN  std_logic;
        pixel_in_vsync : IN  std_logic;
         pixel_in_data : IN  std_logic_vector(7 downto 0);
			blob_data : out std_logic_vector(7 downto 0);
				--memory_interface to copy results onpixel_in_vsync
			mem_addr : out std_logic_vector(15 downto 0);
			mem_data : inout std_logic_vector(15 downto 0);
			mem_wr : out std_logic
        );
    END COMPONENT;
    
	constant clk_period : time := 5 ns ;
	constant pclk_period : time := 40 ns ;
	
	signal clk, resetn : std_logic ;
	signal pxclk,pixel_in_hsync,pixel_in_vsync, send_blob : std_logic ;
	signal pixel, blob_data : std_logic_vector(7 downto 0 ) := (others => '0');
	signal px_count, line_count, byte_count : integer := 0 ;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: blob_detection
		generic map(LINE_SIZE => 320)
		PORT MAP (
          clk => clk,
          resetn => resetn,
          pixel_in_clk => pxclk,
         pixel_in_hsync =>pixel_in_hsync,
         pixel_in_vsync =>pixel_in_vsync,
          pixel_in_data => pixel,
			 blob_data => blob_data
        );

	process
	begin
		resetn <= '0' ;
		wait for 10*clk_period;
		resetn <= '1' ;
		while true loop
			clk <= '0';
			wait for clk_period;
			clk <= '1';
			wait for clk_period; 
		end loop ;
	end process;
	
process
	begin
		pxclk <= '0';
		if px_count < 320 and line_count >= 20 and line_count < 257 then
				hsync <= '0' ;
		else
				hsync <= '1' ;
		end if ;

		if line_count < 3 then
			vsync <= '1' ;
		 else 
			vsync <= '0' ;
		end if ;
		wait for pclk_period;
		
		pxclk <= '1';
		if (px_count = 460 ) then
			px_count <= 0 ;
			if (line_count > 270) then
			   line_count <= 0;
		  else
		    line_count <= line_count + 1 ;
		  end if ;
		else
		  px_count <= px_count + 1 ;
		end if ;
		
		wait for pclk_period;

	end process;

--pixel <= X"FF" when line_count < 100 and line_count > 50 and  px_count  < 400 and  px_count  > 200 else
--			X"00" ;
			
--pixel <= X"FF" when px_count < 100 and line_count < 240 else
--			X"00" ;

--pixel <= X"FF" when line_count < 100  and  px_count  >= 250 else
--			X"00" ;
			
pixel <= X"FF" when line_count < 100  and  px_count  >= 250 else
			X"FF" when line_count >= 100  and  px_count  <= 250 else
			X"00" ;


END;
