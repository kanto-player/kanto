library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dft_stage2 is
    port (rom_real : in signed(17 downto 0);
          rom_imag : in signed(17 downto 0);
          tdom_real : in signed(15 downto 0);

          clk : std_logic;

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
    signal mult_real : signed(35 downto 0);
    signal mult_imag : signed(35 downto 0);
    signal tdom_extended : signed(17 downto 0);
    signal input_copy_bit : std_logic;
    signal real_copy_bit : std_logic;
    signal imag_copy_bit : std_logic;
begin
    input_copy_bit <= tdom_real(15);
    real_copy_bit <= mult_real(33);
    imag_copy_bit <= mult_imag(33);

    tdom_extended <= (1 downto 0 => input_copy_bit) & tdom_real;

    REALM : entity work.mult port map (
        dataa => rom_real,
        datab => tdom_extended,
        result => mult_real
    );

    IMAGM : entity work.mult port map (
        dataa => rom_imag,
        datab => tdom_extended,
        result => mult_imag
    );

    process (clk)
    begin
        if rising_edge(clk) then
            outwrite <= inwrite;
            outdone <= indone;
            outk <= ink;
            res_real <= (3 downto 0 => real_copy_bit) & mult_real(33 downto 6);
            res_imag <= (3 downto 0 => imag_copy_bit) & mult_imag(33 downto 6);
        end if;
    end process;
end rtl;
