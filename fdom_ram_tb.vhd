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
    signal write_en : std_logic_vector(0 to 7);
    signal sel : std_logic_vector(1 downto 0);
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
        sel => sel,
        clk => clk,
        reset => reset
    );

    clk <= not clk after 10 ns;

    process
        variable i : integer range 0 to 8;
    begin
        i := 0;
        while i < 8 loop
            writedata(i) <= (others => '0');
            writeaddr(i) <= (others => '0');
            write_en(i) <= '0';
            readaddr(i) <= (others => '0');
            i := i + 1;
        end loop;
        sel <= "00";
        reset <= '1';
        wait for 20 ns; -- 20 ns
        reset <= '0';
        wait for 10 ns; -- 30 ns
        bigaddr <= x"00";
        wait for 20 ns; -- 50 ns
        assert bigdata = x"00000000";
        writeaddr(0) <= x"0";
        writedata(0) <= x"000000fa";
        write_en(0) <= '1';
        wait for 20 ns; -- 70 ns
        write_en(0) <= '0';
        readaddr(0) <= x"0";
        bigaddr <= x"00";
        wait for 20 ns; -- 90 ns
        assert bigdata = x"000000fa";
        assert readdata(0) = x"000000fa";
        wait for 20 ns; -- 110 ns
        writeaddr(4) <= x"4";
        writedata(4) <= x"000000bc";
        write_en(4) <= '1';
        wait for 20 ns; -- 130 ns
        bigaddr <= x"44";
        readaddr(4) <= x"4";
        write_en(4) <= '0';
        wait for 20 ns; -- 150 ns
        assert bigdata = x"000000bc";
        assert readdata(4) = x"000000bc";
        wait for 20 ns; -- 170 ns
        sel <= "01";
        writeaddr(1) <= x"1";
        writedata(1) <= x"00fc23aa";
        write_en(1) <= '1';
        wait for 20 ns; -- 190 ns
        bigaddr <= x"91";
        readaddr(1) <= x"1";
        write_en(1) <= '0';
        wait for 20 ns; -- 210 ns
        assert bigdata = x"00fc23aa";
        assert readdata(1) = x"00fc23aa";
        wait for 20 ns; -- 230 ns
        writeaddr(5) <= x"5";
        writedata(5) <= x"3921ab33";
        write_en(5) <= '1';
        wait for 20 ns; -- 250 ns
        bigaddr <= x"d5";
        readaddr(5) <= x"5";
        write_en(5) <= '0';
        wait for 20 ns; -- 270 ns
        assert bigdata = x"3921ab33";
        assert readdata(5) = x"3921ab33";
        wait for 20 ns; -- 290 ns
        sel <= "10";
        writeaddr(2) <= x"2";
        writedata(2) <= x"26331100";
        write_en(2) <= '1';
        wait for 20 ns; -- 310 ns
        bigaddr <= x"22";
        readaddr(2) <= x"2";
        write_en(2) <= '0';
        wait for 20 ns; -- 330 ns
        assert bigdata = x"26331100";
        assert readdata(2) = x"26331100";
        wait for 20 ns; -- 350 ns
        writeaddr(6) <= x"6";
        writedata(6) <= x"3400caff";
        write_en(6) <= '1';
        wait for 20 ns; -- 370 ns
        write_en(6) <= '0';
        readaddr(6) <= x"6";
        bigaddr <= x"a6";
        wait for 20 ns; -- 390 ns
        assert bigdata = x"3400caff";
        assert readdata(6) = x"3400caff";
        wait for 20 ns; -- 410 ns
        sel <= "11";
        writeaddr(3) <= x"3";
        writedata(3) <= x"30a1b2fc";
        write_en(3) <= '1';
        wait for 20 ns; -- 430 ns
        bigaddr <= x"73";
        readaddr(3) <= x"3";
        write_en(3) <= '0';
        wait for 20 ns; -- 450 ns
        assert bigdata = x"30a1b2fc";
        assert readdata(3) = x"30a1b2fc";
        wait for 20 ns; --470 ns
        writeaddr(7) <= x"7";
        writedata(7) <= x"1239a22c";
        write_en(7) <= '1';
        wait for 20 ns; -- 490 ns
        bigaddr <= x"f7";
        readaddr(7) <= x"7";
        write_en(7) <= '0';
        wait for 20 ns; -- 510 ns
        assert bigdata = x"1239a22c";
        assert readdata(7) = x"1239a22c";
        wait;
    end process;
end sim;
