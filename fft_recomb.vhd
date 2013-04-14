library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fft_recomb is
    port (clk : in std_logic;
          reset : in std_logic;
          done : out std_logic;
          rom_addr : out unsigned(3 downto 0);
          rom_data : in signed(31 downto 0);
          low_readaddr : out unsigned(3 downto 0);
          low_writeaddr : out unsigned(3 downto 0);
          low_readdata : in signed(31 downto 0);
          low_writedata : out signed(31 downto 0);
          low_write_en : out std_logic;
          high_readaddr : out unsigned(3 downto 0);
          high_writeaddr : out unsigned(3 downto 0);
          high_readdata : in signed(31 downto 0);
          high_writedata : out signed(31 downto 0);
          high_write_en : out std_logic);
end fft_recomb;

architecture rtl of fft_recomb is
begin
end rtl;
