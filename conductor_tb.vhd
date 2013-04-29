library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conductor_tb is
end conductor_tb;

architecture sim of conductor_tb is
    signal clk : std_logic := '1';
    signal reset_n : std_logic;
    signal ab_audio_ok : std_logic;
    signal ab_swapped : std_logic;
    signal ab_force_swap : std_logic;
    signal sd_start : std_logic;
    signal sd_ready : std_logic;
    signal fft_start : std_logic;
    signal fft_done : std_logic;
    signal viz_reset : std_logic;
begin
    clk <= not clk after 10 ns;

    CONDUCTOR : entity work.conductor port map (
        clk => clk,
        reset_n => reset_n,
        ab_audio_ok => ab_audio_ok,
        ab_swapped => ab_swapped,
        ab_force_swap => ab_force_swap,
        sd_start => sd_start,
        sd_ready => sd_ready,
        fft_start => fft_start,
        fft_done => fft_done,
        viz_reset => viz_reset
    );

    process
    begin
        reset_n <= '0';
        fft_done <= '1';
        ab_swapped <= '0';
        wait for 20 ns; -- 20 ns
        reset_n <= '1';
        sd_ready <= '1';
        wait for 20 ns; -- 40 ns
        sd_ready <= '0';
        wait for 60 ns; -- 100 ns
        sd_ready <= '1';
        wait for 40 ns; -- 140 ns
        assert ab_force_swap = '1';
        wait for 20 ns; -- 160 ns
        assert ab_audio_ok = '1';
        ab_swapped <= '1';
        wait for 20 ns; -- 180 ns
        ab_swapped <= '0';
        wait for 20 ns; -- 200 ns
        assert sd_start = '1';
        assert fft_start = '1';
        assert ab_audio_ok = '1';
        fft_done <= '0';
        wait for 40 ns; -- 240 ns
        fft_done <= '1';
        wait for 40 ns; -- 280 ns
        assert viz_reset = '1';
        wait;
    end process;
end sim;
