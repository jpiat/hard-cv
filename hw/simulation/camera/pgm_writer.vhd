----------------------------------------------------------------------------------
-- Company:LAAS-CNRS 
-- Author:Jonathan Piat <piat.jonathan@gmail.com> 
-- 
-- Create Date:    10:00:14 10/16/2012 
-- Design Name: 
-- Module Name:    pgm_writer - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pgm_writer is
	generic(WRITE_PATH : STRING; HEIGHT : positive := 60; WIDTH : positive := 80 );
port(
 		clk : in std_logic; 
 		resetn : in std_logic; 
 		pixel_clock, hsync, vsync : in std_logic; 
 		value_in : in std_logic_vector(15 downto 0 )
);
end pgm_writer;

architecture Behavioral of pgm_writer is
file pgmfile           : text OPEN write_mode IS WRITE_PATH ;
signal vsync_old, vsync_fe : std_logic ;
begin

	PROCESS (pixel_clock, resetn)
    VARIABLE vDataout     : integer;   -- variable written to line 
    VARIABLE vDataoutline : line;                     -- line variable written to file
	 variable isInitialized	:	boolean := false ;
	 BEGIN
		if resetn = '0' then
			vsync_old <= '0' ;
		elsif pixel_clock'event and pixel_clock = '1' then 
			if vsync_fe = '1' and NOT isInitialized then
				write(vDataoutline, string'("P2"));
				writeline (pgmfile, vDataoutline);
				write(vDataoutline, string'("#create from PGM writer"));
				writeline (pgmfile, vDataoutline);
				write(vDataoutline, WIDTH);
				write(vDataoutline, string'(" "));
				write(vDataoutline, HEIGHT);
				writeline (pgmfile, vDataoutline);
				write(vDataoutline, string'("255"));
				writeline (pgmfile, vDataoutline);
				isInitialized := TRUE ;
			elsif hsync = '0' and isInitialized then 
				 if signed(value_in) > 0 then
					if signed(value_in) > 255 then
						vDataout := 255; 
					else
						vDataout := to_integer(signed(value_in)); 
					end if ;
--					vDataout := 255; 
				 else
					vDataout := 0; 
				 end if ;
				 write (vDataoutline, vDataout);               -- write variable to line 
				 --write (vDataoutline, string'(", "));               -- write variable to line
				 writeline (pgmfile, vDataoutline);
			end if ;
			vsync_old <= vsync ;
		end if ;
  END PROCESS;
	vsync_fe <= vsync_old and (not vsync);

end Behavioral;

