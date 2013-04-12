library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dft_stage1 is
    port (tdom_data : in signed(15 downto 0);
          tdom_addr : out unsigned(7 downto 0);
          tdom_offset : in unsigned(3 downto 0);
          
          clk : in std_logic;
          reset : in std_logic;
          
          rom_data : in signed(35 downto 0);
          rom_addr : out unsigned(7 downto 0);
          
          rom_real : out signed(17 downto 0);
          rom_imag : out signed(17 downto 0);
          tdom_real : out signed(15 downto 0);
          outk : out unsigned(3 downto 0);
          write : out std_logic;
          done : out std_logic);
end dft_stage1;

architecture rtl of dft_stage1 is
    signal n : unsigned(3 downto 0) := x"0";
    signal k : unsigned(3 downto 0) := x"0";
    signal done_intern : std_logic := '0';
begin
    rom_addr <= k & n;
    tdom_addr <= n & tdom_offset;
    done <= done_intern;

    process (clk)
    begin
        if rising_edge(clk) then
            rom_real <= rom_data(35 downto 18);
            rom_imag <= rom_data(17 downto 0);
            tdom_real <= tdom_data;
            outk <= k;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                k <= x"0";
                n <= x"0";
                write <= '0';
                done_intern <= '0';
            elsif done_intern = '1' then
                write <= '0';
                k <= x"0";
                n <= x"0";
            elsif k = x"f" and n = x"f" then
                write <= '1';
                done_intern <= '1';
            elsif n = x"f" then
                k <= k + x"1";
                n <= x"0";
                write <= '1';
            else
                n <= n + x"1";
                write <= '0';
            end if;
        end if;
    end process;
end rtl;
