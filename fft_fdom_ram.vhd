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
    type ram_type is array(0 to 15, 0 to 15) of signed(31 downto 0);
    signal ram_data : ram_type;
    signal bigaddr_upper : unsigned(3 downto 0);
    signal bigaddr_lower : unsigned(3 downto 0);
begin
    bigaddr_upper <= bigaddr(7 downto 4);
    bigaddr_lower <= bigaddr(3 downto 0);
    bigdata <= ram_data(to_integer(bigaddr_upper), to_integer(bigaddr_lower));
    
    LUMAP : for i in 0 to 15 generate
        readdata(i) <= ram_data(i, to_integer(readaddr(i)));
        process (clk)
        begin
            if rising_edge(clk) then
                if reset = '1' then 
                    ram_data(i, 0)  <= x"00000000";
                    ram_data(i, 1)  <= x"00000000";
                    ram_data(i, 2)  <= x"00000000";
                    ram_data(i, 3)  <= x"00000000";
                    ram_data(i, 4)  <= x"00000000";
                    ram_data(i, 5)  <= x"00000000";
                    ram_data(i, 6)  <= x"00000000";
                    ram_data(i, 7)  <= x"00000000";
                    ram_data(i, 7)  <= x"00000000";
                    ram_data(i, 8)  <= x"00000000";
                    ram_data(i, 9)  <= x"00000000";
                    ram_data(i, 10) <= x"00000000";
                    ram_data(i, 11) <= x"00000000";
                    ram_data(i, 12) <= x"00000000";
                    ram_data(i, 13) <= x"00000000";
                    ram_data(i, 14) <= x"00000000";
                    ram_data(i, 15) <= x"00000000";
                elsif write_en(i) = '1' then
                    ram_data(i, to_integer(writeaddr(i))) <= writedata(i);
                end if;
            end if;
        end process;
    end generate LUMAP;
end rtl;
