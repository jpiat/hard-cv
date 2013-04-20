--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package classifier_pack is

component color_classifier is
port( clk	:	in std_logic ;
		resetn	:	in std_logic ;
		pixel_clock, hsync, vsync : in std_logic; 
		pixel_clock_out, hsync_out, vsync_out : out std_logic; 
 		pixel_y : in std_logic_vector(7 downto 0) ;
		pixel_u : in std_logic_vector(7 downto 0) ;
		pixel_v : in std_logic_vector(7 downto 0) ;
		pixel_class : out std_logic_vector(7 downto 0);
		
		--color lut interface 
		color_index : out std_logic_vector(11 downto 0);
		lut_in : in std_logic_vector(7 downto 0)
);
end component;
end classifier_pack;

package body classifier_pack is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end classifier_pack;
