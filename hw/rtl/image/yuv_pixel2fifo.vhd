----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:02:53 04/20/2013 
-- Design Name: 
-- Module Name:    yuv_pixel2fifo - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity yuv_pixel2fifo is
port(
	clk, resetn, sreset : in std_logic ;
	pixel_clock, hsync, vsync : in std_logic; 
	pixel_y, pixel_u, pixel_v : in std_logic_vector(7 downto 0);
	fifo_data : out std_logic_vector(15 downto 0);
	fifo_wr : out std_logic 

);
end yuv_pixel2fifo;

architecture Behavioral of yuv_pixel2fifo is
signal hsync_rising_edge, vsync_rising_edge, pxclk_rising_edge, hsync_old, vsync_old, pxclk_old: std_logic ;
signal pixel_count :std_logic_vector(1 downto 0);
signal write_pixel : std_logic ;
signal enabled : std_logic ;
begin


process(clk, resetn)
begin
	if resetn = '0' then
		enabled <= '0' ;
	elsif clk'event and clk = '1' then
		if sreset = '1' then
			enabled <= '0' ;
		elsif vsync = '1' then
			enabled <= '1' ;
		end if ;
	end if ;
end process ;

process(clk, resetn)
begin
	if resetn = '0' then
		vsync_old <= '0' ;
	elsif clk'event and clk = '1' then
		vsync_old <= vsync ;
	end if ;
end process ;
vsync_rising_edge <= (NOT vsync_old) and vsync ;

process(clk, resetn)
begin
	if resetn = '0' then
		hsync_old <= '0' ;
	elsif clk'event and clk = '1' then
		hsync_old <= hsync ;
	end if ;
end process ;
hsync_rising_edge <= (NOT hsync_old) and hsync ;

process(clk, resetn)
begin
	if resetn = '0' then
		pxclk_old <= '0' ;
	elsif clk'event and clk = '1' then
		pxclk_old <= pixel_clock ;
	end if ;
end process ;
pxclk_rising_edge <= (NOT pxclk_old) and pixel_clock ;


process(clk, resetn)
begin
	if resetn = '0' then
		pixel_count <= (others => '0'); 
	elsif clk'event and clk = '1' then
		if hsync = '1' then
			pixel_count <= (others => '0'); 
		elsif pxclk_rising_edge = '1'  and hsync = '0' then
			pixel_count <= pixel_count + 1 ;
		end if ;
	end if ;
end process ;
write_pixel <= pxclk_rising_edge;

fifo_wr <= write_pixel when vsync = '0' and hsync = '0' and enabled = '1' else
			  vsync_rising_edge ;
				
fifo_data <= (pixel_v & pixel_y ) when pixel_count(0) = '0' and vsync = '0' else
				 (pixel_u & pixel_y ) when pixel_count(0) = '1' and vsync = '0'  else
				  X"55AA" ;
end Behavioral;

