-------------------------------------------------------------------------------
--
-- Visualizer
-- draws rectangles of varying heights to correspond to
-- fft frequency bins and their respective amplitudes
--
-- for kanto music player
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity visualizer is
  
  port (
    clk25   : in std_logic;                    -- Should be 25.125 MHz
    clk50 : in std_logic;
    reset_data: in std_logic;
    fft_fdom_addr : out unsigned(7 downto 0);
    fft_fdom_data : in signed(31 downto 0);
	 
    ledr17 : out std_logic;
    ledr16 : out std_logic;
    ledr15 : out std_logic;
    
    sw_r : in std_logic;
    sw_g : in std_logic;
    sw_b : in std_logic;
	 
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
  
<<<<<<< HEAD
  type states is (initializing, reading_data);
=======
  type states is (A,B);
  type rectgenstates is (blreset, bl0x0, bl0x1, bl0x2, bl0x3, bl0x4, bl0x5, bl0x6,
                         bl0x7, bl0x8, bl0x9, bl0xa, bl0xb, bl0xc, bl0xd, bl0xe,
                         bl0xf);
>>>>>>> 575b55077d60dbe0c56d68bc455fa9b2c2e571d4
  
  -- Signals for the video controller
  signal Hcount : unsigned(9 downto 0);  -- Horizontal position (0-800)
  signal Vcount : unsigned(9 downto 0);  -- Vertical position (0-524)
  signal EndOfLine, EndOfField : std_logic;

  signal vga_hblank, vga_hsync,
    vga_vblank, vga_vsync : std_logic;  -- Sync. signals

  signal rectangle : std_logic;  -- rectangle area
 
  type ram_type is array (0 to 15) of unsigned(19 downto 0);
  
  signal current_sum : ram_type := ((others=>(others =>'0')));
  signal next_sum : ram_type := ((others=>(others =>'0')));
  
  signal address_r      : integer := 512;
  signal index 	        : integer := 0;
  signal sram_base      : integer := 0;
  signal counter 	: integer := 0;
  signal addr_counter   : unsigned(7 downto 0) := x"00";
  signal sum_counter    : unsigned(4 downto 0) := "00000";
  signal test_ones      : unsigned (15 downto 0) := "1111111111111111"; 
  signal test_zeros     : std_logic_vector (15 downto 0) := "0000111111111111"; 
  signal test_half      : std_logic_vector (15 downto 0) := "0111111111111111";
  signal oldsum : unsigned(19 downto 0);
  signal last_fdom_data : signed(15 downto 0);
  
  -- reset stuff
  signal reset          : std_logic := '0'; -- resets the screen
  
begin

  -- Horizontal and vertical counters
  
  fft_fdom_addr <= addr_counter;
  oldsum <= next_sum(to_integer(sum_counter(4 downto 1)));
  
  GetData : process (clk50)
  variable state : states := initializing;
  begin
	if rising_edge(clk50) then
		case state is
		    when initializing =>
			if reset_data = '1' then
                next_sum <= ((others=>(others =>'0')));
                last_fdom_data <= (others => '0');
                sum_counter <= (others => '0');
                addr_counter <= (others => '0');
                reset <= '0';

			    state := reading_data;
			else 
			    state:= initializing;
                reset<='0';
			end if;
		    when reading_data =>
            if sum_counter = x"1F" then -- count up to 31
                addr_counter <= x"00";
                sum_counter <= "00000";
                state := initializing;
                --sum(to_integer(sum_counter(7 downto 4))) <= sum(to_integer(sum_counter(7 downto 4))) + test_ones;

                if last_fdom_data(15) = '1' then
                         next_sum(to_integer(sum_counter(4 downto 1))) <= oldsum 
                                + unsigned(not last_fdom_data(14 downto 0));

                else 
                    next_sum(to_integer(sum_counter(4 downto 1))) <= oldsum 
                                + unsigned(last_fdom_data(14 downto 0));
                end if;
                ledr15 <= '0';
                ledr16 <= '1';
                ledr17 <= '0';
            else
                --sum(to_integer(sum_counter(7 downto 4))) <= sum(to_integer(sum_counter(7 downto 4))) + test_ones;
                if last_fdom_data(15) = '1' then
                         next_sum(to_integer(sum_counter(4 downto 1))) <= oldsum 
                                + unsigned(not last_fdom_data(14 downto 0));

                else 
                    next_sum(to_integer(sum_counter(4 downto 1))) <= oldsum 
                                + unsigned(last_fdom_data(14 downto 0));
                end if;
                ledr15 <= '1';
                ledr16 <= '0';
                ledr17 <= '1';
                addr_counter  <= addr_counter + 1;
                sum_counter <= addr_counter(4 downto 0);
                last_fdom_data <= fft_fdom_data(31 downto 16);

                state := reading_data;

            end if;
			end case;
		end if;
	--end if;
end process GetData;

  -- Horizontal and vertical counters

  HCounter : process (clk25)
  begin
    if rising_edge(clk25) then      
      if reset = '1' then
        Hcount <= (others => '0');
      elsif EndOfLine = '1' then
        Hcount <= (others => '0');
      else
        Hcount <= Hcount + 1;
      end if;      
    end if;
  end process HCounter;

  EndOfLine <= '1' when Hcount = HTOTAL - 1 else '0';
  
  VCounter: process (clk25)
  begin
    if rising_edge(clk25) then      
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
  end process VCounter;

  EndOfField <= '1' when Vcount = VTOTAL - 1 else '0';

  -- State machines to generate HSYNC, VSYNC, HBLANK, and VBLANK

  HSyncGen : process (clk25)
  begin
    if rising_edge(clk25) then     
      if reset = '1' or EndOfLine = '1' then
        vga_hsync <= '1';
      elsif Hcount = HSYNC - 1 then
        vga_hsync <= '0';
      end if;
    end if;
  end process HSyncGen;
  
  HBlankGen : process (clk25)
  begin
    if rising_edge(clk25) then
      if reset = '1' then
        vga_hblank <= '1';
      elsif Hcount = HSYNC + HBACK_PORCH then
        vga_hblank <= '0';
      elsif Hcount = HSYNC + HBACK_PORCH + HACTIVE then
        vga_hblank <= '1';
      end if;      
    end if;
  end process HBlankGen;
  
  VSyncGen : process (clk25)
  begin
    if rising_edge(clk25) then
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
  end process VSyncGen;

  VBlankGen : process (clk25)
  begin
    if rising_edge(clk25) then    
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
  end process VBlankGen;
  
RectangleGen: process (clk25)
variable bar : rectgenstates := blreset;
begin
	if rising_edge(clk25) then
		if reset='1' then
			rectangle<='0';
		--division 1
		elsif Hcount >= HSYNC+HBACK_PORCH AND Hcount<=HSYNC+HBACK_PORCH+bar_w then
			if Vcount > VTOTAL-VFRONT_PORCH-to_integer(current_sum(0)(9 downto 2)) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 2
		elsif Hcount>=HSYNC+HBACK_PORCH+bar_w AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*2) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(current_sum(1)(9 downto 2)) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 3
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*2) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*3) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(current_sum(2)(9 downto 2)) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 4
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*3) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*4) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(current_sum(3)(9 downto 2)) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 5
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*4) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*5) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(current_sum(4)(9 downto 2)) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 6
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*5) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*6) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(current_sum(5)(9 downto 2)) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 7
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*6) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*7) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(current_sum(6)(9 downto 2)) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 8
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*7) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*8) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(current_sum(7)(9 downto 2)) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 9
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*8) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*9) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(current_sum(8)(9 downto 2)) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 10
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*9) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*10) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(current_sum(9)(9 downto 2)) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 11
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*10) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*11) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(current_sum(10)(9 downto 2)) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 12
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*11) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*12) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(current_sum(11)(9 downto 2)) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 13
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*12) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*13) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(current_sum(12)(9 downto 2)) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 14
        elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*12) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*14) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(current_sum(13)(9 downto 2)) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 15
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*14) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*15) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(current_sum(14)(9 downto 2)) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		--division 16
		elsif Hcount>=HSYNC+HBACK_PORCH+(bar_w*15) AND Hcount<=HSYNC+HBACK_PORCH+(bar_w*16) then
			if Vcount>VTOTAL-VFRONT_PORCH-to_integer(current_sum(15)(9 downto 2)) then
				rectangle<='1';
			else rectangle <='0';
			end if;
		else
			rectangle<='0';
		end if;
	end if;
    if vga_hblank = '1' and vga_vblank = '1' then
        current_sum <= next_sum;
    end if;

end process RectangleGen;

  -- Registered video signals going to the video DAC

  VideoOut: process (clk25, reset)
  begin
    if reset = '1' then
      VGA_R <= "0000000000";
      VGA_G <= "0000000000";
      VGA_B <= "0000000000";
    elsif clk25'event and clk25 = '1' then
      if rectangle = '1' then
        if sw_r = '1' then
            VGA_R <= "0000000000";
         else VGA_R <= "1111111111";
         end if;
                
        if sw_g = '1' then
           VGA_G <= "0000000000";
        else VGA_G <= "1111111111";
        end if;
            
        if sw_b = '1' then
           VGA_B <= "0000000000";
        else VGA_B <= "1111111111";
        end if;
    elsif vga_hblank = '0' and vga_vblank ='0' then
        VGA_R <= "0000000000";
        VGA_G <= "0000000000";
        VGA_B <= "0000000000";
    else
        VGA_R <= "0000000000";
        VGA_G <= "0000000000";
        VGA_B <= "0000000000";    
    end if;
  end if;
  end process VideoOut;

  VGA_CLK <= clk25;
  VGA_HS <= not vga_hsync;
  VGA_VS <= not vga_vsync;
  VGA_SYNC <= '0';
  VGA_BLANK <= not (vga_hsync or vga_vsync);

end rtl;
