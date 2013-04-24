library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity fdom_ram_tb is
end fdom_ram_tb;

architecture sim of fdom_ram_tb is
    signal writedata : complex_signed_array;
    signal readdata : complex_signed_array;
    signal readaddr : nibble_array;
    signal writeaddr : nibble_array;
    signal bigaddr : unsigned(7 downto 0);
    signal bigdata : signed(31 downto 0);
    signal write_en : std_logic_vector(0 to 15);
    signal clk : std_logic := '0';
    signal reset : std_logic;
begin
    RAM : entity work.fft_fdom_ram port map (
        writedata => writedata,
        readdata => readdata,
        readaddr => readaddr,
        writeaddr => writeaddr,
        bigaddr => bigaddr,
        bigdata => bigdata,
        write_en => write_en,
        clk => clk,
        reset => reset
    );

    clk <= not clk after 10 ns;

    process
        variable i : integer range 0 to 15;
    begin
        wait for 10 ns;
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        bigaddr <= x"00";
        wait for 20 ns;
        assert bigdata = x"00000000";
        writeaddr(1) <= x"1";
        writedata(1) <= x"000000fa";
        write_en(1) <= '1';
        wait for 20 ns;
        write_en(1) <= '0';
        bigaddr <= x"11";
        assert bigdata = x"000000fa";
        wait;
    end process;
end sim;
