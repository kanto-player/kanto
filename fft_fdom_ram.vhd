library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity fft_fdom_ram is
    port (writedata : in complex_signed_array;
          readdata : out complex_signed_array;
          addr : in byte_array;
          write_en : in std_logic_vector(15 downto 0);
          clk : std_logic);
end fft_fdom_ram;

architecture rtl of fft_fdom_ram is
    type ram_type is array(0 to 255) of signed(35 downto 0);
    signal ram_data : ram_type;
begin
    LUMAP : for i in 0 to 15 generate
        readdata <= ram(to_integer(addr(i)));
        process (clk)
        begin
            if rising_edge(clk) and write_en(i) = '1' then
                ram_data(to_integer(addr(i))) <= writedata(i);
            end if;
        end process;
    end generate LUMAP;
end rtl;
