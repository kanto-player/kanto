library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conductor is
    port (clk : in std_logic;
          ab_audio_ok : out std_logic;
          ab_swapped : in std_logic;
          ab_force_swap : out std_logic;
          fft_allow_write : out std_logic;

          sd_start : out std_logic;
          sd_ready : in std_logic;
          cond_err : out std_logic;
          sd_address : out unsigned(31 downto 0);
          sd_ccs : in std_logic;

          fft_start : out std_logic;
          fft_done : in std_logic;
          viz_reset : out std_logic);
end conductor;

architecture rtl of conductor is
    type conductor_state is (initial, trigger_fw, first_write, force_swap,
                             playing, fft_end, block_end);
    signal state : conductor_state := initial; 
    signal fft_done_last : std_logic;
    signal fft_counter : unsigned(1 downto 0) := "11";
    signal blockaddr : unsigned(31 downto 0);
begin
    sd_address <= blockaddr;
    
    process (clk)
    begin
        if rising_edge(clk) then
            fft_done_last <= fft_done;
            
            case state is
                when initial =>
                    if sd_ready = '1' then
                        -- once SD card is initialized,
                        -- make it read first block of audio
                        state <= trigger_fw;
                        blockaddr <= (others => '0');
                    end if;
                when trigger_fw =>
                    state <= first_write;
                when first_write =>
                    if sd_ready = '1' then
                        -- once first block is read, swap the r/w buffers
                        state <= force_swap;
                        blockaddr <= blockaddr + 1;
                    end if;
                when force_swap =>
                    -- once swapped, we can allow audio to play
                    state <= playing;
                    fft_counter <= "00";
                when playing =>
                    if ab_swapped = '1' then
                        -- if we've outrun the SD card
                        -- indicate that an error has occurred
                        if sd_ready = '0' then
                            cond_err <= '1';
                        else
                            cond_err <= '0';
                        end if;
                        fft_counter <= fft_counter + 1;
                        state <= block_end;

                        if sd_ccs = '1' then
                            blockaddr <= blockaddr + 1;
                        else
                            blockaddr <= blockaddr + 512;
                        end if;
                    elsif fft_done_last = '0' and fft_done = '1' then
                        state <= fft_end;
                    end if;
                when fft_end =>
                    state <= playing;
                when block_end =>
                    -- once the audio buffer has switched blocks
                    -- tell SD card to read another block and,
                    -- on every fourth block, start FFT
                    state <= playing;
            end case;
        end if;
    end process;

    -- can play audio once initialization is done
    ab_audio_ok <= '1' when state = playing or state = block_end or 
                            state = fft_end else '0';
    ab_force_swap <= '1' when state = force_swap else '0';
    sd_start <= '1' when state = trigger_fw or state = block_end or
                         state = force_swap else '0';
    -- only compute fft and refresh visualizer every fourth block
    fft_start <= '1' when state = block_end and fft_counter = 0 else '0';
    viz_reset <= '1' when state = fft_end else '0';

    -- only let sd card write to FFT unit the block before FFT is computed
    fft_allow_write <= '1' when fft_counter = "11" else '0';
end rtl;
