----------------------------------------------------------------------------------
-- Company:LAAS-CNRS 
-- Author:Jonathan Piat <piat.jonathan@gmail.com> 
-- 
-- Create Date:    13:51:18 05/24/2012 
-- Design Name: 
-- Module Name:    video_switch - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;


library WORK ;
use work.generic_components.all ;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity video_switch is
generic(NB	:	positive := 2);
port(pixel_clock, hsync, vsync : in std_logic_vector(NB - 1 downto 0);
	  pixel_data	:	in slv8_array(NB - 1 downto 0);
	  pixel_clock_out, hsync_out, vsync_out : out std_logic ;
	  pixel_data_out	:	out std_logic_vector(7 downto 0);
	  channel	:	in std_logic_vector(7 downto 0)
);
end video_switch;

architecture Behavioral of video_switch is

begin
pixel_data_out <= pixel_data(conv_integer(channel));
pixel_clock_out <= pixel_clock(conv_integer(channel));
hsync_out <= hsync(conv_integer(channel));
vsync_out <= vsync(conv_integer(channel));

end Behavioral;

