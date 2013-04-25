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
          write_en : in std_logic_vector(0 to 15);
          clk : std_logic;
          reset : std_logic);
end fft_fdom_ram;

architecture rtl of fft_fdom_ram is
    signal bigaddr_upper : unsigned(3 downto 0);
    signal bigaddr_lower : unsigned(3 downto 0);
    signal bigdata_opt : complex_signed_array;
begin
    bigaddr_upper <= bigaddr(7 downto 4);
    bigaddr_lower <= bigaddr(3 downto 0);

    bigdata <= bigdata_opt(0) when bigaddr_upper = 0 else
               bigdata_opt(1) when bigaddr_upper = 1 else
               bigdata_opt(2) when bigaddr_upper = 2 else
               bigdata_opt(3) when bigaddr_upper = 3 else
               bigdata_opt(4) when bigaddr_upper = 4 else
               bigdata_opt(5) when bigaddr_upper = 5 else
               bigdata_opt(6) when bigaddr_upper = 6 else
               bigdata_opt(7) when bigaddr_upper = 7 else
               bigdata_opt(8) when bigaddr_upper = 8 else
               bigdata_opt(9) when bigaddr_upper = 9 else
               bigdata_opt(10) when bigaddr_upper = 10 else
               bigdata_opt(11) when bigaddr_upper = 11 else
               bigdata_opt(12) when bigaddr_upper = 12 else
               bigdata_opt(13) when bigaddr_upper = 13 else
               bigdata_opt(14) when bigaddr_upper = 14 else
               bigdata_opt(15) when bigaddr_upper = 15;
    
    LUMAP : for i in 0 to 15 generate
        ROW : entity work.fft_fdom_ram_row port map (
            clk => clk,
            reset => reset,
            writedata => writedata(i),
            writeaddr => writeaddr(i),
            write_en => write_en(i),
            readdata => readdata(i),
            readaddr => readaddr(i),
            bigdata => bigdata_opt(i),
            bigaddr => bigaddr_lower
        );
    end generate LUMAP;
end rtl;
