library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dft_stage2 is
    port (rom_real : in signed(17 downto 0);
          rom_imag : in signed(17 downto 0);
          tdom_real : in signed(15 downto 0);

          res_real : out signed(31 downto 0);
          res_imag : out signed(31 downto 0);

          ink : in signed(3 downto 0);
          outk : in signed(3 downto 0);

          inwrite : in std_logic;
          outwrite : out std_logic;

          indone : in std_logic;
          outdone : out std_logic);
end dft_stage2;

architecture rtl of dft_stage2 is
    signal mult_real : out signed(35 downto 0);
    signal mult_imag : out signed(35 downto 0);
    signal copy_bit : std_logic;
begin
    REALM : entity work.mult port map (
        dataa => rom_real,
        datab => tdom_real,
        result => mult_real
    );

    IMAGM : entity work.mult port map (
        dataa => rom_real,
        datab => rom_imag,
        result => mult_imag
    );
end rtl;
