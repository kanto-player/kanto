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
          fdom_data : out signed(35 downto 0);
          fdom_addr : out unsigned(3 downto 0);
          fdom_write : out std_logic);
end dft_top;

architecture rtl of dft_top is
    signal s1_rom_real : signed(17 downto 0);
    signal s1_rom_imag : signed(17 downto 0);
    signal s1_tdom_real : signed(15 downto 0);
    signal s1_k : unsigned(3 downto 0);
    signal s1_write : std_logic;
    signal s1_done : std_logic;
begin
    S1 : entity work.dft_stage1 port map (
        tdom_data => tdom_data,
        tdom_addr => tdom_addr,

        clk => clk,
        reset => reset,

        rom_data => rom_data,
        rom_addr => rom_addr,

        rom_real => s1_rom_real,
        rom_imag => s1_rom_imag,
        tdom_real => s1_tdom_real,
        outk => s1_k,
        write => s1_write,
        done => s1_done
    );
end rtl;
