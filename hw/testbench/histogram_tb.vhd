--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:40:07 12/16/2013
-- Design Name:   
-- Module Name:   /home/jpiat/development/FPGA/logi-family/hard-cv/hw/testbench/histogram_tb.vhd
-- Project Name:  logibone-wishbone
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cumulative_histogram
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;


 
ENTITY histogram_tb IS
END histogram_tb;
 
ARCHITECTURE behavior OF histogram_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
	component virtual_camera is
	generic(IMAGE_PATH : string ; PERIOD : time := 10ns);
	port(
		clk : in std_logic; 
		resetn : in std_logic; 
		pixel_data : out std_logic_vector(7 downto 0 ); 
		pixel_clock_out, hsync_out, vsync_out : out std_logic );
	end component;
	
	component pgm_writer is
	generic(WRITE_PATH : STRING; HEIGHT : positive := 60; WIDTH : positive := 80 );
	port(
		clk : in std_logic; 
		resetn : in std_logic; 
		pixel_clock, hsync, vsync : in std_logic; 
		value_in : in std_logic_vector(15 downto 0 )
	);
	end component;
 
    COMPONENT cumulative_histogram
    PORT(
         clk : IN  std_logic;
         resetn : IN  std_logic;
         pixel_clock : IN  std_logic;
         hsync : IN  std_logic;
         vsync : IN  std_logic;
         pixel_data_in : IN  std_logic_vector(7 downto 0);
         reset_chist : IN  std_logic;
         chist_available : OUT  std_logic;
         chist_pixel_val : IN  std_logic_vector(7 downto 0);
         chist_val_amount : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
	 
	component adaptive_pixel_class is
		generic(image_width : positive := 320; image_height : positive := 240; nb_class : positive := 16);
		port(
			clk : in std_logic; 
			resetn : in std_logic; 
			pixel_clock, hsync, vsync : in std_logic; 
			pixel_data_in : in std_logic_vector(7 downto 0 ); 
			pixel_clock_out, hsync_out, vsync_out : out std_logic; 
			pixel_data_out : out std_logic_vector(7 downto 0 ); 
			chist_addr : out std_logic_vector(7 downto 0);
			chist_data : in std_logic_vector(31 downto 0);
			chist_available : in std_logic ;
			chist_reset : out std_logic
		);
	end component;
    

   --Inputs
   signal clk : std_logic := '0';
   signal resetn : std_logic := '0';
   signal pixel_clock : std_logic := '0';
   signal hsync : std_logic := '0';
   signal vsync : std_logic := '0';
   signal pixel_data_in : std_logic_vector(7 downto 0) := (others => '0');
   signal reset_chist : std_logic := '0';
   signal chist_pixel_val : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
	signal reset_chist_init, reset_chist_run : std_logic ;
   signal chist_available : std_logic;
   signal chist_val_amount : std_logic_vector(31 downto 0);
	signal class_pxclk_out, class_hsync_out, class_vsync_out : std_logic ;
	signal pixel_class_out : std_logic_vector(7 downto 0);
   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant pixel_clock_period : time := 40 ns;
 
BEGIN


cam0 : virtual_camera
generic map(IMAGE_PATH => "/home/jpiat/Pictures/grey-abstract-wallpaper.pgm", PERIOD => pixel_clock_period)
port map(
		clk => clk,
 		resetn => resetn,
 		pixel_data =>  pixel_data_in,
 		pixel_clock_out => pixel_clock,
		hsync_out => hsync ,
		vsync_out => vsync);
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cumulative_histogram PORT MAP (
          clk => clk,
          resetn => resetn,
          pixel_clock => pixel_clock,
          hsync => hsync,
          vsync => vsync,
          pixel_data_in => pixel_data_in,
          reset_chist => reset_chist,
          chist_available => chist_available,
          chist_pixel_val => chist_pixel_val,
          chist_val_amount => chist_val_amount
        );
		  
	uut2 : adaptive_pixel_class
			port map(
				clk => clk,
				resetn => resetn,
				pixel_clock => pixel_clock,
				hsync => hsync,
				vsync => vsync,
				pixel_data_in => pixel_data_in,
				pixel_clock_out => class_pxclk_out, 
				hsync_out => class_hsync_out, 
				vsync_out => class_vsync_out,
				pixel_data_out => pixel_class_out,
				chist_addr => chist_pixel_val,
				chist_data => chist_val_amount,
				chist_available => chist_available ,
				chist_reset => reset_chist_run 
			);
			
	writer0 : pgm_writer
	generic map(WRITE_PATH => "/home/jpiat/Pictures/pixel_class_out.pgm", HEIGHT => 480, WIDTH => 320 )
	port map(
		clk => clk,
		resetn => resetn,
		pixel_clock => class_pxclk_out, 
		hsync => class_hsync_out, 
		vsync => class_vsync_out,
		value_in(15 downto 8) => (others => '0'),
		value_in(7 downto 4) => pixel_class_out(3 downto 0),
		value_in(3 downto 0) => (others => '0')
	);		
			
   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		resetn <= '0';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
	   resetn <= '1';
		wait for 10 ns;
		reset_chist_init <= '1' ;
      wait for clk_period*2;
		reset_chist_init <= '0' ;

      -- insert stimulus here 

      wait;
   end process;

	reset_chist <= reset_chist_init when reset_chist_init = '1' else
						reset_chist_run ;

END;
