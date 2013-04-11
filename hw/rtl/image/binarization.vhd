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

entity binarization is
generic(INVERT : natural := 0; VALUE : std_logic_vector(7 downto 0) := X"FF");
port( 
 		pixel_data_in : in std_logic_vector(7 downto 0) ;
		upper_bound	:	in std_logic_vector(7 downto 0);
		lower_bound	:	in std_logic_vector(7 downto 0);
		pixel_data_out : out std_logic_vector(7 downto 0) 
);
end binarization;

architecture Behavioral of binarization is

begin

non_inv0 : if INVERT = 0 generate
pixel_data_out <= X"00" when pixel_data_in >= upper_bound else
						X"00" when pixel_data_in < lower_bound else
						VALUE ;
end generate non_inv0;

inv0 : if INVERT = 1 generate						
pixel_data_out <= VALUE when pixel_data_in >= upper_bound else
						VALUE when pixel_data_in < lower_bound else
						X"00" ;
end generate inv0;


end Behavioral;

