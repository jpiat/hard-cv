----------------------------------------------------------------------------------
-- Company:LAAS-CNRS 
-- Author:Jonathan Piat <piat.jonathan@gmail.com> 
-- 
-- Create Date:    11:48:01 03/12/2012 
-- Design Name: 
-- Module Name:    binarization - Behavioral 
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
use IEEE.NUMERIC_STD.ALL ;
use IEEE.STD_LOGIC_UNSIGNED.ALL ;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity threshold is
generic(INVERT : natural := 0; VALUE : std_logic_vector(7 downto 0) := X"FF");
port( 
 		pixel_in_data : in std_logic_vector(7 downto 0) ;
		threshold	:	in std_logic_vector(7 downto 0);
		pixel_out_data : out std_logic_vector(7 downto 0) 
);
end threshold;

architecture Behavioral of threshold is

begin

non_inv0 : if INVERT = 0 generate
pixel_out_data <= VALUE when pixel_in_data >= threshold else
						X"00" ;
end generate non_inv0;

inv0 : if INVERT = 1 generate						
pixel_out_data <= X"00" when pixel_in_data >= threshold else
						VALUE ;
end generate inv0;


end Behavioral;

