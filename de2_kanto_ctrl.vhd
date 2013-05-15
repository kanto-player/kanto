library ieee;
use ieee.std_logic_1164.all;

entity de2_kanto_ctrl is
    port (clk : in std_logic;
          reset_n : in std_logic;
          read : in std_logic;
          write : in std_logic;
          chipselect : in std_logic;
          address : in std_logic_vector(2 downto 0);
          readdata : out std_logic_vector(31 downto 0);
          writedata : in std_logic_vector(31 downto 0);

          nios_addr : out std_logic_vector(31 downto 0);
          nios_readblock : out std_logic;
          nios_play : out std_logic;
          nios_done : in std_logic;

          keys : in std_logic_vector(3 downto 0);

          sd_ccs : in std_logic;
          audio_track : out std_logic_vector(7 downto 0);
          sd_blockaddr : in std_logic_vector(31 downto 0));
end de2_kanto_ctrl;

-- 0 is block address
-- 1 is readblock
-- 2 is play
-- 3 is done
-- 4 is audio_track
-- 5 is keys

architecture rtl of de2_kanto_ctrl is
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset_n = '0' then
                nios_addr <= (others => '0');
                nios_play <= '0';
            elsif chipselect = '1' then
                case address is
                    when "000" =>
                        if read = '1' then
                            readdata <= sd_blockaddr;
                        elsif write = '1' then
                            nios_addr <= writedata;
                        end if;
                    when "001" =>
                        if write = '1' then
                            nios_readblock <= writedata(0);
                        end if;
                    when "010" =>
                        if write = '1' then
                            nios_play <= writedata(0);
                        end if;
                    when "011" =>
                        if read = '1' then
                            readdata <= (31 downto 1 => '0') & nios_done;
                        end if;
                    when "100" =>
                        if write = '1' then
                            audio_track <= writedata(7 downto 0);
                        end if;
                    when "101" =>
                        if read = '1' then
                            readdata <= (31 downto 4 => '0') & keys;
                        end if;
                    when "110" =>
                        if read = '1' then
                            readdata <= (31 downto 1 => '0') & sd_ccs;
                        end if;
                    when others =>
                        if read = '1' then
                            readdata <= (others => '0');
                        end if;
                end case;
            end if;
        end if;
    end process;
end rtl;
