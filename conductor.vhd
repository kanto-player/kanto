library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conductor is
    port (clk : in std_logic;
          reset_n : in std_logic;
          ab_audio_ok : out std_logic;
          ab_swapped : in std_logic;
          ab_force_swap : out std_logic;

          sd_start : out std_logic;
          sd_ready : in std_logic;

          fft_start : out std_logic;
          fft_done : in std_logic;
          viz_reset : out std_logic);
end conductor;

architecture rtl of conductor is
    type conductor_state is (initial, trigger_fw, first_write, force_swap,
                             playing, fft_end, block_end);
    signal state : conductor_state := initial; 
    signal fft_done_last : std_logic;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            fft_done_last <= fft_done;
            
            if reset_n = '0' then
                state <= initial;
            else
                case state is
                    when initial =>
                        if sd_ready = '1' then
                            state <= trigger_fw;
                        end if;
                    when trigger_fw =>
                        state <= first_write;
                    when first_write =>
                        if sd_ready = '1' then
                            state <= force_swap;
                        end if;
                    when force_swap =>
                        state <= playing;
                    when playing =>
                        if ab_swapped = '1' then
                            state <= block_end;
                        elsif fft_done_last = '0' and fft_done = '1' then
                            state <= fft_end;
                        end if;
                    when fft_end =>
                        state <= playing;
                    when block_end =>
                        state <= playing;
                end case;
            end if;
        end if;
    end process;

    ab_audio_ok <= '1' when state = playing or state = block_end or 
                            state = fft_end else '0';
    ab_force_swap <= '1' when state = force_swap else '0';
    sd_start <= '1' when state = trigger_fw or state = block_end or
                         state = force_swap else '0';
    fft_start <= '1' when state = block_end or state = force_swap else '0';
    viz_reset <= '1' when state = fft_end else '0';
end rtl;
