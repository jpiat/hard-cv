----------------------------------------------------------------------------------
-- Company:LAAS-CNRS 
-- Author:Jonathan Piat <piat.jonathan@gmail.com> 
-- 
-- Create Date:    11:45:31 03/14/2012 
-- Design Name: 
-- Module Name:    blob_detection - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.log2;
use ieee.math_real.ceil;

library work;
use work.image_pack.all ;
use work.utils_pack.all ;
use work.blob_pack.all ;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity blob_detection is
generic(LINE_SIZE : natural := 640);
port(
 		clk : in std_logic; 
 		resetn: in std_logic; 
 		pixel_clock, hsync, vsync : in std_logic;
 		pixel_data_in : in std_logic_vector(7 downto 0 );
		blob_data : out std_logic_vector(7 downto 0);
		
		--memory_interface to copy results on vsync
		mem_addr : out std_logic_vector(15 downto 0);
		mem_data : inout std_logic_vector(15 downto 0);
		mem_wr : out std_logic
		);
end blob_detection;

architecture Behavioral of blob_detection is


type blob_states is (WAIT_VSYNC, WAIT_HSYNC, WAIT_PIXEL, COMPARE_PIXEL, ADD_TO_BLOB, ADD_NEW_BLOB, END_PIXEL) ;

signal blob_state0 : blob_states ;
signal pixel_x, pixel_y : std_logic_vector(9 downto 0);
signal hsync_old: std_logic := '0';
signal sraz_neighbours, sraz_blobs : std_logic ;
signal neighbours0 : pix_neighbours;
signal new_line, add_neighbour, add_pixel, merge_blob, new_blob, oe_blob : std_logic ;
signal current_pixel : std_logic_vector(7 downto 0) ;
signal new_blob_index, current_blob, blob_index_to_merge, true_blob_index : unsigned(7 downto 0) ;
signal has_neighbour : std_logic ;
signal is_blob_pixel : std_logic ;
signal pixel_clock_old, pixel_clock_re : std_logic ;
signal vsync_fe, vsync_re, vsync_old : std_logic ;
begin


sraz_blobs <= vsync_fe ;

blobs0: blob_manager 
	generic map(NB_BLOB => 32)
	port map(
	clk => clk, resetn => resetn, sraz => sraz_blobs,
		blob_index => current_blob,
		next_blob_index => new_blob_index,
		blob_index_to_merge => blob_index_to_merge ,
		merge_blob => merge_blob,
		new_blob => new_blob, 
		add_pixel => add_pixel,
		pixel_posx => unsigned(pixel_x), pixel_posy => unsigned(pixel_y),
		
		send_blobs => vsync_re,
		--memory_interface to copy results on vsync
		mem_addr => mem_addr,
		mem_data => mem_data,
		mem_wr => mem_wr
	);
	
update_neighbours : neighbours
		generic map(WIDTH => LINE_SIZE )
		port map(
			clk => clk, 
			resetn => resetn , sraz => sraz_neighbours, 
			pixel_clock => pixel_clock, hsync => hsync, 
         vsync => vsync,			
			neighbour_in => current_blob,
			neighbours => neighbours0);
			
pixel_counter0: pixel_counter
		port map(
			clk => clk,
			resetn => resetn, 
			pixel_clock => pixel_clock, hsync => hsync,
			pixel_count => pixel_x
			);
			
line_counter0: line_counter
		generic map(MAX => 480)
		port map(
			clk => clk,
			resetn => resetn, 
			hsync => hsync, vsync => vsync, 
			line_count => pixel_y(8 downto 0)
			);
pixel_y(9) <= '0' ;

current_blob <= neighbours0(3) when is_blob_pixel='1' and neighbours0(3) /= 0 else
					 neighbours0(0) when is_blob_pixel='1' and neighbours0(0) /= 0 else
					 neighbours0(1) when is_blob_pixel='1' and neighbours0(1) /= 0 else
					 neighbours0(2) when is_blob_pixel='1' and neighbours0(2) /= 0 else
					 new_blob_index when is_blob_pixel='1'  else
					 (others => '0') ;

has_neighbour <= '1' when (neighbours0(3) /= 0) or (neighbours0(2) /= 0) or (neighbours0(1) /= 0) or (neighbours0(0) /= 0) else
						'0' ;
is_blob_pixel <= 	'1' when pixel_data_in = x"FF" and hsync = '0' else
						'0';
new_blob <= pixel_clock_re when is_blob_pixel = '1' and has_neighbour = '0' else
				'0' ;
add_pixel <= pixel_clock_re when is_blob_pixel='1' and has_neighbour /= '0' else
				 '0' ;
					 
add_neighbour <= pixel_clock when hsync = '0' else
					  '0' ;
merge_blob <= pixel_clock_re when neighbours0(0) /= 0 and neighbours0(2) /= 0 and neighbours0(0) /= neighbours0(2) and is_blob_pixel='1' else
				  pixel_clock_re when neighbours0(3) /= 0 and neighbours0(2) /= 0 and neighbours0(3) /= neighbours0(2) and is_blob_pixel='1' else
				  '0' ;
				  
blob_index_to_merge <= neighbours0(2) ;


process(clk, resetn)
begin
	if resetn = '0' then
		pixel_clock_old <= '0' ;
		vsync_old <= '0' ;
	elsif clk'event and clk = '1' then
		pixel_clock_old <= pixel_clock ;
		vsync_old <= vsync ;
	end if ;
end process ;
pixel_clock_re <= (NOT pixel_clock_old) and pixel_clock ;
vsync_fe <= vsync_old and (NOT vsync) ;
vsync_re <= (NOT vsync_old) and vsync ;

end Behavioral;

