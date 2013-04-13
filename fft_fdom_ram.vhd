library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity fft_fdom_ram is
    port (writedata : in complex_signed_array;
          readdata : out complex_signed_array;
          rwaddr : in nibble_array;
          bigdata : out signed(31 downto 0);
          bigaddr : in unsigned(7 downto 0);
          write_en : in std_logic_vector(0 to 15);
          clk : std_logic);
end fft_fdom_ram;

architecture rtl of fft_fdom_ram is
    type ram_type is array(0 to 15, 0 to 15) of signed(31 downto 0);
    signal ram_data : ram_type;
    signal bigaddr_upper : unsigned(3 downto 0);
    signal bigaddr_lower : unsigned(3 downto 0);
begin
    bigaddr_upper <= bigaddr(7 downto 4);
    bigaddr_lower <= bigaddr(3 downto 0);
    bigdata <= ram_data(to_integer(bigaddr_upper), to_integer(bigaddr_lower));
    
    LUMAP : for i in 0 to 15 generate
        readdata(i) <= ram_data(i, to_integer(rwaddr(i)));
        process (clk)
        begin
            if rising_edge(clk) and write_en(i) = '1' then
                ram_data(i, to_integer(rwaddr(i))) <= writedata(i);
            end if;
        end process;
    end generate LUMAP;
end rtl;
