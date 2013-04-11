----------------------------------------------------------------------------------
-- Company:LAAS-CNRS 
-- Author:Jonathan Piat <piat.jonathan@gmail.com> 
-- 
-- Create Date:    17:12:12 03/16/2012 
-- Design Name: 
-- Module Name:    draw_square - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity draw_square is
port(
 		clk : in std_logic; 
 		resetn : in std_logic; 
		posx, posy, width, height : in unsigned(9 downto 0);
 		pixel_clock, hsync, vsync : in std_logic; 
 		pixel_clock_out, hsync_out, vsync_out : out std_logic; 
 		pixel_data_in : in std_logic_vector(7 downto 0 ); 
 		pixel_data_out : out std_logic_vector(7 downto 0 )
	);
end draw_square;

architecture Behavioral of draw_square is
signal pixel_x, pixel_y : unsigned(9 downto 0);
signal last_hsync, last_pxclk : std_logic := '0';
begin

pixel_data_out <= X"00" when pixel_x > posx and pixel_x < (posx + width) and pixel_y > posy and pixel_y < (posy + height)  else
						pixel_data_in ;



process(clk, resetn)
begin
	if resetn = '0' then
		pixel_clock_out <= '0' ;
		hsync_out <= '0' ;
		vsync_out <= '0' ;
	elsif clk'event and clk = '1' then
		if pixel_clock = '1' then
			pixel_clock_out <= '1' ;
		else
			pixel_clock_out <= '0' ;
		end if;
		if hsync = '1' then
			hsync_out <= '1' ;
		else
			hsync_out <= '0' ;
		end if;
		if vsync = '1' then
			vsync_out <= '1' ;
		else
			vsync_out <= '0' ;
		end if;
	end if;
end process ;

process(clk, resetn)
begin
	if resetn = '0' then
		pixel_x <= (others => '0');
		pixel_y <= (others => '0');
	elsif clk'event and clk = '1' then
		if vsync = '1' then
			pixel_x <= (others => '0');
			pixel_y <= (others => '0');
		elsif hsync = '1' and last_hsync /= hsync then
			pixel_x <= (others => '0');
			pixel_y <= pixel_y + 1 ;
		elsif last_pxclk /= pixel_clock and pixel_clock = '0' and hsync = '0' then --increasing on falling edge of clock
			pixel_x <= pixel_x + 1;
		end if;
		last_hsync <= hsync ;
		last_pxclk <= pixel_clock ;
	end if;
end process ;

end Behavioral;

