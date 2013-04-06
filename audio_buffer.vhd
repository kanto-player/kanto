library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity audio_buffer is
    port (clk : in std_logic;
          en  : in std_logic;
          aud_clk : in std_logic;

          aud_daclrck : inout std_logic;
          aud_dacdat : out std_logic;
          aud_bclk : inout std_logic;
          
          initialized : out std_logic;
          fault : out std_logic;
          sram_debug : out std_logic_vector(15 downto 0);
          dacdat_debug : out std_logic;
          
          i2c_sdat : inout std_logic;
          i2c_sclk : out std_logic;
          
          sram_req : out std_logic;
          sram_ack : in std_logic;
          sram_readdata : in std_logic_vector(15 downto 0);
          sram_addr : out std_logic_vector(17 downto 0));
end audio_buffer;

architecture rtl of audio_buffer is
    signal addr : unsigned(9 downto 0);
    signal sram_data : std_logic_vector(15 downto 0);
    signal counter_en : std_logic;
    signal mm_en : std_logic;
    signal config_done : std_logic;
    signal ready : std_logic;
    signal next_samp : std_logic;
    signal dacdat : std_logic;
begin

    I2C_CONF : entity work.ab_i2c_config port map (
        clk => clk,
        i2c_sdat => i2c_sdat,
        i2c_sclk => i2c_sclk,
        config_done => config_done,
        config_fault => fault
    );

    ready <= en and config_done;
    initialized <= ready;
    counter_en <= ready and next_samp;

    process (clk) -- assert mm_en one clock behind counter_en
    begin
        if rising_edge(clk) then
            mm_en <= counter_en;
        end if;
    end process;

    COUNTER : entity work.ab_counter port map (
        addr => addr,
        clk => clk,
        en => counter_en
    );

    MM : entity work.ab_middleman port map (
        addr => addr,
        data => sram_data,
        clk => clk,
        en => mm_en,
        sram_req => sram_req,
        sram_ack => sram_ack,
        sram_readdata => sram_readdata,
        sram_addr => sram_addr
    );

    CODEC : entity work.ab_codec port map (
        clk => aud_clk,
        en => ready,

        aud_daclrck => aud_daclrck,
        aud_dacdat => dacdat,
        aud_bclk => aud_bclk,

        data => sram_data,
        next_samp => next_samp
    );

    aud_dacdat <= dacdat;
    dacdat_debug <= dacdat;
    sram_debug<= sram_data;
end rtl;
