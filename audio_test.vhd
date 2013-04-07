library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity audio_test is
    port (clk : in std_logic;
          en  : in std_logic;
          aud_clk : in std_logic;

          aud_adcdat : in std_logic;
          aud_adclrck : inout std_logic;
          aud_daclrck : inout std_logic;
          aud_dacdat : out std_logic;
          aud_bclk : inout std_logic;
          
          i2c_sdat : inout std_logic;
          i2c_sclk : out std_logic);
end audio_test;

architecture rtl of audio_test is
    component de2_i2c_av_config is
        port (iclk : in std_logic;
              irst_n : in std_logic;
              i2c_sclk : out std_logic;
              i2c_sdat : inout std_logic);
    end component;

    signal audio_request : std_logic;
    signal request_data : std_logic;
    signal ready : std_logic;
    signal index : unsigned(7 downto 0) := x"00";
    signal data : std_logic_vector(15 downto 0);
    type rom_type is array(0 to 168) of std_logic_vector(15 downto 0);
    constant audio_rom : rom_type := (
        x"0000", x"04c5", x"0988", x"0e48", x"1303", x"17b7", x"1c63", 
        x"2105", x"259b", x"2a24", x"2e9d", x"3306", x"375d", x"3ba0", 
        x"3fce", x"43e6", x"47e5", x"4bca", x"4f95", x"5343", x"56d4", 
        x"5a46", x"5d97", x"60c8", x"63d6", x"66c0", x"6986", x"6c26", 
        x"6ea0", x"70f3", x"731d", x"751f", x"76f7", x"78a4", x"7a27", 
        x"7b7e", x"7ca9", x"7da8", x"7e7a", x"7f1f", x"7f97", x"7fe2", 
        x"7fff", x"7fef", x"7fb1", x"7f45", x"7ead", x"7de7", x"7cf5", 
        x"7bd6", x"7a8b", x"7914", x"7773", x"75a7", x"73b1", x"7192", 
        x"6f4a", x"6cdb", x"6a46", x"678a", x"64aa", x"61a6", x"5e7f", 
        x"5b36", x"57cd", x"5445", x"509f", x"4cdc", x"48fe", x"4506", 
        x"40f5", x"3ccd", x"3890", x"343e", x"2fda", x"2b65", x"26e1", 
        x"224e", x"1db0", x"1906", x"1454", x"0f9b", x"0adc", x"061a", 
        x"0155", x"fc90", x"f7cc", x"f30b", x"ee4e", x"e998", x"e4ea", 
        x"e045", x"dbac", x"d71f", x"d2a1", x"ce33", x"c9d7", x"c58e", 
        x"c15a", x"bd3d", x"b937", x"b54a", x"b178", x"adc1", x"aa28", 
        x"a6ae", x"a353", x"a019", x"9d01", x"9a0d", x"973d", x"9492", 
        x"920d", x"8faf", x"8d79", x"8b6c", x"8989", x"87d0", x"8641", 
        x"84de", x"83a6", x"829b", x"81bc", x"810a", x"8086", x"802e", 
        x"8004", x"8008", x"8039", x"8098", x"8124", x"81dd", x"82c3", 
        x"83d6", x"8514", x"867f", x"8814", x"89d4", x"8bbf", x"8dd2", 
        x"900f", x"9273", x"94fe", x"97af", x"9a85", x"9d7f", x"a09c", 
        x"a3dc", x"a73c", x"aabb", x"ae59", x"b214", x"b5eb", x"b9dc", 
        x"bde6", x"c207", x"c63f", x"ca8b", x"ceea", x"d35a", x"d7db", 
        x"dc6a", x"e105", x"e5ab", x"ea5b", x"ef12", x"f3d0", x"f892", 
        x"fd56");
begin
    I2C_CONF : de2_i2c_av_config port map (
        iclk => clk,
        irst_n => '1',
        i2c_sdat => i2c_sdat,
        i2c_sclk => i2c_sclk
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

        data => data,
        audio_request => audio_request
    );

    data <= audio_rom(to_integer(index)) when en = '1' else x"0000";
    request_data <= audio_request and en;

    process (aud_clk)
    begin
        if rising_edge(aud_clk) and request_data = '1' then
            if index = x"a8" then
                index <= x"00";
            else
                index <= index + x"1";
            end if;
        end if;
    end process;
end rtl;
