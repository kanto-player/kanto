library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity audio_buffer_tb is
end audio_buffer_tb;

architecture sim of audio_buffer_tb is
    signal req : std_logic;
    signal ack : std_logic;
    signal addr : std_logic_vector(17 downto 0);
    signal readdata : std_logic_vector(15 downto 0);
    signal clk : std_logic := '0';
begin
    AB : entity work.audio_buffer port map (
        clk => clk,
        en => '1',
        sram_req => req,
        sram_ack => ack,
        sram_readdata => readdata,
        sram_addr => addr,
    );

    SID : entity work.sram_id_dummy port map (
        clk => clk,
        req => req,
        ack => ack,
        addr => addr,
        readdata => readdata
    );

    clk <= not clk after 10 ns;
end sim;
