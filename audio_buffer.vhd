library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity audio_buffer is
    port (clk : in std_logic;
          en  : in std_logic;
          aud_clk : in std_logic;

          aud_adcdat : in std_logic;
          aud_adclrck : inout std_logic;
          aud_daclrck : inout std_logic;
          aud_dacdat : out std_logic;
          aud_bclk : inout std_logic;
          
          i2c_sdat : inout std_logic;
          i2c_sclk : out std_logic;
          
          sram_req : out std_logic;
          sram_ack : in std_logic;
          sram_readdata : in std_logic_vector(15 downto 0);
          sram_addr : out std_logic_vector(17 downto 0));
end audio_buffer;

architecture rtl of audio_buffer is
    component de2_i2c_av_config is
        port (iclk : in std_logic;
              irst_n : in std_logic;
              i2c_sclk : out std_logic;
              i2c_sdat : inout std_logic);
    end component;
    
    signal addr : unsigned(8 downto 0);
    signal sram_data : std_logic_vector(15 downto 0);
    signal audio_data : std_logic_vector(15 downto 0);
    signal audio_request : std_logic;
    signal mm_en : std_logic;
    signal counter_en : std_logic;
begin

    I2C_CONF : de2_i2c_av_config port map (
        iclk => clk,
        irst_n => '1',
        i2c_sdat => i2c_sdat,
        i2c_sclk => i2c_sclk
    );

    process (clk) -- assert mm_en one clock behind counter_en
    begin
        if rising_edge(clk) then
            if counter_en = '1' then
                counter_en <= '0';
                audio_data <= sram_data;
            elsif en = '1' then
                counter_en <= audio_request;
            else
                audio_data <= x"0000";
                counter_en <= '0';
            end if;
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

    CODEC : entity work.de2_wm8731_audio port map (
        clk => aud_clk,
        reset_n => en,
        test_mode => '0',
        
        aud_adclrck => aud_adclrck,
        aud_adcdat => aud_adcdat,
        aud_daclrck => aud_daclrck,
        aud_dacdat => aud_dacdat,
        aud_bclk => aud_bclk,

        data => audio_data,
        audio_request => audio_request
    );
end rtl;
