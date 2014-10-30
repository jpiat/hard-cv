-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  USE ieee.std_logic_unsigned.ALL;
  
  LIBRARY work ;
  use work.image_pack.all ;
   use work.filter_pack.all ;
	use work.utils_pack.all ;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration

         constant clk_period : time := 5 ns ;
			constant pclk_period : time := 40 ns ;
			
			signal clk, resetn : std_logic ;
			signal pxclk,pixel_in_hsync,pixel_in_vsync : std_logic ;
			signal pxclk_out, pixel_out_hsync, pixel_out_vsync : std_logic ;
			signal pxclk_out_synced, pixel_out_hsync_synced, pixel_out_vsync_synced : std_logic ;
			signal new_block : std_logic ;
			--signal block_out :  mat3 ;
			signal block_out : matNM(0 to 2, 0 to 2) ;
			signal pixel, pixel_out, pixel_out_synced: std_logic_vector(7 downto 0 ) := (others => '0');

  BEGIN
         block3X3v3_0 :  block3X3_pixel_pipeline_sp 
				port map(
						resetn => resetn, 
						pixel_in_clk => pxclk, 
						hsync =>pixel_in_hsync, 
						vsync =>pixel_in_vsync,
						pixel_in_data => pixel, 
						pixel_out_clk => pxclk_out, 
						pixel_out_hsync => pixel_out_hsync, 
						pixel_out_vsync => pixel_out_vsync,
						block_out => block_out
				);
				
--			sobel0 : sobel3x3_pixel_pipeline
--				port map(
--										resetn => resetn, 
--										pixel_in_clk => pxclk, 
--										hsync =>pixel_in_hsync, 
--										vsync =>pixel_in_vsync,
--										pixel_in_data => pixel, 
--										pixel_out_clk => pxclk_out, 
--										pixel_out_hsync => pixel_out_hsync, 
--										pixel_out_vsync => pixel_out_vsync,
--										pixel_out_data => pixel_out
--				);
--				hyst0 : hyst_threshold_pixel_pipeline
--				port map(
--										resetn => resetn, 
--										pixel_in_clk => pxclk, 
--										hsync =>pixel_in_hsync, 
--										vsync =>pixel_in_vsync,
--										pixel_in_data => pixel, 
--										pixel_out_clk => pxclk_out, 
--										pixel_out_hsync => pixel_out_hsync, 
--										pixel_out_vsync => pixel_out_vsync,
--										pixel_out_data => pixel_out
--				);
--				
--				
--			bridge0: clock_bridge 
--				generic map(SIZE => 10)
--				port map(
--						clk_fast => clk, clk_slow => pxclk_out, resetn => resetn ,
--						clk_slow_out => pxclk_out_synced ,
--						data_in(0) =>pixel_out_hsync,
--						data_in(1) =>pixel_out_vsync,
--						data_in(9 downto 2) =>pixel_out,
--						data_out(0) =>pixel_out_hsync_synced,
--						data_out(1) =>pixel_out_vsync_synced,
--						data_out(9 downto 2) =>pixel_out_synced
--						);
								
--			  block3X3v3_0 :  block3X3
--				port map(
--						clk => clk ,
--						resetn => resetn, 
--						pixel_in_clk => pxclk, 
--						hsync =>pixel_in_hsync, 
--						vsync =>pixel_in_vsync,
--						pixel_in_data => pixel, 
--						new_block => new_block ,
--						block_out => block_out
--				);
				
--				block3X3v3_0 :  blockNxN
--				generic map (N => 5)
--				port map(
--						clk => clk ,
--						resetn => resetn, 
--						pixel_in_clk => pxclk, 
--						hsync =>pixel_in_hsync, 
--						vsync =>pixel_in_vsync,
--						pixel_in_data => pixel, 
--						new_block => new_block ,
--						block_out => block_out
--				);
				

	process
	begin
		resetn <= '0' ;
		wait for 10*clk_period;
		resetn <= '1' ;
		while true loop
			clk <= '0';
			wait for clk_period;
			clk <= '1';
			wait for clk_period; 
		end loop ;
	end process;
	
process
	variable px_count, line_count, byte_count : integer := 0 ;
	begin
		pxclk <= '0';
		if px_count < 639 and line_count >= 20 and line_count < 497 then
			hsync <= '0' ;
			pixel <= pixel + 1;
		else
				hsync <= '1' ;
		end if ;

		if line_count < 3 then
			vsync <= '1' ;
		 else 
			vsync <= '0' ;
		end if ;
		wait for pclk_period;
		
		pxclk <= '1';
		if (px_count = 784 ) then
			px_count := 0 ;
			if (line_count > 510) then
			   line_count := 0;
		  else
		    line_count := line_count + 1 ;
		  end if ;
		else
		  px_count := px_count + 1 ;
		end if ;
		
		wait for pclk_period;

	end process;
  

  END;
