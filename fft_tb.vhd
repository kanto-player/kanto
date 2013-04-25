library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity fft_tdom_test_rom is
    port (tdom_addr : in nibble_array;
          tdom_data : out real_signed_array);
end fft_tdom_test_rom;

architecture rtl of fft_tdom_test_rom is
    type rom_type is array(0 to 255) of signed(15 downto 0);
    constant rom_data : rom_type := (x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000", x"7fff", x"0000", x"8001", x"0000");
    signal full_addr : byte_array;
begin
    ADDRGEN : for i in 0 to 15 generate
        full_addr(i) <= tdom_addr(i) & to_unsigned(i, 4);
        tdom_data(i) <= rom_data(to_integer(full_addr(i)));
    end generate ADDRGEN;
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity fft_tb is
end fft_tb;

architecture sim of fft_tb is
    signal tdom_addr : nibble_array;
    signal tdom_data : real_signed_array;
    signal fdom_addr : unsigned(7 downto 0);
    signal fdom_data : signed(31 downto 0);
    signal clk : std_logic := '0';
    signal start : std_logic;
    signal done : std_logic;
    type rom_type is array(0 to 255) of signed(31 downto 0);
    constant expected : rom_type := (x"047f0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffff0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"014a0000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"ffff0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"03000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"02b50000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"ffff0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"0d7f0000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"02b50000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"03000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"014b0000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"ffff0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"047f0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffff0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"014a0000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"ffff0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"03000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"02b50000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"ffff0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"0d7f0000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"02b50000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"03000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"014b0000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"ffff0000", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff", x"ffffffff");
begin
    TESTROM : entity work.fft_tdom_test_rom port map (
        tdom_addr => tdom_addr,
        tdom_data => tdom_data
    );

    FFT : entity work.fft_controller port map (
        tdom_data_in => tdom_data,
        tdom_addr_in => tdom_addr,

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
        wait for 20 ns;
        start <= '0';
        wait for 10 ns;

        while done = '0' loop
            wait for 20 ns;
        end loop;

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
