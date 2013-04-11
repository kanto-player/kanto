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
          k : in signed(3 downto 0);
          
          outdone : out std_logic;
          outwrite : out std_logic;

          fdom_data : out signed(35 downto 0);
          fdom_base : in unsigned(3 downto 0);
          fdom_addr : out unsigned(7 downto 0));
end dft_stage3;

architecture rtl of dft_stage3 is
    signal sum_real : signed(31 downto 0);
    signal sum_imag : signed(31 downto 0);
begin
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
            if inwrite = '1' then
                fdom_addr <= fdom_base & k;
                fdom_data <= sum_real(31 downto 14) & sum_imag(31 downto 14);
                sum_real <= mult_real;
                sum_imag <= sum_imag;
            else
                sum_real <= sum_real + mult_real;
                sum_imag <= sum_imag + mult_imag;
                outwrite <= '1';
            end if;
        end if;
    end process;
end rtl;
