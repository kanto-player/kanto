library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity audio_test_tb is
end audio_test_tb;

architecture sim of audio_test_tb is
    signal clk : std_logic := '0';
    signal aud_clk : std_logic := '0';

    signal sclk : std_logic;
    signal sdat : std_logic;

    signal daclrck : std_logic;
    signal dacdat : std_logic;
    signal bclk : std_logic;

    signal index_debug : unsigned(7 downto 0);
    
    signal initialized : std_logic;
    signal fault : std_logic;
begin
    AB : entity work.audio_test port map (
        clk => clk,
        aud_clk => aud_clk,
        en => '1',

        initialized => initialized,
        fault => fault,

        i2c_sdat => sdat,
        i2c_sclk => sclk,

        aud_daclrck => daclrck,
        aud_dacdat => dacdat,
        aud_bclk => bclk,
        
        index_debug => index_debug
    );

    clk <= not clk after 10 ns;
    aud_clk <= not aud_clk after 44 ns;

    process
        variable i : integer range 0 to 8 := 0;
        variable j : integer range 0 to 3;
    begin
        sdat <= 'Z';
        while i < 8 loop
            wait for 240 ns;
            j := 0;
            while i < 3 loop
                wait for 1280 ns;
                sdat <= '0';
                wait for 160 ns;
                sdat <= 'Z';
            end loop;
            wait for 100 ns;
        end loop;
    end process;
end sim;
