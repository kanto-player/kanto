library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity fft_tdom_ram is
    port (writedata : in signed(15 downto 0);
          writeaddr : in unsigned(7 downto 0);
          write_en : in std_logic;
          readdata : out real_signed_array;
          readaddr : in byte_array;
          clk : std_logic);
end fft_tdom_ram;

architecture rtl of fft_tdom_ram is
    type ram_type is array(0 to 255) of signed(15 downto 0);
    signal ram_data : ram_type;
begin
    LUMAP : for i in 0 to 15 generate
        readdata(i) <= ram_data(to_integer(readaddr(i)));
    end generate LUMAP;

    process (clk)
    begin
        if rising_edge(clk) and write_en = '1' then
            ram_data(to_integer(writeaddr)) <= writedata;
        end if;
    end process;
end rtl;
