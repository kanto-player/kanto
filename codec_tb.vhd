library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity codec_tb is
end codec_tb;

architecture sim of codec_tb is
    signal clk : std_logic := '1';
    signal daclrck : std_logic;
    signal dacdat : std_logic;
    signal bclk : std_logic;
    constant data : std_logic_vector(15 downto 0) := x"a35c";
    signal next_samp : std_logic;
begin
    CODEC : entity work.ab_codec port map (
        clk => clk,
        en => '1',
        data => data,
        next_samp => next_samp,

        aud_daclrck => daclrck,
        aud_dacdat => dacdat,
        aud_bclk => bclk
    );

    clk <= not clk after 10 ns;

    process
        variable i : integer range -1 to 15 := 15;
    begin
        wait for 40 ns;

        assert daclrck = '1';
        while i >= 0 loop
            wait for 10 ns;
            assert dacdat = data(i);
            wait for 30 ns;
            i := i - 1;
        end loop; -- 680 ns

        wait for 1920 ns; -- 2600 ns

        assert daclrck = '0';

        i := 15;
        while i >= 0 loop
            wait for 10 ns;
            assert dacdat = data(i);
            wait for 30 ns;
            i := i - 1;
        end loop; -- 3240 ns

        wait for 10 ns; -- 3250 ns
        assert next_samp = '1';

        wait for 1910 ns; -- 5160 ns

        wait;
    end process;
end sim;
