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
          readaddr : in unsigned(3 downto 0);
          bigdata : out signed(31 downto 0);
          bigaddr : in unsigned(3 downto 0));
end fft_fdom_ram_row;

architecture rtl of fft_fdom_ram_row is
    type ram_type is array(0 to 15) of signed(31 downto 0);
    signal ram_data : ram_type;
begin
    readdata <= ram_data(to_integer(readaddr));
    bigdata <= ram_data(to_integer(bigaddr));
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                ram_data(0) <= (others => '0');
                ram_data(1) <= (others => '0');
                ram_data(2) <= (others => '0');
                ram_data(3) <= (others => '0');
                ram_data(4) <= (others => '0');
                ram_data(5) <= (others => '0');
                ram_data(6) <= (others => '0');
                ram_data(7) <= (others => '0');
                ram_data(8) <= (others => '0');
                ram_data(9) <= (others => '0');
                ram_data(10) <= (others => '0');
                ram_data(11) <= (others => '0');
                ram_data(12) <= (others => '0');
                ram_data(13) <= (others => '0');
                ram_data(14) <= (others => '0');
                ram_data(15) <= (others => '0');
            elsif write_en = '1' then
                ram_data(to_integer(writeaddr)) <= writedata;
            end if;
        end if;
    end process;
end rtl;
