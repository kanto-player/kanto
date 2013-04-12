library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dft_stage2 is
    port (rom_real : in signed(15 downto 0);
          rom_imag : in signed(15 downto 0);
          tdom_real : in signed(15 downto 0);

          clk : std_logic;
          reset : std_logic;

          res_real : out signed(31 downto 0);
          res_imag : out signed(31 downto 0);

          ink : in unsigned(3 downto 0);
          outk : out unsigned(3 downto 0);

          inwrite : in std_logic;
          outwrite : out std_logic;

          indone : in std_logic;
          outdone : out std_logic);
end dft_stage2;

architecture rtl of dft_stage2 is
    signal mult_real : signed(31 downto 0);
    signal mult_imag : signed(31 downto 0);
    signal real_copy_bit : std_logic;
    signal imag_copy_bit : std_logic;
begin
    real_copy_bit <= mult_real(31);
    imag_copy_bit <= mult_imag(31);
    
    REALM : entity work.mult port map (
        dataa => std_logic_vector(rom_real),
        datab => std_logic_vector(tdom_real),
        signed(result) => mult_real
    );

    IMAGM : entity work.mult port map (
        dataa => std_logic_vector(rom_imag),
        datab => std_logic_vector(tdom_real),
        signed(result) => mult_imag
    );

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                outwrite <= '0';
                outdone <= '0';
                outk <= x"0";
            else
                outwrite <= inwrite;
                outdone <= indone;
                outk <= ink;
                res_real <= (3 downto 0 => real_copy_bit) & mult_real(31 downto 4);
                res_imag <= (3 downto 0 => imag_copy_bit) & mult_imag(31 downto 4);
            end if;
        end if;
    end process;
end rtl;
