library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fft_tdom_test_rom is
    port (tdom_addr_even : in unsigned(3 downto 0);
          tdom_data_even : out signed(15 downto 0);
          tdom_addr_odd : in unsigned(3 downto 0);
          tdom_data_odd : out signed(15 downto 0);
          tdom_sel : in unsigned(2 downto 0));
end fft_tdom_test_rom;

architecture rtl of fft_tdom_test_rom is
    type rom_type is array(0 to 255) of signed(15 downto 0);
    constant rom_data : rom_type := (x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000");
    signal full_addr_even : unsigned(7 downto 0);
    signal full_addr_odd : unsigned(7 downto 0);
begin
    full_addr_even <= tdom_addr_even & tdom_sel & '0';
    full_addr_odd <= tdom_addr_odd & tdom_sel & '1';
    tdom_data_even <= rom_data(to_integer(full_addr_even));
    tdom_data_odd <= rom_data(to_integer(full_addr_odd));
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fft_tb is
end fft_tb;

architecture sim of fft_tb is
    signal tdom_addr_even : unsigned(3 downto 0);
    signal tdom_data_even : signed(15 downto 0);
    signal tdom_addr_odd : unsigned(3 downto 0);
    signal tdom_data_odd : signed(15 downto 0);
    signal tdom_sel : unsigned(2 downto 0);
    signal fdom_addr : unsigned(7 downto 0);
    signal fdom_data : signed(31 downto 0);
    signal clk : std_logic := '0';
    signal start : std_logic;
    signal done : std_logic;
    type rom_type is array(0 to 255) of signed(31 downto 0);
    constant expected : rom_type := (x"047f0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffff0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"014a0000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"ffff0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"03000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"02b50000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"ffff0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"0d7f0000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"02b50000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"03000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"014b0000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"ffff0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"047f0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffff0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"014a0000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"ffff0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"03000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"02b50000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"ffff0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"0d7f0000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"02b50000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"03000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"014b0000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"ffff0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff");
begin
    TESTROM : entity work.fft_tdom_test_rom port map (
        tdom_addr_even => tdom_addr_even,
        tdom_data_even => tdom_data_even,
        tdom_addr_odd => tdom_addr_odd,
        tdom_data_odd => tdom_data_odd,
        tdom_sel => tdom_sel
    );

    FFT : entity work.fft_controller port map (
        tdom_addr_even => tdom_addr_even,
        tdom_data_even => tdom_data_even,
        tdom_addr_odd => tdom_addr_odd,
        tdom_data_odd => tdom_data_odd,
        tdom_sel => tdom_sel,

        fdom_data_out => fdom_data,
        fdom_addr_out => fdom_addr,

        clk => clk,
        start => start,
        done => done
    );

    clk <= not clk after 10 ns;

    process
        variable i : integer range 0 to 256;
    begin
        start <= '1';
        fdom_addr <= x"00";
        wait for 20 ns; -- 20 ns
        start <= '0';
        wait for 10 ns; -- 30 ns

        wait for 55840 ns; -- 55870 ns

        assert done = '1';

        i := 0;
        while i < 256 loop
            fdom_addr <= to_unsigned(i, 8);
            wait for 20 ns;
            assert fdom_data = expected(i);
            i := i + 1;
        end loop;
        
        wait;
    end process;
end sim;
