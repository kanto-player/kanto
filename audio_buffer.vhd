library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity audio_buffer is
    port (clk : in std_logic;
          play : in std_logic;
          aud_clk : in std_logic;
          swapped : out std_logic;
          force_swap : in std_logic;

          aud_adcdat : in std_logic;
          aud_adclrck : inout std_logic;
          aud_daclrck : inout std_logic;
          aud_dacdat : out std_logic;
          aud_bclk : inout std_logic;
          
          i2c_sdat : inout std_logic;
          i2c_sclk : out std_logic;

          writeaddr : in unsigned(7 downto 0);
          writedata : in signed(15 downto 0);
          write_en : in std_logic;

          readaddr : in nibble_array;
          readdata : out real_signed_array);
end audio_buffer;

architecture rtl of audio_buffer is
    component de2_i2c_av_config is
        port (iclk : in std_logic;
              irst_n : in std_logic;
              i2c_sclk : out std_logic;
              i2c_sdat : inout std_logic);
    end component;
    
    signal audio_addr : unsigned(8 downto 0) := (others => '0');
    signal audio_data : signed(15 downto 0);
    signal audio_request : std_logic;
    
    signal wlr : std_logic := '0'; -- writes leading reads
    signal wfulladdr : unsigned(8 downto 0);
    signal rfulladdr : aud_addr_array;
    type ram_type is array(0 to 511) of signed(15 downto 0);
    signal audio_ram : ram_type;

    signal audio_en : std_logic;
    signal counter_en : std_logic := '0';
begin
    I2C_CONF : de2_i2c_av_config port map (
        iclk => clk,
        irst_n => '1',
        i2c_sdat => i2c_sdat,
        i2c_sclk => i2c_sclk
    );

    wfulladdr <= wlr & writeaddr;
    process (clk)
    begin
        if rising_edge(clk) then
            if write_en = '1' then
                audio_ram(to_integer(wfulladdr)) <= writedata;
            end if;
        end if;
    end process;

    AURDGEN : for i in 0 to 15 generate
        rfulladdr(i) <= (not wlr) & readaddr(i) & to_unsigned(i, 4);
        readdata(i) <= audio_ram(to_integer(rfulladdr(i)));
    end generate AURDGEN;

    process (clk) -- assert mm_en one clock behind counter_en
    begin
        if rising_edge(clk) then
            swapped <= '0';

            if counter_en = '1' then
                -- swap when audio address reaches 255 or 511
                if audio_addr(7 downto 0) = x"ff" then
                    wlr <= audio_addr(8);
                    swapped <= '1';
                end if;
                counter_en <= '0';
                audio_addr <= audio_addr + 1;
            elsif force_swap = '1' then
                swapped <= '1';
                audio_addr <= wlr & x"00";
                wlr <= not wlr;
            elsif play = '1' then
                counter_en <= audio_request;
            end if;
        end if;
    end process;

    audio_data <= audio_ram(to_integer(audio_addr)) 
                    when audio_en = '1' else (others => '0');

    CODEC : entity work.de2_wm8731_audio port map (
        clk => aud_clk,
        reset_n => play,
        test_mode => '0',
        
        aud_adclrck => aud_adclrck,
        aud_adcdat => aud_adcdat,
        aud_daclrck => aud_daclrck,
        aud_dacdat => aud_dacdat,
        aud_bclk => aud_bclk,

        data => std_logic_vector(audio_data),
        audio_request => audio_request
    );
end rtl;
