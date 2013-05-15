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

    -- it's 40 pixels high because we have 5 lines,
    -- each 16 pixels high
    display_pixel_on : out std_logic;
    display_x : in std_logic_vector(9 downto 0);
    display_y : in std_logic_vector(6 downto 0);
    display_clk : in std_logic
);
end de2_vga_text_buffer;

architecture rtl of de2_vga_text_buffer is

    -- there are 16 lines in each character font.
    -- first line of ever character goes in one array, second line in
    -- another array, etc. -- this lets us write and read in parallel
    
    type addr_array is array(0 to 15) of std_logic_vector(8 downto 0);
    type data_array is array(0 to 15) of std_logic_vector(7 downto 0);
    type backwards_data_array is array(0 to 15) of std_logic_vector(0 to 7);
    
    signal row_writedata : data_array;
    signal row_write_en : std_logic_vector(0 to 15);
    signal row_readdata : backwards_data_array;
    
    signal x : integer range 0 to 399;
    signal y : integer range 0 to 15;
    signal inner_x : integer range 0 to 7;

begin

    RAM_GENERATE : for i in 0 to 15 generate
        RAM : entity work.vga_row_ram port map (
            rdaddress => std_logic_vector(to_unsigned(x, 9)),
            rdclock => display_clk,
            q => row_readdata(i),
            
            -- the top 9 bits tell us what character we are in
            -- the bottom 2 bits tell us which rows of the character
            -- we are in (since we have split each character into
            -- 4 groups of 4 rows)
            wraddress => vga_address(10 downto 2),
            -- so the bottom two bits tell us whether to enable the write
            -- for this row
            wren => row_write_en(i),
            wrclock => vga_clk,
            data => row_writedata(i)
        );
    end generate RAM_GENERATE;

    -- since we can only write one character part at a time, and
    -- each character is composed of four character parts, we look at the
    -- bottom two bits of the address to determine which lines this
    -- character part belongs on
    row_write_en(0) <= vga_write when vga_address(1 downto 0) = "00" else '0';
    row_write_en(1) <= vga_write when vga_address(1 downto 0) = "00" else '0';
    row_write_en(2) <= vga_write when vga_address(1 downto 0) = "00" else '0';
    row_write_en(3) <= vga_write when vga_address(1 downto 0) = "00" else '0';
    row_write_en(4) <= vga_write when vga_address(1 downto 0) = "01" else '0';
    row_write_en(5) <= vga_write when vga_address(1 downto 0) = "01" else '0';
    row_write_en(6) <= vga_write when vga_address(1 downto 0) = "01" else '0';
    row_write_en(7) <= vga_write when vga_address(1 downto 0) = "01" else '0';
    row_write_en(8) <= vga_write when vga_address(1 downto 0) = "10" else '0';
    row_write_en(9) <= vga_write when vga_address(1 downto 0) = "10" else '0';
    row_write_en(10) <= vga_write when vga_address(1 downto 0) = "10" else '0';
    row_write_en(11) <= vga_write when vga_address(1 downto 0) = "10" else '0';
    row_write_en(12) <= vga_write when vga_address(1 downto 0) = "11" else '0';
    row_write_en(13) <= vga_write when vga_address(1 downto 0) = "11" else '0';
    row_write_en(14) <= vga_write when vga_address(1 downto 0) = "11" else '0';
    row_write_en(15) <= vga_write when vga_address(1 downto 0) = "11" else '0';
    
    -- we have 8 bit wide data ports, so we split it into 4 parallel
    -- writes. we use the write enables to determine which actually
    -- get written to
    MAPPING2_GENERATE : for i in 0 to 3 generate
        row_writedata(i * 4 + 0) <= vga_writedata(31 downto 24);
        row_writedata(i * 4 + 1) <= vga_writedata(23 downto 16);
        row_writedata(i * 4 + 2) <= vga_writedata(15 downto 8);
        row_writedata(i * 4 + 3) <= vga_writedata(7 downto 0);
    end generate MAPPING2_GENERATE;
    
        
    -- there are 16 lines in each font character, so we can
    -- look at the bottom 4 bits of y to know which line we're on
    y <= to_integer(unsigned(display_y(3 downto 0)));
    
    -- each character is 8 pixels wide, so to find which character
    -- we're in, ignore the bottom 3 bits. But there's a catch - we
    -- store all the rows end to end, so we have to add y * row_length
    -- where row_length = 80

    -- we can implement this as y * 80 == y << 6 + y << 4
    x <= to_integer(unsigned(display_x(9 downto 3))
    	+ unsigned(unsigned(display_y(6 downto 4)) & "000000")
    	+ unsigned(unsigned(display_y(6 downto 4)) & "0000"));
--    x <= 0;
    	
    -- we still need to find the x position within that particular char.
    -- this -2 is a horrible horrible hack and I have no idea why it works
    -- probably related to timing
    inner_x <= to_integer(unsigned(display_x(2 downto 0))) - 2;
    
    display_pixel_on <= row_readdata(y)(inner_x);

end rtl;
