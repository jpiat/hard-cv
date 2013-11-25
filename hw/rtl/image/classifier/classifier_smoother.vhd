----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:42:17 05/04/2013 
-- Design Name: 
-- Module Name:    classifier_smoother - Behavioral 
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
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library WORK ;
USE work.image_pack.ALL ;
USE work.utils_pack.ALL ;


entity classifier_smoother is
generic(WIDTH: natural := 640;
		  HEIGHT: natural := 480);
port(
 		clk : in std_logic; 
 		resetn : in std_logic; 
 		pixel_clock, hsync, vsync : in std_logic; 
 		pixel_clock_out, hsync_out, vsync_out : out std_logic; 
 		pixel_data_in : in std_logic_vector(7 downto 0 ); 
 		pixel_data_out : out std_logic_vector(7 downto 0 )

);
end classifier_smoother;



architecture Behavioral of classifier_smoother is
	signal block3x3_sig : matNM(0 to 2, 0 to 2) ;
	signal new_block: std_logic ;
	signal result : std_logic_vector(7 downto 0);
--	for block0 : block3X3 use entity block3X3(RTL) ;
begin

		block0:  block3X3 
		generic map(WIDTH =>  WIDTH, HEIGHT => HEIGHT)
		port map(
			clk => clk ,
			resetn => resetn , 
			pixel_clock => pixel_clock , hsync => hsync , vsync => vsync,
			pixel_data_in => pixel_data_in ,
			new_block => new_block,
			block_out => block3x3_sig);
		
		result <= 		 (others => '0') when block3x3_sig(1,1) = 0 else
							std_logic_vector(block3x3_sig(1,1)(7 downto 0)) when 
								 ((block3x3_sig(0,1) = block3x3_sig(1,1) )
							AND (block3x3_sig(1,0) = block3x3_sig(1,1)) 
							AND (block3x3_sig(1,2) = block3x3_sig(1,1))  
							AND (block3x3_sig(2,1) = block3x3_sig(1,1))) else
						   (others => '0');
	
	conv_latch0 : generic_latch 
	 generic map(NBIT => 8)
    Port map( clk => clk ,
           resetn => resetn ,
           sraz => '0' ,
           en => new_block ,
           d => result,
           q => pixel_data_out );
	
		--sync signals latch
		process(clk, resetn)
		begin
			if resetn = '0' then 
				pixel_clock_out <= '0' ;
				hsync_out <= '0' ;
				vsync_out <= '0' ;
			elsif clk'event and clk = '1'  then
				pixel_clock_out <= new_block ;
				hsync_out <= hsync ;
				vsync_out <= vsync ;
			end if ;
		end process ;

end Behavioral;


