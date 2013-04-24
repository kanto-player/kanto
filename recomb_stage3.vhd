library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity recomb_stage3 is
    port (clk : in std_logic;
          reset : in std_logic;
          done : out std_logic;
          
          even_real : in signed(15 downto 0);
          even_imag : in signed(15 downto 0);
          odd_real : in signed(15 downto 0);
          odd_imag : in signed(15 downto 0);
          
          addrin : in unsigned(3 downto 0);
          writein : in std_logic;

          low_writeaddr : out unsigned(3 downto 0);
          low_writedata : out signed(31 downto 0);
          low_write_en : out std_logic;
          
          high_writeaddr : out unsigned(3 downto 0);
          high_writedata : out signed(31 downto 0);
          high_write_en : out std_logic);
end recomb_stage3;

architecture rtl of recomb_stage3 is
    signal write_en : std_logic;
    signal writeaddr : unsigned(3 downto 0);
    signal even_real_shift : signed(15 downto 0);
    signal even_imag_shift : signed(15 downto 0);
    signal odd_real_shift : signed(15 downto 0);
    signal odd_imag_shift : signed(15 downto 0);
    signal low_sum_real : signed(15 downto 0);
    signal low_sum_imag : signed(15 downto 0);
    signal high_diff_real : signed(15 downto 0);
    signal high_diff_imag : signed(15 downto 0);
begin
    low_write_en <= write_en;
    high_write_en <= write_en;
    low_writeaddr <= writeaddr;
    high_writeaddr <= writeaddr;

    even_real_shift <= even_real(15) & even_real(15 downto 1);
    even_imag_shift <= even_imag(15) & even_imag(15 downto 1);
    odd_real_shift <= odd_real(15) & odd_real(15 downto 1);
    odd_imag_shift <= odd_imag(15) & odd_imag(15 downto 1);

    low_sum_real <= even_real_shift + odd_real_shift;
    low_sum_imag <= even_imag_shift + odd_imag_shift;
    high_diff_real <= even_real_shift - odd_real_shift;
    high_diff_imag <= even_imag_shift - odd_imag_shift;
    
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                write_en <= '0';
            else
                done <= not writein;
                write_en <= writein;
                writeaddr <= addrin;
                low_writedata <= low_sum_real & low_sum_imag;
                high_writedata <= high_diff_real & high_diff_imag;
            end if;
        end if;
    end process;
end rtl;
