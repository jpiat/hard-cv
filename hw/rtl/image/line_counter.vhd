----------------------------------------------------------------------------------
-- Company:LAAS-CNRS 
-- Author:Jonathan Piat <piat.jonathan@gmail.com> 
-- 
-- Create Date:    09:34:00 03/23/2012 
-- Design Name: 
-- Module Name:    line_counter - Behavioral 
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


library work ;
use work.utils_pack.all ;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity line_counter is
		generic(POL : std_logic := '1'; MAX : positive := 480);
		port(
			clk : in std_logic; 
			resetn : in std_logic; 
			hsync, vsync : in std_logic; 
			line_count : out std_logic_vector((nbit(MAX) - 1) downto 0 )
			);
end line_counter;

architecture Behavioral of line_counter is

signal hsync_old : std_logic ;
signal line_count_temp : std_logic_vector((nbit(MAX) - 1) downto 0 ) ;
begin

-- count lines on rising edge of hsync
process(clk, resetn)
begin
if resetn = '0' then 
	line_count_temp <= (others => '0') ;
elsif clk'event and clk = '1'  then
		if vsync = '1' then
			line_count_temp <= (others => '0') ;
		elsif hsync /= hsync_old and hsync = POL then
			line_count_temp <= line_count_temp + 1 ;
		end if ;
		hsync_old <= hsync ;
end if ;
end process ;

line_count <= line_count_temp ;


end Behavioral;

