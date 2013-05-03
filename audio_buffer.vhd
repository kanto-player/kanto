library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
          
          writeaddr : in unsigned(7 downto 0);
          writedata : in signed(15 downto 0);
          write_en : in std_logic;

          readaddr_even : in unsigned(3 downto 0);
          readdata_even : out signed(15 downto 0);
          readaddr_odd : in unsigned(3 downto 0);
          readdata_odd : out signed(15 downto 0);
          readsel : in unsigned(2 downto 0));
end audio_buffer;

architecture rtl of audio_buffer is
    signal audio_addr : unsigned(8 downto 0) := (others => '0');
    signal audio_data : signed(15 downto 0);
    signal audio_request : std_logic;
    signal last_audio_request : std_logic;
    
    signal wlr : std_logic := '0'; -- writes leading reads
    signal wfulladdr : unsigned(8 downto 0);
    signal rfulladdr_even : unsigned(8 downto 0);
    signal rfulladdr_odd : unsigned(8 downto 0);
    type ram_type is array(0 to 511) of signed(15 downto 0);
    signal audio_ram : ram_type;

begin
    wfulladdr <= wlr & writeaddr;
    rfulladdr_even <= (not wlr) & readaddr_even & readsel & '0';
    rfulladdr_odd <= (not wlr) & readaddr_odd & readsel & '1';
    
    process (clk)
        variable counter_en : std_logic := '0';
    begin
        if rising_edge(clk) then
            if write_en = '1' then
                audio_ram(to_integer(wfulladdr)) <= writedata;
            end if;
            
            readdata_even <= audio_ram(to_integer(rfulladdr_even));
            readdata_odd <= audio_ram(to_integer(rfulladdr_odd));
            
            if play = '1' then
                audio_data <= audio_ram(to_integer(audio_addr));
            else
                audio_data <= (others => '0');
            end if;

            swapped <= '0';
            last_audio_request <= audio_request;
            counter_en := audio_request and (not last_audio_request);

            if counter_en = '1' then
                -- swap when audio address reaches 255 or 511
                if audio_addr(7 downto 0) = x"ff" then
                    wlr <= audio_addr(8);
                    swapped <= '1';
                end if;
                audio_addr <= audio_addr + 1;
            elsif force_swap = '1' then
                audio_addr <= wlr & x"00";
                wlr <= not wlr;
            end if;
        end if;
    end process;

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
