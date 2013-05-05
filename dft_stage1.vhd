library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dft_stage1 is
    port (tdom_data : in signed(15 downto 0);
          tdom_addr : out unsigned(3 downto 0);
          
          clk : in std_logic;
          reset : in std_logic;
          
          rom_data : in signed(31 downto 0);
          rom_addr : out unsigned(7 downto 0);
          
          rom_real : out signed(15 downto 0);
          rom_imag : out signed(15 downto 0);
          tdom_real : out signed(15 downto 0);
          outk : out unsigned(3 downto 0);
          write : out std_logic;
          done : out std_logic);
end dft_stage1;

architecture rtl of dft_stage1 is
    signal n : unsigned(3 downto 0) := x"0";
    signal k : unsigned(3 downto 0) := x"0";
    signal prevk : unsigned(3 downto 0) := x"0";
    signal done_intern : std_logic := '0';
    signal write_intern : std_logic := '0';
begin
    rom_addr <= k & n;
    tdom_addr <= n;
            
    rom_real <= rom_data(31 downto 16);
    rom_imag <= rom_data(15 downto 0);
    tdom_real <= tdom_data;

    process (clk)
    begin
        if rising_edge(clk) then
            done <= done_intern;
            write <= write_intern;
            outk <= prevk;
            prevk <= k;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                k <= x"0";
                n <= x"0";
                write_intern <= '1';
                done_intern <= '0';
            elsif done_intern = '1' then
                write_intern <= '0';
                k <= x"0";
                n <= x"0";
            elsif k = x"f" and n = x"f" then
                write_intern <= '1';
                done_intern <= '1';
            elsif n = x"f" then
                k <= k + x"1";
                n <= x"0";
                write_intern <= '1';
            else
                n <= n + x"1";
                write_intern <= '0';
            end if;
        end if;
    end process;
end rtl;
