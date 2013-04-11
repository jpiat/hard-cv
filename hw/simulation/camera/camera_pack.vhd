--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package camera_pack is

component virtual_camera is
generic(IMAGE_PATH : string ; PERIOD : time := 10ns);
port(
		clk : in std_logic; 
 		resetn : in std_logic; 
 		pixel_data : out std_logic_vector(7 downto 0 ); 
 		pixel_clock_out, hsync_out, vsync_out : out std_logic );
end component;

component pgm_writer is
	generic(WRITE_PATH : STRING; HEIGHT : positive := 60; WIDTH : positive := 80 );
port(
 		clk : in std_logic; 
 		resetn : in std_logic; 
 		pixel_clock, hsync, vsync : in std_logic; 
 		value_in : in std_logic_vector(15 downto 0 )
);
end component;



end camera_pack;

package body camera_pack is


end camera_pack;
