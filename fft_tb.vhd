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
    constant rom_data : rom_type := (x"7fff", x"7eb2", x"7ad5", x"747b", x"6bc4", x"60de", x"5401", x"4571", x"3579", x"246b", x"12a0", x"0074", x"ee47", x"dc75", x"cb5c", x"bb53", x"acaf", x"9fbb", x"94bb", x"8be7", x"856d", x"816f", x"8002", x"812d", x"84ea", x"8b25", x"93bf", x"9e8a", x"ab4f", x"b9cb", x"c9b4", x"dab6", x"ec79", x"fea2", x"10d1", x"22aa", x"33cf", x"43e7", x"529f", x"5faa", x"6ac5", x"73b6", x"7a4f", x"7e6d", x"7ffb", x"7ef1", x"7b55", x"7539", x"6cbd", x"620c", x"555f", x"46f7", x"371f", x"2629", x"146d", x"0247", x"f016", x"de37", x"cd07", x"bcdf", x"ae14", x"a0f1", x"95bc", x"8cae", x"85f7", x"81b8", x"8009", x"80f1", x"846d", x"8a6a", x"92c9", x"9d5e", x"a9f3", x"b847", x"c80e", x"d8f8", x"eaad", x"fcd0", x"0f02", x"20e8", x"3223", x"425a", x"5138", x"5e72", x"69c1", x"72ec", x"79c2", x"7e21", x"7ff1", x"7f2a", x"7bcf", x"75f2", x"6db0", x"6336", x"56b9", x"487a", x"38c3", x"27e6", x"1639", x"041a", x"f1e6", x"dffa", x"ceb4", x"be6e", x"af7d", x"a22d", x"96c3", x"8d7c", x"8687", x"8208", x"8016", x"80bc", x"83f7", x"89b5", x"91d8", x"9c37", x"a89c", x"b6c6", x"c66c", x"d73d", x"e8e1", x"fafd", x"0d32", x"1f24", x"3074", x"40c9", x"4fcd", x"5d34", x"68b7", x"721b", x"792f", x"7dce", x"7fe1", x"7f5c", x"7c42", x"76a4", x"6e9e", x"645a", x"580e", x"49f9", x"3a64", x"29a0", x"1805", x"05ec", x"f3b6", x"e1bf", x"d064", x"c001", x"b0ea", x"a36d", x"97d0", x"8e50", x"871d", x"825e", x"802a", x"808e", x"8387", x"8905", x"90ed", x"9b15", x"a749", x"b549", x"c4cd", x"d583", x"e716", x"f92b", x"0b61", x"1d5e", x"2ec3", x"3f34", x"4e5e", x"5bf2", x"67a8", x"7145", x"7895", x"7d75", x"7fc9", x"7f87", x"7caf", x"7750", x"6f86", x"657a", x"595f", x"4b74", x"3c02", x"2b59", x"19cf", x"07be", x"f587", x"e385", x"d217", x"c197", x"b25b", x"a4b1", x"98e2", x"8f29", x"87ba", x"82ba", x"8045", x"8066", x"831d", x"885c", x"9008", x"99f9", x"a5fb", x"b3d0", x"c330", x"d3cc", x"e54d", x"f759", x"0990", x"1b97", x"2d0f", x"3d9d", x"4ceb", x"5aaa", x"6693", x"7068", x"77f6", x"7d15", x"7fab", x"7fab", x"7d15", x"77f6", x"7068", x"6693", x"5aaa", x"4ceb", x"3d9d", x"2d0f", x"1b97", x"0990", x"f759", x"e54d", x"d3cc", x"c330", x"b3d0", x"a5fb", x"99f9", x"9008", x"885c", x"831d", x"8066", x"8045", x"82ba", x"87ba", x"8f29", x"98e2", x"a4b1", x"b25b", x"c197", x"d217", x"e385", x"f587", x"07be", x"19cf");
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
    constant expected : rom_type := (x"ffac0000", x"ffaa0000", x"ffa20002", x"ff920001", x"ff62fff9", x"fe9cffda", x"065900df", x"01470022", x"00f60000", x"011bffc4", x"0444fdae", x"ff7200b1", x"fff10053", x"00120031", x"0020001c", x"0026000c", x"00260000", x"0024fff1", x"0020ffe5", x"0018ffd5", x"0009ffbd", x"ffd5ff75", x"01b101ce", x"0074002e", x"00630000", x"0078ffd4", x"01e0fe94", x"ffb9005e", x"fff10028", x"ffff0016", x"0005000b", x"00070005", x"00090000", x"0009fff9", x"0006fff3", x"0002ffea", x"fff7ffdb", x"ffd2ffb1", x"01380116", x"004a001e", x"003a0000", x"003fffdf", x"00c6fee0", x"fff6004f", x"000b0023", x"00100015", x"0013000c", x"00150004", x"00140000", x"0014fff9", x"0012fff2", x"000fffea", x"0007ffda", x"ffeaffb0", x"010a0111", x"004e001c", x"00450000", x"005affe6", x"0191ff30", x"ffb70034", x"ffe70015", x"fff3000b", x"fff80006", x"fffa0003", x"fffc0000", x"fffbfffd", x"fff9fff9", x"fff5fff4", x"ffebffeb", x"ffc0ffcf", x"015700b9", x"004b0015", x"00380000", x"003dffe7", x"00c9ff22", x"fff1003d", x"0007001b", x"000c0010", x"000e0009", x"000f0004", x"000e0000", x"000efffc", x"000dfff7", x"000cfff1", x"0009ffe8", x"fffdffcc", x"006800b1", x"00220012", x"001f0000", x"0028ffed", x"009bff59", x"ffec002d", x"fffe0014", x"0003000b", x"00050006", x"00060002", x"00060000", x"0006fffc", x"0005fff9", x"0003fff3", x"fffdffe9", x"ffe7ffcf", x"00ba00b4", x"002f0014", x"00270000", x"002cffe9", x"0091ff2f", x"fff7003c", x"0008001c", x"000c0011", x"0010000a", x"00110005", x"00120000", x"0012fff9", x"0010fff2", x"000dffea", x"0003ffdb", x"ffdcffb2", x"0159010b", x"0060001b", x"00560000", x"0072ffea", x"0220ff53", x"ff910028", x"ffd4000f", x"ffe40006", x"ffea0003", x"ffed0001", x"ffee0000", x"ffeefffe", x"ffeafffc", x"ffe4fff9", x"ffd4fff1", x"ff92ffd8", x"022100ab", x"00730016", x"00560000", x"0061ffe4", x"015afef4", x"ffdc004d", x"00030023", x"000c0015", x"0010000c", x"00120006", x"00120000", x"0012fffb", x"0010fff5", x"000effef", x"0009ffe3", x"fff7ffc3", x"009300d0", x"002c0016", x"00270000", x"0030ffec", x"00baff4c", x"ffe90030", x"fffd0016", x"0003000c", x"00050007", x"00070003", x"00070000", x"0007fffd", x"0006fff9", x"0004fff4", x"ffffffeb", x"ffecffd3", x"009c00a6", x"00280012", x"00200000", x"0023ffed", x"0068ff4e", x"fffe0033", x"00090017", x"000c000f", x"000f0008", x"000f0004", x"00100000", x"0010fffb", x"000efff6", x"000dfff0", x"0007ffe4", x"fff2ffc2", x"00ca00dd", x"003e0018", x"00390000", x"004cffea", x"0159ff46", x"ffc10030", x"ffeb0015", x"fff5000b", x"fffa0006", x"fffc0003", x"fffc0000", x"fffbfffd", x"fff9fff9", x"fff5fff4", x"ffe9ffeb", x"ffb8ffcb", x"019300cf", x"005b0019", x"00460000", x"004fffe3", x"010bfeee", x"ffeb004f", x"00090025", x"00100016", x"0014000d", x"00150006", x"00160000", x"0016fffa", x"0015fff3", x"0012ffeb", x"000dffdc", x"fff7ffb0", x"00c8011f", x"00400020", x"003b0000", x"004cffe1", x"0139fee9", x"ffd4004d", x"fff80024", x"00030015", x"0007000c", x"000a0006", x"000a0000", x"000afffa", x"0007fff3", x"0001ffe9", x"fff3ffd7", x"ffbbffa1", x"01e2016a", x"0079002a", x"00650000", x"0078ffd1", x"01b3fe31", x"ffd7008a", x"000a0042", x"001a002b", x"0022001a", x"0027000d", x"00280000", x"0028fff3", x"0022ffe2", x"0015ffce", x"fff3ffab", x"ff74ff4e", x"04470251", x"011e003b", x"00f80000", x"014affdc", x"065cff1f", x"fe9f0024", x"ff640005", x"ff94fffe", x"ffa6fffd", x"ffadffff");
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
            wait for 40 ns;
            assert fdom_data = expected(i);
            i := i + 1;
        end loop;
        
        wait;
    end process;
end sim;
