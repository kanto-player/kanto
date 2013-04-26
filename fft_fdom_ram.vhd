library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity fft_fdom_ram is
    port (writedata : in complex_signed_array;
          writeaddr : in nibble_array;
          readdata : out complex_signed_array;
          readaddr : in nibble_array;
          bigdata : out signed(31 downto 0);
          bigaddr : in unsigned(7 downto 0);
          sel : in std_logic_vector(1 downto 0);
          write_en : in std_logic_vector(0 to 7);
          clk : std_logic;
          reset : std_logic);
end fft_fdom_ram;

architecture rtl of fft_fdom_ram is
    signal bigaddr_upper : unsigned(3 downto 0);
    signal bigaddr_lower : unsigned(3 downto 0);
    signal bigdata_opt : complex_signed_double_array;

    signal double_writedata : complex_signed_double_array;
    signal double_writeaddr : nibble_double_array;
    signal double_write_en : std_logic_vector(0 to 15);
    signal double_readdata : complex_signed_double_array;
    signal double_readaddr : nibble_double_array;
begin
    bigaddr_upper <= bigaddr(7 downto 4);
    bigaddr_lower <= bigaddr(3 downto 0);

    with bigaddr_upper select bigdata <=
        bigdata_opt(0) when x"0",
        bigdata_opt(1) when x"1",
        bigdata_opt(2) when x"2",
        bigdata_opt(3) when x"3",
        bigdata_opt(4) when x"4",
        bigdata_opt(5) when x"5",
        bigdata_opt(6) when x"6",
        bigdata_opt(7) when x"7",
        bigdata_opt(8) when x"8",
        bigdata_opt(9) when x"9",
        bigdata_opt(10) when x"a",
        bigdata_opt(11) when x"b",
        bigdata_opt(12) when x"c",
        bigdata_opt(13) when x"d",
        bigdata_opt(14) when x"e",
        bigdata_opt(15) when others;

    DOUBGEN_LOW : for i in 0 to 3 generate
        double_writedata(i) <= writedata(i) when sel(0) = '0' else 
                               (others => '0');
        double_writedata(i + 8) <= writedata(i) when sel = "01" else
                                   writedata(i + 4) when sel = "10" else
                                   (others => '0');
        double_writeaddr(i) <= writeaddr(i) when sel(0) = '0' else 
                               (others => '0');
        double_writeaddr(i + 8) <= writeaddr(i) when sel = "01" else
                                   writeaddr(i + 4) when sel = "10" else
                                   (others => '0');
        double_write_en(i) <= write_en(i) when sel(0) = '0' else '0';
        double_write_en(i + 8) <= write_en(i) when sel = "01" else
                                  write_en(i + 4) when sel = "10" else '0';
        double_readaddr(i) <= readaddr(i) when sel(0) = '0' else 
                               (others => '0');
        double_readaddr(i + 8) <= readaddr(i) when sel = "01" else
                                  readaddr(i + 4) when sel = "10" else
                                  (others => '0');
        readdata(i) <= double_readdata(i) when sel(0) = '0' else
                       double_readdata(i + 8) when sel = "01" else
                       double_readdata(i + 4);
    end generate DOUBGEN_LOW; 
    
    DOUBGEN_HIGH : for i in 4 to 7 generate
        double_writedata(i) <= writedata(i) when sel = "00" else
                               writedata(i - 4) when sel = "11" else
                               (others => '0');
        double_writedata(i + 8) <= writedata(i) when sel = "01" else
                                   (others => '0');
        double_writeaddr(i) <= writeaddr(i) when sel = "00" else
                               writeaddr(i - 4) when sel = "11" else
                               (others => '0');
        double_writeaddr(i + 8) <= writeaddr(i) when sel = "01" else
                                   (others => '0');
        double_write_en(i) <= write_en(i) when sel = "00" else
                              write_en(i - 4) when sel = "11" else '0';
        double_write_en(i + 8) <= write_en(i) when sel = "01" else '0';
        double_readaddr(i) <= readaddr(i) when sel = "00" else
                              readaddr(i - 4) when sel = "11" else
                              (others => '0');
        double_readaddr(i + 8) <= readaddr(i) when sel = "01" else
                                  (others => '0');
        readdata(i) <= double_readdata(i) when sel = "00" else
                       double_readdata(i + 8) when sel(0) = '1' else
                       double_readdata(i + 4) when sel = "10" else
                       (others => '0');
    end generate DOUBGEN_HIGH; 
    
    LUMAP : for i in 0 to 15 generate
        ROW : entity work.fft_fdom_ram_row port map (
            clk => clk,
            reset => reset,
            writedata => double_writedata(i),
            writeaddr => double_writeaddr(i),
            write_en => double_write_en(i),
            readdata => double_readdata(i),
            readaddr => double_readaddr(i),
            bigdata => bigdata_opt(i),
            bigaddr => bigaddr_lower
        );
    end generate LUMAP;
end rtl;
