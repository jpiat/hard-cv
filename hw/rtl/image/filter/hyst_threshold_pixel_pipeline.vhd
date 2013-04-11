----------------------------------------------------------------------------------
-- Company:LAAS-CNRS 
-- Author:Jonathan Piat <piat.jonathan@gmail.com> 
-- 
-- Create Date:    17:47:57 01/15/2013 
-- Design Name: 
-- Module Name:    hyst_threshold - Behavioral 
-- Project Name: 
-- Target Devices: Spartan 6 
-- Tool versions: ISE 14.1 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library WORK ;
USE WORK.image_pack.ALL ;
USE WORK.utils_pack.ALL ;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hyst_threshold_pixel_pipeline is
generic(WIDTH: natural := 640;
		  HEIGHT: natural := 480; LOW_THRESH: positive := 100 ; HIGH_THRESH: positive := 180);
port(
 		resetn : in std_logic; 
 		pixel_clock, hsync, vsync : in std_logic; 
 		pixel_clock_out, hsync_out, vsync_out : out std_logic; 
 		pixel_data_in : in std_logic_vector(7 downto 0 ); 
 		pixel_data_out : out std_logic_vector(7 downto 0 )
);
end hyst_threshold_pixel_pipeline;

architecture RTL of hyst_threshold_pixel_pipeline is
	signal block3x3_sig : matNM(0 to 2, 0 to 2) ;
	signal pixel_clock_en, new_block : std_logic ;
begin

		block0:  block3X3_pixel_pipeline
		generic map(WIDTH =>  WIDTH, HEIGHT => HEIGHT)
		port map(
			resetn => resetn , 
			pixel_clock => pixel_clock , hsync => hsync , vsync => vsync,
			pixel_data_in => pixel_data_in ,
			block_out => block3x3_sig);
		
		pixel_data_out <= X"FF" when block3x3_sig(1,1) > HIGH_THRESH else
								X"FF" when block3x3_sig(1,1) > LOW_THRESH and block3x3_sig(0,0) > HIGH_THRESH else
								X"FF" when block3x3_sig(1,1) > LOW_THRESH and block3x3_sig(0,1) > HIGH_THRESH else			
								X"FF" when block3x3_sig(1,1) > LOW_THRESH and block3x3_sig(0,2) > HIGH_THRESH else
								X"FF" when block3x3_sig(1,1) > LOW_THRESH and block3x3_sig(1,0) > HIGH_THRESH else
								X"FF" when block3x3_sig(1,1) > LOW_THRESH and block3x3_sig(1,2) > HIGH_THRESH else
								X"FF" when block3x3_sig(1,1) > LOW_THRESH and block3x3_sig(2,0) > HIGH_THRESH else
								X"FF" when block3x3_sig(1,1) > LOW_THRESH and block3x3_sig(2,1) > HIGH_THRESH else
								X"FF" when block3x3_sig(1,1) > LOW_THRESH and block3x3_sig(2,2) > HIGH_THRESH else
								X"00" ;
								
								
								
		pixel_clock_out <= pixel_clock ;
		delay_sync: generic_delay
		generic map( WIDTH => 2 , DELAY => 1)
		port map(
			clk => pixel_clock, resetn => resetn ,
			input(0) => hsync ,
			input(1) => vsync ,
			output(0) => hsync_out ,
			output(1) => vsync_out
		);		
		
end RTL;

