library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity audio_buffer_tb is
end audio_buffer_tb;

architecture sim of audio_buffer_tb is
    signal writedata : signed(15 downto 0);
    signal writeaddr : unsigned(7 downto 0);
    signal write_en : std_logic;
    signal swapped : std_logic;
    signal clk : std_logic := '0';
    signal aud_clk : std_logic := '0';
    signal play : std_logic;
    signal start_write : std_logic;
    signal force_swap : std_logic;
    signal audio_addr : unsigned(8 downto 0);
    signal counter_en : std_logic;
    signal audio_request : std_logic;

    signal adclrck : std_logic;
    signal adcdat : std_logic;
    signal daclrck : std_logic;
    signal dacdat : std_logic;
    signal bclk : std_logic;

    signal readaddr : nibble_array;
begin
    AB : entity work.audio_buffer port map (
        clk => clk,
        aud_clk => aud_clk,
        play => play,
        swapped => swapped,
        force_swap => force_swap,

        writedata => writedata,
        writeaddr => writeaddr,
        write_en => write_en,

        aud_adclrck => adclrck,
        aud_adcdat => adcdat,
        aud_daclrck => daclrck,
        aud_dacdat => dacdat,
        aud_bclk => bclk,

        readaddr => readaddr,
        audio_addr_debug => audio_addr,
        counter_en_debug => counter_en,
        audio_req_debug => audio_request
    );

    SDD : entity work.sd_dummy port map (
        clk => clk,
        start => start_write,

        writedata => writedata,
        writeaddr => writeaddr,
        write_en => write_en
    );

    clk <= not clk after 10 ns;
    aud_clk <= not aud_clk after 44 ns;

    process
    begin
        play <= '0';
        start_write <= '1';
        wait for 20 ns;
        start_write <= '0';
        wait for 5120 ns;
        force_swap <= '1';
        start_write <= '1';
        wait for 20 ns;
        force_swap <= '0';
        start_write <= '0';
        play <= '1';

        while true loop
            if swapped = '1' then
                start_write <= '1';
                wait for 20 ns;
                start_write <= '0';
            end if;
            wait for 20 ns;
        end loop;

        wait;
    end process;
end sim;
