-------------------------------------------------------------------------------
--
-- Simple VGA raster display
--
-- Stephen A. Edwards
-- sedwards@cs.columbia.edu
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity visualizer is
  
  port (
    --reset : in std_logic;
    clk   : in std_logic;                    -- Should be 25.125 MHz
	 reset_data: in std_logic;
	 
	 --viz_readdata  : in std_logic_vector(15 downto 0);
	 --viz_writedata : out std_logic_vector(15 downto 0);
    --viz_addr      : out std_logic_vector(17 downto 0);
	 --viz_write     : out std_logic;
    --viz_req       : out std_logic;
    --viz_ack       : in std_logic ;
	 
	 fft_fdom_addr : out unsigned(7 downto 0);
    fft_fdom_data : in signed(31 downto 0);
	 
	 ledr17 : out std_logic;
	 ledr16 : out std_logic;
	 ledr15 : out std_logic;
	 
    VGA_CLK,                         -- Clock
    VGA_HS,                          -- H_SYNC
    VGA_VS,                          -- V_SYNC
    VGA_BLANK,                       -- BLANK
    VGA_SYNC : out std_logic;        -- SYNC
    VGA_R,                           -- Red[9:0]
    VGA_G,                           -- Green[9:0]
    VGA_B : out std_logic_vector(9 downto 0) -- Blue[9:0]
    );

end visualizer;

architecture rtl of visualizer is
  
  -- Video parameters
  
  constant HTOTAL       : integer := 800;
  constant HSYNC        : integer := 96;
  constant HBACK_PORCH  : integer := 48;
  constant HACTIVE      : integer := 640;
  constant HFRONT_PORCH : integer := 16;
  
  constant VTOTAL       : integer := 525;
  constant VSYNC        : integer := 2;
  constant VBACK_PORCH  : integer := 33;
  constant VACTIVE      : integer := 480;
  constant VFRONT_PORCH : integer := 10;
  
  constant bar_w : integer := 40;
  
  type states is (A,B);

  
  
--  constant RECTANGLE_HSTART : integer := 100;
--  constant RECTANGLE_HEND   : integer := 540;
--  constant RECTANGLE_VSTART : integer := 100;
--  constant RECTANGLE_VEND   : integer := 380;

  -- Signals for the video controller
  signal Hcount : unsigned(9 downto 0);  -- Horizontal position (0-800)
  signal Vcount : unsigned(9 downto 0);  -- Vertical position (0-524)
  signal EndOfLine, EndOfField : std_logic;

  signal vga_hblank, vga_hsync,
    vga_vblank, vga_vsync : std_logic;  -- Sync. signals

  signal rectangle : std_logic;  -- rectangle area
 
  type ram_type is array (0 to 15) of std_logic_vector(19 downto 0);
  
  signal sum : ram_type := ((others=>(others =>'0')));
  
  signal read_complete  : std_logic := '0';
  signal address_r      : integer := 512;
  signal index 	      : integer := 0;
  signal sram_base      : integer := 0;
  signal counter 			: integer := 0;
  signal addr_counter   : integer := 0;
  signal sum_counter    : integer := 0;	
  signal reset        : std_logic := '0';
  signal reset_data_test : std_logic :='1';
  signal test_ones : std_logic_vector (15 downto 0) := "1011101111111110"; 
  signal test_zeros : std_logic_vector (15 downto 0) := "0000111111111111"; 
  signal test_half : std_logic_vector (15 downto 0) := "0011111111111000";
begin

  -- Horizontal and vertical counters
  
  GetData : process (clk)
  variable state : states := A;
  begin
	if rising_edge(clk) then
		--if read_complete='0' then
		case state is
			when A =>
				if reset_data_test= '1' then
					read_complete<='0';
					reset <= '0';
					state := B;
					reset_data_test <= '0';
				else 
					state:= A;
					--read_complete<='1';
				end if;
			when B =>
				--ledr15 <='0';
				if addr_counter = 0 then
					fft_fdom_addr <= to_unsigned(addr_counter,fft_fdom_addr'length);
					addr_counter  <= addr_counter + 1;
					state := B;
				elsif addr_counter < 256 then
					if addr_counter <= 16 then 
						sum(0) <= std_logic_vector(unsigned(sum(0)) + unsigned(test_zeros));--unsigned(fft_fdom_data(31 downto 16)));
					elsif addr_counter <= 32 then 
						sum(1) <= std_logic_vector(unsigned(sum(1)) + unsigned(test_half));--unsigned(fft_fdom_data(31 downto 16)));
					elsif addr_counter <= 48 then 
						sum(2) <= std_logic_vector(unsigned(sum(2)) + unsigned(test_ones));--unsigned(fft_fdom_data(31 downto 16)));
					elsif addr_counter <= 64 then 
						sum(3) <= std_logic_vector(unsigned(sum(3)) + unsigned(test_ones));--unsigned(fft_fdom_data(31 downto 16)));
					elsif addr_counter <= 80 then 
						sum(4) <= std_logic_vector(unsigned(sum(4)) + unsigned(test_half));--unsigned(fft_fdom_data(31 downto 16)));
					elsif addr_counter <= 96 then 
						sum(5) <= std_logic_vector(unsigned(sum(5)) + unsigned(test_zeros));--unsigned(fft_fdom_data(31 downto 16)));
					elsif addr_counter <= 112 then 
						sum(6) <= std_logic_vector(unsigned(sum(6)) + unsigned(test_half));--unsigned(fft_fdom_data(31 downto 16)));
					elsif addr_counter <= 128 then 
						sum(7) <= std_logic_vector(unsigned(sum(7)) + unsigned(test_half));--unsigned(fft_fdom_data(31 downto 16)));
					elsif addr_counter <= 144 then 
						sum(8) <= std_logic_vector(unsigned(sum(8)) + unsigned(test_zeros));--unsigned(fft_fdom_data(31 downto 16)));
					elsif addr_counter <= 160 then 
						sum(9) <= std_logic_vector(unsigned(sum(9)) + unsigned(test_zeros));--unsigned(fft_fdom_data(31 downto 16)));
					elsif addr_counter <= 176 then 
						sum(10) <= std_logic_vector(unsigned(sum(10)) + unsigned(test_half));--unsigned(fft_fdom_data(31 downto 16)));
					elsif addr_counter <= 192 then 
						sum(11) <= std_logic_vector(unsigned(sum(11)) + unsigned(test_zeros));--unsigned(fft_fdom_data(31 downto 16)));
					elsif addr_counter <= 208 then 
						sum(12) <= std_logic_vector(unsigned(sum(12)) + unsigned(test_ones));--unsigned(fft_fdom_data(31 downto 16)));
					elsif addr_counter <= 224 then 
						sum(13) <= std_logic_vector(unsigned(sum(13)) + unsigned(test_half));--unsigned(fft_fdom_data(31 downto 16)));
					elsif addr_counter <= 240 then 
						sum(14) <= std_logic_vector(unsigned(sum(14)) + unsigned(test_ones));--unsigned(fft_fdom_data(31 downto 16)));
					else
						sum(15) <= std_logic_vector(unsigned(sum(15)) + unsigned(test_half));--unsigned(fft_fdom_data(31 downto 16)));
					end if;
					fft_fdom_addr <= to_unsigned(addr_counter,fft_fdom_addr'length);
					addr_counter  <= addr_counter + 1;
					state := B;
				else
					addr_counter <= 0;
					read_complete<='1';
					reset_data_test<= '0';
					--ledr17 <= '1';
					sum(15) <= std_logic_vector(unsigned(sum(15)) + unsigned(test_zeros));--unsigned(fft_fdom_data(31 downto 16)));
					--test
					reset <= '0';
					state := A;
				end if;
			end case;
		end if;
	--end if;
end process GetData;

  HCounter : process (clk)
  begin
    if rising_edge(clk) then
		if read_complete='1' then
			if reset = '1' then
			  Hcount <= (others => '0');
			elsif EndOfLine = '1' then
			  Hcount <= (others => '0');
			else
			  Hcount <= Hcount + 1;
			end if;      
		end if;
	end if;
  end process HCounter;

  EndOfLine <= '1' when Hcount = HTOTAL - 1 else '0';
  
  VCounter: process (clk)
  begin
    if rising_edge(clk) then
		if read_complete='1' then	 
			if reset = '1' then
			  Vcount <= (others => '0');
			elsif EndOfLine = '1' then
			  if EndOfField = '1' then
				 Vcount <= (others => '0');
			  else
				 Vcount <= Vcount + 1;
			  end if;
			end if;
		end if;
    end if;
  end process VCounter;

  EndOfField <= '1' when Vcount = VTOTAL - 1 else '0';
  

  -- State machines to generate HSYNC, VSYNC, HBLANK, and VBLANK

  HSyncGen : process (clk)
  begin
    if rising_edge(clk) then
		if read_complete='1' then
			if reset = '1' or EndOfLine = '1' then
			  vga_hsync <= '1';
			elsif Hcount = HSYNC - 1 then
			  vga_hsync <= '0';
			end if;
		 end if;
		end if;
  end process HSyncGen;
  
  HBlankGen : process (clk)
  begin
    if rising_edge(clk) then
		if read_complete='1' then
			if reset = '1' then
			  vga_hblank <= '1';
			elsif Hcount = HSYNC + HBACK_PORCH then
			  vga_hblank <= '0';
			elsif Hcount = HSYNC + HBACK_PORCH + HACTIVE then
			  vga_hblank <= '1';
			end if;      
		 end if;
		end if;
  end process HBlankGen;

  VSyncGen : process (clk)
  begin
    if rising_edge(clk) then
		if read_complete='1' then
			if reset = '1' then
			  vga_vsync <= '1';
			elsif EndOfLine ='1' then
			  if EndOfField = '1' then
				 vga_vsync <= '1';
			  elsif Vcount = VSYNC - 1 then
				 vga_vsync <= '0';
			  end if;
			end if;
		end if;
    end if;
  end process VSyncGen;

  VBlankGen : process (clk)
  begin
    if rising_edge(clk) then   
		if read_complete='1' then
			if reset = '1' then
			  vga_vblank <= '1';
			elsif EndOfLine = '1' then
			  if Vcount = VSYNC + VBACK_PORCH - 1 then
				 vga_vblank <= '0';
			  elsif Vcount = VSYNC + VBACK_PORCH + VACTIVE - 1 then
				 vga_vblank <= '1';
			  end if;
			end if;
		end if;
    end if;
  end process VBlankGen;

  -- Rectangle generator

--  RectangleHGen : process (clk)
--  begin
--    if rising_edge(clk) then     
--      if reset = '1' or Hcount = HSYNC + HBACK_PORCH + RECTANGLE_HSTART then
--        rectangle_h <= '1';
--      elsif Hcount = HSYNC + HBACK_PORCH + RECTANGLE_HEND then
--        rectangle_h <= '0';
--      end if;      
--    end if;
--  end process RectangleHGen;
--
--  RectangleVGen : process (clk)
--  begin
--    if rising_edge(clk) then
--      if reset = '1' then       
--        rectangle_v <= '0';
--      elsif EndOfLine = '1' then
--        if Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_VSTART then
--          rectangle_v <= '1';
--        elsif Vcount = VSYNC + VBACK_PORCH - 1 + RECTANGLE_VEND then
--          rectangle_v <= '0';
--        end if;
--      end if;      
--    end if;
--  end process RectangleVGen;
--
--  rectangle <= rectangle_h and rectangle_v;

RectangleGen: process (clk)
begin
	if rising_edge(clk) then
		if read_complete='1' then
		--ledr17 <= '1';
		if reset='1' then
			rectangle<='0';
		--division 1
		elsif Hcount >= HSYNC+HBACK_PORCH AND Hcount<=HSYNC+HBACK_PORCH+bar_w then
			if Vcount > VTOTAL-VFRONT_PORCH-to_integer(unsigned(sum(0)(19 downto 11))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 2
		elsif Hcount>=HSYNC+HBACK_PORCH+bar_w AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*2) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(sum(1)(19 downto 11))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 3
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*2) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*3) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(sum(2)(19 downto 11))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 4
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*3) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*4) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(sum(3)(19 downto 11))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 5
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*4) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*5) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(sum(4)(19 downto 11))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 6
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*5) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*6) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(sum(5)(19 downto 11))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 7
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*6) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*7) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(sum(6)(19 downto 11))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 8
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*7) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*8) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(sum(7)(19 downto 11))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 9
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*8) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*9) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(sum(8)(19 downto 11))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 10
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*9) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*10) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(sum(9)(19 downto 11))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 11
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*10) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*11) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(sum(10)(19 downto 11))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 12
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*11) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*12) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(sum(11)(19 downto 11))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 13
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*12) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*13) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(sum(12)(19 downto 11))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 14
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*13) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*14) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(sum(13)(19 downto 11))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 15
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*14) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*15) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(sum(14)(19 downto 11))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 16
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*15) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*16) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(sum(15)(19 downto 11))) then
				--ledr16 <= '1';
				rectangle<='1';
			else rectangle <='0';
			end if;
		else
			rectangle<='0';
			end if;
		end if;
	end if;
end process RectangleGen;

  -- Registered video signals going to the video DAC

  VideoOut: process (clk, reset)
  begin
  if read_complete='1' then
		 if reset = '1' then
			ledr17<='1';
			VGA_R <= "0000000000";
			VGA_G <= "1111111111";
			VGA_B <= "0000000000";
		 elsif clk'event and clk = '1' then
			if rectangle = '1' then
				ledr16<='1';
			VGA_R <= "0000000000";
			VGA_G <= "1111111111";
			VGA_B <= "1110011111";
			elsif vga_hblank = '0' and vga_vblank ='0' then
				ledr15<='1';
			  VGA_R <= "0000000011";
			  VGA_G <= "0000000011";
			  VGA_B <= "0000000011";
			else
			  VGA_R <= "0000000011";
			  VGA_G <= "0000000011";
			  VGA_B <= "0000000011";    
			end if;
		 end if;
	end if;
  end process VideoOut;

  VGA_CLK <= clk;
  VGA_HS <= not vga_hsync;
  VGA_VS <= not vga_vsync;
  VGA_SYNC <= '0';
  VGA_BLANK <= not (vga_hsync or vga_vsync);

end rtl;
