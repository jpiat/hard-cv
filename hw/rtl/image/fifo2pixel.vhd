----------------------------------------------------------------------------------
-- Company:LAAS-CNRS 
-- Author:Jonathan Piat <piat.jonathan@gmail.com> 
-- 
-- Create Date:    19:19:26 01/10/2013 
-- Design Name: 
-- Module Name:    fifo2pixel - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library work ;
use work.utils_pack.all ;


entity fifo2pixel is
	generic(WIDTH : positive := 320 ; HEIGHT : positive := 240);
	port(
		clk, resetn : in std_logic ;
		
	
		fifo_rd : out std_logic ;
		fifo_data : in std_logic_vector(15 downto 0);
		
		-- 
      line_available : in std_logic ;		

		
		-- pixel side 
		y_data : out std_logic_vector(7 downto 0 );  
 		pixel_clock_out, hsync_out, vsync_out : out std_logic
	
	);
end fifo2pixel;

architecture Behavioral of fifo2pixel is

signal pixel_count, hsync_count : std_logic_vector(9 downto 0);
signal sraz_pixel_count, en_pixel_count, sraz_hsync_count, en_hsync_count : std_logic ;
signal hsync_outq, vsync_outq, hsync_outq_latched, vsync_outq_latched, pixel_out_q, pixel_clock_outq : std_logic ;
signal fifo_empty_latched : std_logic ;
signal pixel_value0, pixel_value1, pixel_value : std_logic_vector(7 downto 0);
signal fifo_data_latched : std_logic_vector(15 downto 0);
signal vsync_out_falling_edge, vsync_out_old : std_logic ;
signal fifo_rdq, fifo_rd_old, fifo_rd_rising_edge: std_logic ;
signal pixel_en : std_logic ;
signal counter_output : std_logic_vector(3 downto 0) ;

signal cycle_counter : std_logic_vector(2 downto 0);
signal pixel_clk : std_logic ;
begin


process(clk, resetn)
begin	
	if resetn = '0' then
		cycle_counter <= (others => '0') ;
	elsif clk'event and clk = '1' then
		cycle_counter <= cycle_counter + 1 ;
	end if ;
end process ;
pixel_clk <= cycle_counter(1);

process(pixel_clk, resetn)
begin	
	if resetn = '0' then
		pixel_en <= '0' ;
	elsif pixel_clk'event and pixel_clk = '1' then
		pixel_en <= (not pixel_en) ;
	end if ;
end process ;

hsync_outq_latched <= hsync_outq ;
vsync_outq_latched <= vsync_outq ;
		
		
process(pixel_clk, resetn)
begin	
	if resetn = '0' then
		y_data <= (others => '0') ;
		pixel_clock_out <= '0' ;
		hsync_out <= '0' ;
		vsync_out <= '0' ;
	elsif pixel_clk'event and pixel_clk = '1' then
		y_data <= pixel_value ;
		hsync_out <= hsync_outq_latched ;
		vsync_out <= vsync_outq_latched ;
		pixel_clock_out <= pixel_clock_outq ;
	end if ;
end process ;

			  
hsync_outq <= '1' when hsync_count < 20 else
				'1' when pixel_count > (WIDTH - 1) else
				'1' when hsync_count > (HEIGHT + 19) else
				'0' ;
				
vsync_outq <= '1' when hsync_count < 4   else --when hsync_count > 1 and 
				'0' ;
				
pixel_clock_outq <= (not pixel_en) ;
						
				
en_pixel_count <= '0' when hsync_outq_latched = '1' and line_available = '0' else
						'1' ;
						
sraz_pixel_count <= '1' when pixel_count = (WIDTH + 45) else
						'0' ;
						
sraz_hsync_count <= '1' when hsync_count = (HEIGHT + 22 ) else
						  '0' ;
	
fifo_rdq <= 	(pixel_en) when hsync_outq_latched = '0' and pixel_count(0) =  '0' else 
				   '0' ; -- to read first data ...
					
fifo_rd <= fifo_rdq ;		
				
pixel_counter : simple_counter
	 generic map(NBIT => 10)
    port map( clk => pixel_en ,
           resetn => resetn ,
           sraz => sraz_pixel_count ,
           en => en_pixel_count,
			  load => '0' ,
			  E => (others => '0'),
           Q => pixel_count
			  );
			  
en_hsync_count <= sraz_pixel_count ;

			  
hsync_counter : simple_counter
	 generic map(NBIT => 10)
    port map( clk => pixel_en ,
           resetn => resetn ,
           sraz => sraz_hsync_count ,
           en => en_hsync_count,
			  load => '0' ,
			  E => (others => '0'),
           Q => hsync_count
			  );
			  
			  
process(clk, resetn)
begin
	if resetn = '0' then
		fifo_data_latched <= (others => '0') ;
		fifo_rd_old <= '0' ;
	elsif clk'event and clk = '1' then
		if fifo_rd_rising_edge = '1' then
			pixel_value0 <= fifo_data(15 downto 8) ;
			pixel_value1  <= fifo_data(7 downto 0) ;
		end if ;
		fifo_rd_old <= fifo_rdq ;
	end if ;
end process ;
fifo_rd_rising_edge <= (not fifo_rd_old) and fifo_rdq ;

pixel_value <= pixel_value0 when pixel_count(0) = '1' else
			 pixel_value1 ;

end Behavioral;

