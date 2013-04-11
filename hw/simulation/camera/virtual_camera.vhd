----------------------------------------------------------------------------------
-- Company:LAAS-CNRS 
-- Author:Jonathan Piat <piat.jonathan@gmail.com> 
-- 
-- Create Date:    14:58:34 10/12/2012 
-- Design Name: 
-- Module Name:    virtual_camera - Behavioral 
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
library STD;
use STD.textio.all;                     -- basic I/O

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_textio.all;          -- I/O for logic types


library work ;
use work.pgm.all ;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity virtual_camera is
generic(IMAGE_PATH : string ; PERIOD : time := 10ns);
port(
		clk : in std_logic; 
 		resetn : in std_logic; 
 		pixel_data : out std_logic_vector(7 downto 0 ); 
 		pixel_clock_out, hsync_out, vsync_out : out std_logic );
end virtual_camera;

architecture Behavioral of virtual_camera is

type INTF is file of integer ;
begin

read_file:
    process    -- read file_io.in (one time at start of simulation)
		variable image : pixel_array_ptr ;
		variable px_count, x_count, y_count, line_count, byte_count : integer := 0 ;
    begin
		image := pgm_read(IMAGE_PATH);
      loop EXIT WHEN line_count = 277;
				pixel_clock_out <= '0';
				if px_count < 320 and line_count > 25 and line_count < 266 then
					hsync_out <= '0' ;					
					pixel_data <= std_logic_vector(to_unsigned(image.all(px_count,line_count - 26), 8)) ;
				else
						hsync_out <= '1' ;
				end if ;

				if line_count < 3 then
					vsync_out <= '1' ;
				 else 
					vsync_out <= '0' ;
				end if ;
				wait for PERIOD/2;
				
				pixel_clock_out <= '1';
				if (px_count = 575 ) then
					px_count := 0 ;
					if (line_count > 277) then
						line_count := 0;
				  else
					 line_count := line_count + 1 ;
				  end if ;
				else
				  px_count := px_count + 1 ;
				end if ;
				wait for PERIOD/2;
      end loop;
		
		
      wait; -- one shot at time zero,
    end process read_file;


end Behavioral;

