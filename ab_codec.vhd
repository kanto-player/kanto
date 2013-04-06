library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ab_codec is
    port (clk : in std_logic;
          en : in std_logic;
          
          aud_daclrck : inout std_logic;
          aud_dacdat : out std_logic;
          aud_bclk : inout std_logic;

          data : in std_logic_vector(15 downto 0);
          next_samp : out std_logic);
end ab_codec;

architecture rtl of ab_codec is
    signal bclk : std_logic := '0';
    signal daclrck_div : unsigned(7 downto 0) := x"7f";
    signal dac_left : std_logic;
    signal dac_right : std_logic;
    type state_type is (lsend, lwait, rsend, reqnext, rwait);
    signal state : state_type := lwait;
    signal bitindex : unsigned(3 downto 0);
    signal sending : std_logic;
begin
    process (clk) -- Divide clk by 2 to get bclk
    begin
        if rising_edge(clk) then
            if en = '1' then
                bclk <= not bclk;
            else
                bclk <= '0';
            end if;
        end if;
    end process;

    process (clk) -- Divide clk by 256 to get lrck
    begin
        if rising_edge(clk) then
            if en = '1' then
                daclrck_div <= daclrck_div + "1";
            else
                daclrck_div <= x"7f";
            end if;
        end if;
    end process;

    aud_daclrck <= daclrck_div(7);
    aud_bclk <= bclk;

    dac_left <= '1' when daclrck_div = x"80" else '0';
    dac_right <= '1' when daclrck_div = x"00" else '0';
    sending <= '1' when state = lsend or state = rsend else '0';

    next_samp <= '1' when state = reqnext else '0';
    aud_dacdat <= data(to_integer(bitindex)) when sending = '1' else '0';

    process (clk)
    begin
        if rising_edge(clk) and en = '1' then
            case state is
                when lsend =>
                    if bclk = '1' and bitindex = x"0" then
                        state <= rwait;
                    end if;
                when rsend =>
                    if bclk = '1' and bitindex = x"0" then
                        state <= reqnext;
                    end if;
                when reqnext =>
                    state <= lwait;
                when lwait =>
                    if dac_left = '1' then
                        state <= lsend;
                    end if;
                when rwait =>
                    if dac_right = '1' then
                        state <= rsend;
                    end if;
            end case;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if en = '1' and bclk = '1' then
                if dac_left = '1' then
                    bitindex <= x"f";
                elsif dac_right = '1' then
                    bitindex <= x"f";
                elsif sending = '1' then
                    bitindex <= bitindex - "1";
                end if;
            elsif en = '0' then
                bitindex <= x"f";
            end if;
        end if;
    end process;
    
end rtl;
