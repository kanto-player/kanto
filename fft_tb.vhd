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
    constant rom_data : rom_type := (x"7fff", x"7eb2", x"7ad5", x"747b", x"6bc4", x"60de", x"5401", x"4571", x"3579", x"246b", x"12a0", x"0074", x"ee47", x"dc75", x"cb5c", x"bb53", x"acaf", x"9fbb", x"94bb", x"8be7", x"856d", x"816f", x"8002", x"812d", x"84ea", x"8b25", x"93bf", x"9e8a", x"ab4f", x"b9cb", x"c9b4", x"dab6", x"ec79", x"fea2", x"10d1", x"22aa", x"33cf", x"43e7", x"529f", x"5faa", x"6ac5", x"73b6", x"7a4f", x"7e6d", x"7ffb", x"7ef1", x"7b55", x"7539", x"6cbd", x"620c", x"555f", x"46f7", x"371f", x"2629", x"146d", x"0247", x"f016", x"de37", x"cd07", x"bcdf", x"ae14", x"a0f1", x"95bc", x"8cae", x"85f7", x"81b8", x"8009", x"80f1", x"846d", x"8a6a", x"92c9", x"9d5e", x"a9f3", x"b847", x"c80e", x"d8f8", x"eaad", x"fcd0", x"0f02", x"20e8", x"3223", x"425a", x"5138", x"5e72", x"69c1", x"72ec", x"79c2", x"7e21", x"7ff1", x"7f2a", x"7bcf", x"75f2", x"6db0", x"6336", x"56b9", x"487a", x"38c3", x"27e6", x"1639", x"041a", x"f1e6", x"dffa", x"ceb4", x"be6e", x"af7d", x"a22d", x"96c3", x"8d7c", x"8687", x"8208", x"8016", x"80bc", x"83f7", x"89b5", x"91d8", x"9c37", x"a89c", x"b6c6", x"c66c", x"d73d", x"e8e1", x"fafd", x"0d32", x"1f24", x"3074", x"40c9", x"4fcd", x"5d34", x"68b7", x"721b", x"792f", x"7dce", x"7fe1", x"7f5c", x"7c42", x"76a4", x"6e9e", x"645a", x"580e", x"49f9", x"3a64", x"29a0", x"1805", x"05ec", x"f3b6", x"e1bf", x"d064", x"c001", x"b0ea", x"a36d", x"97d0", x"8e50", x"871d", x"825e", x"802a", x"808e", x"8387", x"8905", x"90ed", x"9b15", x"a749", x"b549", x"c4cd", x"d583", x"e716", x"f92b", x"0b61", x"1d5e", x"2ec3", x"3f34", x"4e5e", x"5bf2", x"67a8", x"7145", x"7895", x"7d75", x"7fc9", x"7f87", x"7caf", x"7750", x"6f86", x"657a", x"595f", x"4b74", x"3c02", x"2b59", x"19cf", x"07be", x"f587", x"e385", x"d217", x"c197", x"b25b", x"a4b1", x"98e2", x"8f29", x"87ba", x"82ba", x"8045", x"8066", x"831d", x"885c", x"9008", x"99f9", x"a5fb", x"b3d0", x"c330", x"d3cc", x"e54d", x"f759", x"0990", x"1b97", x"2d0f", x"3d9d", x"4ceb", x"5aaa", x"6693", x"7068", x"77f6", x"7d15", x"7fab", x"7fab", x"7d15", x"77f6", x"7068", x"6693", x"5aaa", x"4ceb", x"3d9d", x"2d0f", x"1b97", x"0990", x"f759", x"e54d", x"d3cc", x"c330", x"b3d0", x"a5fb", x"99f9", x"9008", x"885c", x"831d", x"8066", x"8045", x"82ba", x"87ba", x"8f29", x"98e2", x"a4b1", x"b25b", x"c197", x"d217", x"e385", x"f587", x"07be", x"19cf");
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
    signal state_debug : unsigned(2 downto 0);
    signal dft_done : std_logic;
    signal recomb_done : std_logic;
    type rom_type is array(0 to 255) of signed(31 downto 0);
    constant expected : rom_type := (x"00c80000", x"000700c8", x"001b0055", x"001d0031", x"001e0020", x"001d0013", x"001e000c", x"001c0004", x"001c0000", x"001bfff8", x"001bfff2", x"001affeb", x"001affe2", x"001affd3", x"001cffb8", x"0023ff57", x"ffe50000", x"002600b5", x"00210052", x"00230036", x"00260026", x"002a001b", x"002f0012", x"00330009", x"00370000", x"003dfff1", x"0043ffe1", x"0047ffcd", x"004affae", x"004bff7e", x"0043ff20", x"0005fdec", x"02830000", x"000b0220", x"004a00e9", x"0053008a", x"00530058", x"00510038", x"004e0020", x"0048000e", x"00440000", x"003efff2", x"0038ffe7", x"0032ffdd", x"002effd0", x"002cffc0", x"002dffa1", x"0048ff36", x"ff200000", x"004600b8", x"0027004f", x"00230030", x"00230020", x"00230016", x"0026000f", x"00270007", x"00290000", x"002cfff6", x"002effec", x"002fffdf", x"0031ffcd", x"0033ffb1", x"0036ff7c", x"003efeca", x"fffa0000", x"003d0139", x"00370087", x"00360051", x"00350035", x"00330022", x"00330015", x"00310009", x"00300000", x"002efff6", x"002dffec", x"002dffe1", x"002cffd4", x"002dffbd", x"0031ff92", x"0043fefb", x"ffa00000", x"00430121", x"00380086", x"00390059", x"003e0040", x"0043002e", x"0048001e", x"004d000f", x"00510000", x"0054ffed", x"0057ffd9", x"0057ffbf", x"0053ff9d", x"0047ff6b", x"0024ff0e", x"ff55fddd", x"074e0000", x"ff4201f9", x"001200cf", x"00310077", x"00380049", x"003a002e", x"0039001a", x"0037000c", x"00340000", x"0033fff4", x"0030ffe9", x"002effdd", x"002affcc", x"0027ffb6", x"001dff8a", x"ffeafefc", x"01c20000", x"ffeb00ed", x"00180061", x"001d0037", x"001e0023", x"001d0016", x"001d000d", x"001b0006", x"001a0000", x"0019fffa", x"0018fff3", x"0016ffed", x"0014ffe3", x"000effd4", x"ffffffb8", x"ff9dff5a", x"035a0000", x"ff9d00a6", x"ffff0047", x"000f002b", x"0014001c", x"00170013", x"0018000c", x"001a0006", x"001a0000", x"001bfffa", x"001dfff2", x"001effe9", x"001effdc", x"001effc7", x"0018ff9e", x"ffebff11", x"01c30000", x"ffea0103", x"001d0074", x"0027004a", x"002c0032", x"002e0023", x"00310016", x"0033000b", x"00350000", x"0037fff3", x"0039ffe5", x"003bffd1", x"003affb6", x"0031ff88", x"0013ff30", x"ff43fe06", x"074f0000", x"ff550222", x"002600f1", x"00490094", x"00530062", x"00570040", x"00580026", x"00560012", x"00520000", x"004efff0", x"0048ffe1", x"0044ffd1", x"003effc0", x"003affa6", x"0039ff79", x"0044fede", x"ffa00000", x"00440104", x"0031006d", x"002d0042", x"002d002c", x"002d001e", x"002e0013", x"002f0009", x"00310000", x"0032fff6", x"0034ffea", x"0035ffdd", x"0035ffcb", x"0037ffad", x"0038ff78", x"003efec6", x"fffa0000", x"003f0135", x"00370083", x"0034004d", x"00330033", x"00310020", x"002f0013", x"002d0009", x"002a0000", x"0028fff8", x"0027fff0", x"0025ffe9", x"0024ffde", x"0025ffcf", x"0029ffb0", x"0047ff47", x"ff220000", x"004900c9", x"002e005e", x"002d003f", x"0030002e", x"00350022", x"003a0018", x"003f000d", x"00450000", x"004afff1", x"004fffdf", x"0053ffc7", x"0055ffa7", x"0055ff75", x"004cff16", x"000dfddf", x"02840000", x"00060213", x"004600df", x"004d0081", x"004c0051", x"00480032", x"0045001e", x"003f000e", x"003a0000", x"0035fff6", x"0030ffed", x"002cffe3", x"0028ffd8", x"0025ffc8", x"0023ffac", x"0028ff4a", x"ffe60000", x"002500a7", x"001e0047", x"001d002b", x"001c001d", x"001d0014", x"001d000d", x"001d0006", x"001e0000", x"001ffffa", x"0020fff3", x"0020ffeb", x"0020ffdf", x"0020ffcc", x"001dffaa", x"0009ff36");
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

        state_debug => state_debug,
        dft_done_debug => dft_done,
        recomb_done_debug => recomb_done,

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
