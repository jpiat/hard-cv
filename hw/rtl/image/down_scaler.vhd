library IEEE;
        use IEEE.std_logic_1164.all;
        use IEEE.std_logic_unsigned.all;
		  use ieee.numeric_std.all ;
library work;
        use work.image_pack.all ;
		  use work.utils_pack.all ;
		  use work.primitive_pack.all ;
		  
--down scale with factor 8 incoming frame
entity down_scaler is
	generic(SCALING_FACTOR : natural := 8; INPUT_WIDTH : natural := 640; INPUT_HEIGHT : natural := 480 );
	port(
 		clk : in std_logic; 
 		resetn : in std_logic; 
 		pixel_clock, hsync, vsync : in std_logic; 
 		pixel_clock_out, hsync_out, vsync_out : out std_logic; 
 		pixel_data_in : in std_logic_vector(7 downto 0 ); 
 		pixel_data_out : out std_logic_vector(7 downto 0 )
	); 
end down_scaler;

--architecture systemc of down_scaler is
--	constant NBIT : integer := integer(ceil(log2(real(INPUT_WIDTH/SCALING_FACTOR)))); -- number of bits for addresses
--	constant SHIFT_LENGTH : integer := integer(ceil(log2(real(SCALING_FACTOR))));
--	TYPE scaler_state IS (WAIT_FRAME, WAIT_LINE, WAIT_PIXEL, WRITE_PIXEL) ; 
--	signal line_ram_addr : std_logic_vector(NBIT-1 downto 0 ) ; 
--	signal line_ram_data_in, line_ram_data_out : std_logic_vector(15 downto 0 ) ; 
--	signal line_ram_we : std_logic ; 
--	signal add_result : std_logic_vector(15 downto 0 ) ; 
--	signal add_temp : std_logic_vector(15 downto 0 ); 
--	signal nb_line_accumulated : std_logic_vector(2 downto 0 ) ; 
--	signal nb_pix_accumulated : std_logic_vector(2 downto 0 ) ; 
--	signal nb_line_output : std_logic_vector(5 downto 0 ) ;
--	signal state : scaler_state ;
--	begin
--	
--	line_ram0 : dpram_NxN --line ram to accumulate data
--		generic map(SIZE => INPUT_WIDTH/SCALING_FACTOR, NBIT => 16, ADDR_WIDTH => NBIT)
--		port map ( 
--			clk => clk, 
--			a => line_ram_addr, 
--			dpra => (others => '0'),
--			di => line_ram_data_in,
--			spo => line_ram_data_out,
--			dpo => open,
--			we => line_ram_we
--		); 
--	
--	pixel_data_out <= line_ram_data_out((SHIFT_LENGTH + 7) downto SHIFT_LENGTH) ; --output data is shifted by 3 for division by 8
--	add_temp <= (add_result + ("00000000" & pixel_data_in)) ; -- pixel are accumulated into a register
--
--	-- down_scaler_process
--	process(clk, resetn)
--		 begin
--		 	if resetn = '0'  then
--		 		nb_line_accumulated <= (others => '0') ; 
--		 		nb_pix_accumulated <= (others => '0') ; 
--				nb_line_output <= (others => '0') ; 
--		 		add_result <= (others => '0') ; 
--		 		state <= wait_frame ;
--		 	elsif  clk'event and clk = '1'  then
--		 			case state is
--						when wait_frame => -- waiting for a new frame
--							pixel_clock_out <= '0' ;
--		 					line_ram_we <= '0' ;
--							vsync_out <= '1' ;
--							if  vsync = '1' and hsync = '1' then
--								nb_line_accumulated <= (others => '0') ;
--		 					   nb_pix_accumulated <= (others => '0') ;
--								nb_line_output <= (others => '0') ; 
--		 					   line_ram_addr <= (others => '0') ;
--		 					   hsync_out <= '1' ;
--		 					   add_result <= (others => '0') ;
--								state <= wait_pixel ;
--							end if;
--		 				when wait_line => --waiting for the next line
--							vsync_out <= '0' ;
--		 					pixel_clock_out <= '0' ;
--		 					line_ram_we <= '0' ;
--		 					if hsync = '1'  then
--								line_ram_addr <= (others => '0') ; 
--		 						nb_pix_accumulated <= (others => '0') ; 
--		 						if  nb_line_accumulated = (SCALING_FACTOR -1)  then -- 8 lines were accumulated
--		 							nb_line_accumulated <= (others => '0') ; 
--		 							add_result <= (others => '0') ; 
--									nb_line_output <= (nb_line_output + 1) ;
--									hsync_out <= '1' ;
--								else
--		 							hsync_out <= '0' ; 
--									nb_line_accumulated <= nb_line_accumulated + 1 ;
--		 						end if ; 
--		 						line_ram_we <= '0' ; 
--								state <= wait_pixel ;
--		 					end if ;
--		 				when wait_pixel => 
--							vsync_out <= '0' ;
--		 					line_ram_we <= '0' ;
--							if nb_line_output = (INPUT_HEIGHT/SCALING_FACTOR) then --all line were output
--								state <= wait_frame ;
--							elsif line_ram_addr = (INPUT_WIDTH/SCALING_FACTOR) then --all pixels were averaged
--								state <= wait_line ;
--		 					elsif  pixel_clock = '1'  then
--		 						pixel_clock_out <= '0' ;  
--		 						if  nb_pix_accumulated = 0  then
--		 							add_result <= "00000000" & pixel_data_in ; --first pixel of block
--		 						elsif  nb_pix_accumulated = (SCALING_FACTOR -1)  then -- 8 pixels were summed
--		 							if  nb_line_accumulated = 0  then -- first line
--		 								line_ram_data_in <= "00000000" & add_temp((SHIFT_LENGTH + 7) downto SHIFT_LENGTH) ; --writing pixels average to ram
--		 							else
--		 								line_ram_data_in <= (("00000000" & add_temp((SHIFT_LENGTH + 7) downto SHIFT_LENGTH)) + line_ram_data_out) ; --ading pixels average to previously averaged pixels
--		 							end if ; 
--		 							line_ram_we <= '1' ; 
--		 						else
--		 							add_result <= add_temp ;
--		 						end if ; 
--		 						state <= write_pixel ;
--		 					end if ;
--		 				when write_pixel => 
--							vsync_out <= '0' ;
--							hsync_out <= '0' ; 
--		 					line_ram_we <= '0' ;
--		 					if pixel_clock = '0'  then -- waiting for falling edge of pxclk
--		 						if  nb_line_accumulated = (SCALING_FACTOR -1)  AND  nb_pix_accumulated = (SCALING_FACTOR -1)  then
--		 							pixel_clock_out <= '1' ;
--		 						else
--		 							pixel_clock_out <= '0' ;
--		 						end if ; 
--		 						if  nb_pix_accumulated = (SCALING_FACTOR -1)  then
--		 							line_ram_addr <= line_ram_addr + 1 ; 
--		 							nb_pix_accumulated <= (others => '0') ;
--		 						else
--		 							nb_pix_accumulated <= (nb_pix_accumulated + 1) ;
--		 						end if ; 
--		 						state <= wait_pixel ;
--		 					end if ;
--		 				when others => 
--								state <= wait_frame ;
--		 			end case ;
--		 	end if ;
--		 end process;  
--	
--end systemc ;


architecture RTL of down_scaler is
	constant NBIT_ADDR : integer := nbit(INPUT_WIDTH/SCALING_FACTOR); -- number of bits for addresses
	signal line_ram_addr : std_logic_vector(NBIT_ADDR-1 downto 0 ) ; 
	signal line_ram_data_in, line_ram_data_out, sum : std_logic_vector(15 downto 0 ) ; 
	signal line_ram_we : std_logic ; 
	signal pixel_counter : std_logic_vector(nbit(INPUT_WIDTH)-1 downto 0 ) ; 
	signal modulo_counter : std_logic_vector(nbit(SCALING_FACTOR)-1 downto 0 ) ; 
	signal line_counter : std_logic_vector(nbit(SCALING_FACTOR)-1 downto 0 ) ; 
	signal pxclk_re, hsync_re, hsync_fe,vsync_re, pxclk_old, hsync_old, vsync_old : std_logic ;
	signal hsync_t : std_logic ;
	signal pixel_out_t : std_logic_vector(7 downto 0);
	begin
	
	line_ram0 : dpram_NxN --line ram to accumulate data
		generic map(SIZE => (INPUT_WIDTH/SCALING_FACTOR + 4), NBIT => 16, ADDR_WIDTH => NBIT_ADDR)
		port map ( 
			clk => clk, 
			a => line_ram_addr, 
			dpra => (others => '0'),
			di => line_ram_data_in,
			spo => line_ram_data_out,
			dpo => open,
			we => line_ram_we
		); 
	
	
	
	line_ram_data_in <= sum when line_counter(nbit(SCALING_FACTOR)-1 downto 0)  /= 0 else
							  sum when pixel_counter(nbit(SCALING_FACTOR)-1 downto 0)  > 0 else
							  (X"00" & pixel_data_in) ;
	
	line_ram_addr <= pixel_counter((nbit(SCALING_FACTOR)+NBIT_ADDR-1) downto nbit(SCALING_FACTOR)) when pixel_counter < INPUT_WIDTH else
						  (others => '0');
	
	line_ram_we <= pxclk_re when hsync = '0' else
						'0' ;
						
	sum <= line_ram_data_out + pixel_data_in ;
	
	pixel_out_t <= sum((2*nbit(SCALING_FACTOR)+7)  downto 2*nbit(SCALING_FACTOR));
	
	process(clk, resetn)
	begin
		if resetn = '0' then
			pixel_counter <= (others => '0') ;
		elsif clk'event and clk = '1' then
			if hsync_fe = '1' then
				pixel_counter <= (others => '0') ;
			elsif pxclk_re = '1' then
				pixel_counter <= pixel_counter + 1 ;
			end if ;
		end if ;
	end process ;
	
	pixel_clock_out <= (not pixel_counter(nbit(SCALING_FACTOR)-1)) when pixel_counter >= SCALING_FACTOR else
							 '0' ;
	
	process(clk, resetn)
	begin
		if resetn = '0' then
			line_counter <= (others => '0') ;
		elsif clk'event and clk = '1' then
			if vsync_re = '1' then
				line_counter <= (others => '0') ;
			elsif hsync_re = '1' then
				line_counter <= line_counter + 1 ;
			end if;
		end if ;
	end process ;
	hsync_t <= '1' when line_counter < (SCALING_FACTOR - 1) else
				  hsync ;
	
	process(clk, resetn)
	begin
		if resetn = '0' then
			pxclk_old <= '0' ;
			hsync_old <= '0' ;
			vsync_old <= '0' ;
		elsif clk'event and clk = '1' then
			pxclk_old  <= pixel_clock;
			hsync_old <= hsync ;
			vsync_old <= vsync ;
		end if ;
	end process ;
	pxclk_re <= (not pxclk_old) and  pixel_clock ;
	hsync_re <= (not hsync_old) and hsync ;
	hsync_fe <= (hsync_old) and (not hsync) ;
	vsync_re <= (not vsync_old) and vsync ;
	
	
	process(clk)
	begin
		if clk'event and clk = '1' then
			vsync_out <= vsync ;
			hsync_out <= hsync_t ;
			if pxclk_re = '1' then
				pixel_data_out <= pixel_out_t ;
			end if ;
		end if ;
	end process ;
	
	
end RTL ;