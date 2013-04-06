library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity audio_buffer is
    port (clk : in std_logic;
          en  : in std_logic;
          
          initialized : out std_logic;
          fault : out std_logic;
          
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
    signal audio_data : std_logic_vector(15 downto 0);
    signal count : unsigned(10 downto 0) := "00000000000";
    signal counter_en : std_logic;
    signal mm_en : std_logic;
    signal codec_en : std_logic;
    signal config_done : std_logic;
    signal ready : std_logic;
begin

    I2C_CONF : entity work.ab_i2c_config port map (
        clk => clk,
        i2c_sdat => i2c_sdat,
        i2c_sclk => i2c_sclk,
        config_done => config_done,
        config_fault => fault
    );

    process (clk)
    begin
        if rising_edge(clk) then
            if ready = '0' then
                count <= (others => '0');
            else
                if count = "10001101101" then
                    count <= (others => '0');
                else
                    count <= count + "1";
                end if;
            end if;
        end if;
    end process;

    ready <= en and config_done;
    initialized <= ready;
    counter_en <= '1' when ready = '1' and count = "00000000000" else '0';
    mm_en <= '1' when ready = '1' and count = "00000000001" else '0';
    codec_en <= '1' when ready = '1' and count = "00100000000" else '0';

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

    audio_data <= sram_data when ready = '1' else x"0000";
end rtl;
