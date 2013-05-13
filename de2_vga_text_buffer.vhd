library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity de2_vga_text_buffer is
port(
    vga_clk : in std_logic;
    vga_reset : in std_logic;
    vga_read : in std_logic;
    vga_write : in std_logic;
    vga_chipselect : in std_logic;
    -- there are 80 x 5 = 400 characters
    -- 400 * 4 parts per character = 1600 parts
    -- so 11 bit addressing
    vga_address : in std_logic_vector(10 downto 0);
    -- each character part is 32 bits
    vga_readdata : out std_logic_vector(31 downto 0);
    vga_writedata : in std_logic_vector(31 downto 0);
    
    -- the following are accessed by a vga driver
    -- give me a pixel coordinate (on a 640x80 plane)
    -- and I'll tell you if it's on or off
    --
    -- it's 40 pixels high because we have 5 lines,
    -- each 16 pixels high
    display_pixel_on : out std_logic;
    display_x : in std_logic_vector(9 downto 0);
    display_y : in std_logic_vector(6 downto 0)
);
end de2_vga_text_buffer;

architecture rtl of de2_vga_text_buffer is

    -- there are 16 lines in each character font.
    -- first line of ever character goes in one array, second line in
    -- another array, etc. -- this lets us write and read in parallel
    --
    -- this also keeps us within the 4kbit size of a block ram
    type font_line_ram_type is array(0 to 399) of unsigned(7 downto 0);
    type font_ram_type is array(0 to 15) of font_line_ram_type;
    signal font_ram : font_ram_type := (others => (others => (others => '0')));
    
    signal addr : integer;
    signal x : integer;
    signal y : integer;
    signal inner_x : integer;

begin

    addr <= to_integer(unsigned(vga_address(10 downto 2)));

    process(vga_clk)
    begin
    if rising_edge(vga_clk) then
    
    -- if the processor tries to write a character part, we split
    -- it up and do it in parallel (using multiple block rams
    -- comes in handy)
    
    -- since we can only write one character part at a time, and
    -- each character is composed of four character parts, we look at the
    -- bottom two bits of the address to determine which lines this
    -- character part belongs on
    if vga_write = '1' then
        case vga_address(1 downto 0) is
            when "00" =>
                font_ram(0)(addr) <= unsigned(vga_writedata(31 downto 24));
                font_ram(1)(addr) <= unsigned(vga_writedata(23 downto 16));
                font_ram(2)(addr) <= unsigned(vga_writedata(15 downto 8));
                font_ram(3)(addr) <= unsigned(vga_writedata(7 downto 0));
            when "01" =>
                font_ram(4)(addr) <= unsigned(vga_writedata(31 downto 24));
                font_ram(5)(addr) <= unsigned(vga_writedata(23 downto 16));
                font_ram(6)(addr) <= unsigned(vga_writedata(15 downto 8));
                font_ram(7)(addr) <= unsigned(vga_writedata(7 downto 0));
            when "10" =>
                font_ram(8)(addr) <= unsigned(vga_writedata(31 downto 24));
                font_ram(9)(addr) <= unsigned(vga_writedata(23 downto 16));
                font_ram(10)(addr) <= unsigned(vga_writedata(15 downto 8));
                font_ram(11)(addr) <= unsigned(vga_writedata(7 downto 0));
            when others =>
                font_ram(12)(addr) <= unsigned(vga_writedata(31 downto 24));
                font_ram(13)(addr) <= unsigned(vga_writedata(23 downto 16));
                font_ram(14)(addr) <= unsigned(vga_writedata(15 downto 8));
                font_ram(15)(addr) <= unsigned(vga_writedata(7 downto 0));
        end case;
    end if; -- vga_write = '1'
    
    end if; -- rising_edge(vga_clk)
    end process; -- process(vga_clk)
    
        
    -- there are 16 lines in each font character, so we can
    -- look at the bottom 4 bits of y to know which line we're on
    y <= to_integer(unsigned(display_y(3 downto 0)));
    
    -- each character is 8 pixels wide, so to find which character
    -- we're in, ignore the bottom 3 bits. But there's a catch - we
    -- store all the rows end to end, so we have to add y * row_length
    -- where row_length = 80
    --
    -- we can implement this as y * 80 == y << 6 + y << 4
    x <= to_integer(unsigned(display_x(9 downto 3))
    	+ unsigned(display_y(6 downto 4) & "000000")
    	+ unsigned(display_y(6 downto 4) & "0000"));
    	
    -- we still need to find the x position within that particular char.
    inner_x <= to_integer(unsigned(display_x(2 downto 0)));
    
    display_pixel_on <= font_ram(y)(x)(inner_x);

end rtl;
