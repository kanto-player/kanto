library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fft_fdom_ram is
    port (clk : std_logic;
          writedata_low : in signed(31 downto 0);
          writeaddr_low : in unsigned(3 downto 0);
          readdata_low : out signed(31 downto 0);
          readaddr_low : in unsigned(3 downto 0);
          write_en_low : in std_logic;
          writedata_high : in signed(31 downto 0);
          writeaddr_high : in unsigned(3 downto 0);
          readdata_high : out signed(31 downto 0);
          readaddr_high : in unsigned(3 downto 0);
          write_en_high : in std_logic;
          stage : in unsigned(1 downto 0);
          step  : in unsigned(2 downto 0));
end fft_fdom_ram;

architecture rtl of fft_fdom_ram is
    type data_array is array(0 to 15) of signed(31 downto 0);
    type addr_array is array(0 to 15) of unsigned(3 downto 0);
    signal row_writedata : data_array;
    signal row_writeaddr : addr_array;
    signal row_write_en : std_logic_vector(0 to 15);
    signal row_readdata : data_array;
    signal row_readaddr : addr_array;
    signal lowsel : unsigned(3 downto 0);
    signal highsel : unsigned(3 downto 0);
begin
    WRITEGEN : for i in 0 to 15 generate
        row_writedata(i) <= writedata_low when lowsel = i else
                            writedata_high when highsel = i else
                            (others => '0');
        row_writeaddr(i) <= writeaddr_low when lowsel = i else
                            writeaddr_high when highsel = i else
                            (others => '0');
        row_write_en(i) <= write_en_low when lowsel = i else
                           write_en_high when highsel = i else '0';
        row_readaddr(i) <= readaddr_low when lowsel = i else
                           readaddr_high when highsel = i else
                           (others => '0');
    end generate WRITEGEN;

    readdata_low <= row_readdata(to_integer(lowsel));
    readdata_high <= row_readdata(to_integer(highsel));

    with stage select lowsel <=
        -- every even indexed row
        step & '0' when "00", 
        -- top two rows of every group of four
        step(2 downto 1) & '0' & step(0) when "01", 
        -- top four rows of every group of eight
        step(2) & '0' & step(1 downto 0) when "10", 
        -- top 8 rows
        '0' & step when "11", 
        "0000" when others;
    
    with stage select highsel <=
        -- every odd indexed row
        step & '1' when "00", 
        -- bottom two rows of every group of four
        step(2 downto 1) & '1' & step(0) when "01", 
        -- bottom four rows of every group of eight
        step(2) & '1' & step(1 downto 0) when "10",
        -- bottom eight rows
        '1' & step when "11",
        "1111" when others;
    
    LUMAP : for i in 0 to 15 generate
        ROW : entity work.fdom_row port map (
            clock => clk,
            data => std_logic_vector(row_writedata(i)),
            wraddress => std_logic_vector(row_writeaddr(i)),
            wren => row_write_en(i),
            signed(q) => row_readdata(i),
            rdaddress => std_logic_vector(row_readaddr(i))
        );
    end generate LUMAP;
end rtl;
