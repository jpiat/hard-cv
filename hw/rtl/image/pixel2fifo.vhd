----------------------------------------------------------------------------------
-- Company:LAAS-CNRS 
-- Author:Jonathan Piat <piat.jonathan@gmail.com> 
-- 
-- Create Date:    10:59:31 01/24/2013 
-- Design Name: 
-- Module Name:    pixel2fifo - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pixel2fifo is
port(
	clk, resetn : in std_logic ;
	pixel_clock, hsync, vsync : in std_logic; 
	pixel_data_in : in std_logic_vector(7 downto 0);
	fifo_data : out std_logic_vector(15 downto 0);
	fifo_wr : out std_logic 

);
end pixel2fifo;

architecture Behavioral of pixel2fifo is
signal hsync_rising_edge, vsync_rising_edge, pxclk_rising_edge, hsync_old, vsync_old, pxclk_old, write_pixel_old : std_logic ;
signal pixel_buffer : std_logic_vector(15 downto 0);	
signal pixel_count :std_logic_vector(7 downto 0);
signal write_pixel : std_logic ;
begin

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
		pixel_buffer(15 downto 0) <= (others => '0') ;
	elsif clk'event and clk = '1' then
		if hsync_rising_edge = '1' then
			pixel_buffer(15 downto 0) <= (others => '0') ;
		elsif pxclk_rising_edge = '1' then
			pixel_buffer(7 downto 0) <= pixel_buffer(15 downto 8) ;
			pixel_buffer(15 downto 8)  <= pixel_data_in ;
		end if ;
	end if ;
end process ;

process(clk, resetn)
begin
	if resetn = '0' then
		pixel_count <= (others => '0'); 
	elsif clk'event and clk = '1' then
		if hsync_rising_edge = '1' then
			pixel_count <= (others => '0'); 
		elsif pxclk_rising_edge = '1'  and hsync = '0' then
			pixel_count <= pixel_count + 1 ;
		end if ;
	end if ;
end process ;
write_pixel <= pixel_count(0);

process(clk, resetn)
begin
	if resetn = '0' then
		write_pixel_old <= '0'; 
	elsif clk'event and clk = '1' then
		write_pixel_old <= write_pixel ;
	end if ;
end process ;


fifo_wr <= (write_pixel and (NOT write_pixel_old)) when vsync = '0' and hsync = '0' else
				'0' ;
				
fifo_data <= pixel_buffer ;


end Behavioral;

