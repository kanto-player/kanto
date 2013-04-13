library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dft_stage3 is
    port (mult_real : in signed(31 downto 0);
          mult_imag : in signed(31 downto 0);

          clk : in std_logic;
          reset : in std_logic;

          indone : in std_logic;
          inwrite : in std_logic;
          k : in unsigned(3 downto 0);
          
          outdone : out std_logic;
          outwrite : out std_logic;

          sum_debug : out signed(63 downto 0);

          fdom_data : out signed(31 downto 0);
          fdom_addr : out unsigned(3 downto 0));
end dft_stage3;

architecture rtl of dft_stage3 is
    signal sum_real : signed(31 downto 0);
    signal sum_imag : signed(31 downto 0);
begin
    sum_debug <= sum_real & sum_imag;
    process (clk)
    begin
        if rising_edge(clk) then
            outdone <= indone;
            outwrite <= inwrite;
            if reset = '1' then
                sum_real <= (others => '0');
                sum_imag <= (others => '0');
                outdone <= '0';
                outwrite <= '0';
                fdom_data <= (others => '0');
                fdom_addr <= (others => '0');
            elsif inwrite = '1' then
                fdom_addr <= k;
                fdom_data <= sum_real(31 downto 16) & sum_imag(31 downto 16);
                sum_real <= mult_real;
                sum_imag <= mult_imag;
            else
                sum_real <= sum_real + mult_real;
                sum_imag <= sum_imag + mult_imag;
            end if;
        end if;
    end process;
end rtl;
