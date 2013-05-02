library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity fft_fdom_ram_row is
    port (clk : std_logic;
          reset : std_logic;
          writedata : in signed(31 downto 0);
          writeaddr : in unsigned(3 downto 0);
          write_en : std_logic;
          readdata : out signed(31 downto 0);
          readaddr : in unsigned(3 downto 0));
end fft_fdom_ram_row;

architecture rtl of fft_fdom_ram_row is
    type ram_type is array(0 to 15) of signed(31 downto 0);
    signal ram_data : ram_type;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                ram_data <= (others => (others => '0'));
            elsif write_en = '1' then
                ram_data(to_integer(writeaddr)) <= writedata;
            end if;
            readdata <= ram_data(to_integer(readaddr));
        end if;
    end process;
end rtl;
