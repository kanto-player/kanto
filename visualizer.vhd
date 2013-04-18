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
    reset : in std_logic;
    clk   : in std_logic;                    -- Should be 25.125 MHz
	 
	 viz_readdata  : in std_logic_vector(15 downto 0);
	 viz_writedata : out std_logic_vector(15 downto 0);
    viz_addr      : out std_logic_vector(17 downto 0);
	 viz_write     : out std_logic;
    viz_req       : out std_logic;
    viz_ack       : in std_logic ;
	 
    VGA_CLK,                         -- Clock
    VGA_HS,                          -- H_SYNC
    VGA_VS,                          -- V_SYNC
    VGA_BLANK,                       -- BLANK
    VGA_SYNC : out std_logic;        -- SYNC
    VGA_R,                           -- Red[9:0]
    VGA_G,                           -- Green[9:0]
    VGA_B : out unsigned(9 downto 0) -- Blue[9:0]
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
  
  type states is (A,B,C,D);

  
  
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
  
  type ram_type is array(0 to 255) of std_logic_vector(15 downto 0);
  signal ram_data : ram_type;
  
  signal read_complete : std_logic := '0';
  signal address_r : integer := 512;
  signal index : integer := 0;
  signal sram_base : integer := 0;
  signal counter : integer := 0;

begin

  -- Horizontal and vertical counters
  
  GetData : process (clk)
  variable state : states := A;
  begin
	if rising_edge(clk) then
		if read_complete='0' then
		case state is
			when A =>
				viz_req<='1';
				viz_write<='0';
				viz_addr<= std_logic_vector(to_unsigned(address_r,viz_addr'length));
				if viz_ack='1' then
					ram_data(index)<=viz_readdata;
					viz_req<='0';
					state := B;
				else 
					state := A;
				end if;
			when B =>
				if address_r=752 then
					state := C;
				else
					address_r <= address_r+16;
					index<=index+1;
					state := A;
				end if;
			when C =>
				if counter=500000 then
					read_complete<='1';
					counter<=0;
					state := D;
				else
					counter<=counter+1;
					state:=C;
				end if;
			when D =>
				if(read_complete='1') then
					state := D;
					if(Vcount = VTOTAL-1 AND Hcount=HTOTAL-1) then
						read_complete<='0';
					end if;
				else
					state :=A;
				end if;
			end case;
		end if;
	end if;
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
		if reset='1' then
			rectangle<='0';
		--division 1
		elsif Hcount >= HSYNC+HBACK_PORCH AND Hcount<=HSYNC+HBACK_PORCH+bar_w then
			if Vcount > VTOTAL-VFRONT_PORCH-to_integer(unsigned(ram_data(sram_base)(15 downto 8))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 2
		elsif Hcount>=HSYNC+HBACK_PORCH+bar_w AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*2) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(ram_data(sram_base+16)(15 downto 8))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 3
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*2) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*3) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(ram_data(sram_base+32)(15 downto 8))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 4
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*3) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*4) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(ram_data(sram_base+48)(15 downto 8))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 5
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*4) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*5) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(ram_data(sram_base+64)(15 downto 8))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 6
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*5) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*6) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(ram_data(sram_base+80)(15 downto 8))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 7
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*6) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*7) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(ram_data(sram_base+96)(15 downto 8))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 8
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*7) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*8) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(ram_data(sram_base+112)(15 downto 8))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 9
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*8) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*9) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(ram_data(sram_base+128)(15 downto 8))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 10
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*9) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*10) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(ram_data(sram_base+144)(15 downto 8))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 11
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*10) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*11) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(ram_data(sram_base+160)(15 downto 8))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 12
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*11) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*12) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(ram_data(sram_base+176)(15 downto 8))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 13
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*12) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*13) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(ram_data(sram_base+192)(15 downto 8))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 14
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*13) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*14) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(ram_data(sram_base+208)(15 downto 8))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 15
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*14) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*15) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(ram_data(sram_base+224)(15 downto 8))) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 16
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*15) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*16) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(unsigned(ram_data(sram_base+240)(15 downto 8))) then
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
			VGA_R <= "0000000000";
			VGA_G <= "0000000000";
			VGA_B <= "0000000000";
		 elsif clk'event and clk = '1' then
			if rectangle = '1' then
			  VGA_R <= "1111111111";
			  VGA_G <= "1111111111";
			  VGA_B <= "1111111111";
			elsif vga_hblank = '0' and vga_vblank ='0' then
			  VGA_R <= "0000000000";
			  VGA_G <= "0000000000";
			  VGA_B <= "1111111111";
			else
			  VGA_R <= "0000000000";
			  VGA_G <= "0000000000";
			  VGA_B <= "0000000000";    
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
