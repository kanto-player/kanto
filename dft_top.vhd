library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dft_top is
    port (tdom_data : in signed(15 downto 0);
          tdom_addr : out unsigned(3 downto 0);
          clk : in std_logic;
          reset : in std_logic;
          rom_data : in signed(35 downto 0);
          rom_addr : out unsigned(7 downto 0);
          fdom_data : out signed(17 downto 0);
          fdom_addr : out unsigned(3 downto 0);
          fdom_write : out std_logic);
end dft_top;

architecture rtl of dft_top is
begin
end rtl;
