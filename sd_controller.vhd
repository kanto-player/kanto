library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sd_controller is
port (
    clk50           : in std_logic;
    cs              : out std_logic;
    mosi            : out std_logic;
    miso            : in std_logic;
    sclk            : out std_logic;
    start           : in std_logic;
    ready           : out std_logic;
    err             : out std_logic;
    waiting         : out std_logic;
    state_debug     : out std_logic_vector(7 downto 0);
    resp_debug      : out std_logic_vector(7 downto 0)
);
end sd_controller;

architecture rtl of sd_controller is
    signal clk_enable : std_logic := '1';
    signal clk_divider : unsigned(3 downto 0) := x"0";
    signal counter : unsigned(7 downto 0);

    constant cmd0  : std_logic_vector(47 downto 0) := x"400000000095";
    constant cmd8  : std_logic_vector(47 downto 0) := x"48000001AA87";
    constant cmd55 : std_logic_vector(47 downto 0) := x"770000000065";
    constant cmd41 : std_logic_vector(47 downto 0) := x"694000000077";
    constant cmd58 : std_logic_vector(47 downto 0) := x"7a00000000fd";
    signal command : std_logic_vector(47 downto 0);
    type sd_state is (reset_state, reset_clks1, reset_clks2, 
                      send_cmd, wait_resp, recv_resp, deselect,
                      check_cmd0, check_cmd8_head, check_cmd8_extra,
                      check_cmd58_head, check_cmd58_voltage, check_cmd58_extra,
                      check_cmd55, check_cmd41, cmd_done, cmd_err);
    signal state : sd_state := reset_state;
    signal last_state : sd_state := reset_state;
    signal return_state : sd_state;
    signal sclk_sig : std_logic;
    signal readdata : std_logic_vector(15 downto 0) := (others => '1');
    signal last_resp : std_logic;

    signal init_done : std_logic;
    signal hold_start : std_logic;
    signal state_indicator : unsigned(7 downto 0) := x"00";
    signal ccs : std_logic;
begin
    sclk <= sclk_sig;
    ready <= '1' when state = cmd_done else '0';
    err <= '1' when state = cmd_err else '0';
    resp_debug <= readdata(7 downto 0);
    state_debug <= std_logic_vector(state_indicator);
    waiting <= '1' when state = wait_resp else '0';
    
    -- clock divider for sd clock
    process(clk50)
    begin

        -- if we change states (i.e. desired sd_clk frequency)
        -- then reset counter
        if rising_edge(clk50) then
            -- if we've reached the appropriate count
            -- enable clock for one cycle and reset counter
            if clk_divider = x"7" then
                clk_enable <= '1';
                clk_divider <= x"0";
            else
                clk_enable <= '0';
                clk_divider <= clk_divider + "1";
            end if;
            
            if start = '1' then
                hold_start <= '1';
            end if;
        end if; -- rising_edge(clk50)

    end process;

    mosi <= command(47);
    cs <= '1' when state = reset_clks1 or state = deselect else '0';
    
    process(clk50)
    begin

    if rising_edge(clk50) then
    if clk_enable = '1' then

    case state is

        -- asserting mosi and cs high for at least 74 clocks
        when reset_state =>
            command <= (others => '1');
            sclk_sig <= '0';
            counter <= to_unsigned(160, 8);
            state <= reset_clks1;
            init_done <= '1';

        when reset_clks1 =>
            if counter = x"00" then
                counter <= to_unsigned(32, 8);
                state <= reset_clks2;
            else
                counter <= counter - "1";
                sclk_sig <= not sclk_sig;
            end if;

        when reset_clks2 =>
            if counter = 0 then
                command <= cmd0;
                counter <= to_unsigned(47, 8);
                return_state <= check_cmd0;
                state <= send_cmd;
                last_resp <= '1';
                state_indicator <= x"00";
            else
                counter <= counter - "1";
                sclk_sig <= not sclk_sig;
            end if;

        when check_cmd0 =>
            if readdata(7 downto 0) = x"01" then
                command <= cmd8;
                counter <= to_unsigned(47, 8);
                return_state <= check_cmd8_head;
                state <= send_cmd;
                last_resp <= '0';
                state_indicator <= x"08";
            else
                state_indicator <= x"00";
                state <= cmd_err;
            end if;

        when check_cmd8_head =>
            if readdata(2) = '0' then
                counter <= to_unsigned(31, 8);
                state <= recv_resp;
                return_state <= check_cmd8_extra;
                last_resp <= '1';
            else
                counter <= to_unsigned(47, 8);
                command <= cmd58;
                return_state <= check_cmd58_head;
                state <= send_cmd;
                last_resp <= '0';
                state_indicator <= x"58";
            end if;

        when check_cmd8_extra =>
            if readdata(11 downto 0) = "000110101010" then
                command <= cmd55;
                counter <= to_unsigned(47, 8);
                state <= send_cmd;
                return_state <= check_cmd55;
                last_resp <= '0';
                state_indicator <= x"55";
            else
                readdata(15 downto 12) <= (others => '0');
                state <= cmd_err;
            end if;

        when check_cmd58_head =>
            if readdata(2) = '1' then
                state_indicator <= x"58";
                state <= cmd_err;
            else
                counter <= to_unsigned(15, 8);
                return_state <= check_cmd58_voltage;
                state <= recv_resp;
                last_resp <= '0';
            end if;

        when check_cmd58_voltage =>
            if readdata(5) = '0' then
                state_indicator <= x"f8";
                state <= cmd_err;
            else
                counter <= to_unsigned(15, 8);
                return_state <= check_cmd58_extra;
                state <= recv_resp;
                last_resp <= '1';
            end if;

        when check_cmd58_extra =>
            command <= cmd55;
            counter <= to_unsigned(47, 8);
            state <= send_cmd;
            return_state <= check_cmd55;
            last_resp <= '0';
            state_indicator <= x"55";

        when check_cmd55 =>
            if readdata(7 downto 0) = x"01" then
                command <= cmd41;
                counter <= to_unsigned(47, 8);
                state <= send_cmd;
                return_state <= check_cmd41;
                last_resp <= '0';
                state_indicator <= x"41";
            else
                state_indicator <= x"55";
                state <= cmd_err;
            end if;

        when check_cmd41 =>
            if readdata(7 downto 0) = x"00" then
                return_state <= cmd_done;
                state <= deselect;
            elsif readdata(7 downto 0) = x"01" then
                state <= recv_resp;
                counter <= to_unsigned(7, 8);
                state_indicator <= x"41";
                return_state <= check_cmd41;
            elsif readdata(7 downto 0) = x"ff" then
                state <= send_cmd;
                command <= cmd55;
                counter <= to_unsigned(47, 8);
                return_state <= check_cmd55;
                state_indicator <= x"55";
            else
                state_indicator <= x"41";
                state <= cmd_err;
            end if;

        when send_cmd =>
            if sclk_sig = '1' then
                if counter = x"00" then
                    state <= wait_resp;
                else
                    counter <= counter - "1";
                    command <= command(46 downto 0) & "1";
                end if;
            end if;
            sclk_sig <= not sclk_sig;

        when wait_resp =>
            if sclk_sig = '1' and miso = '0' then
                counter <= to_unsigned(6, 8);
                state <= recv_resp;
                readdata <= (others => '0');
            end if;
            sclk_sig <= not sclk_sig;

        when recv_resp =>
            if sclk_sig = '1' then
                readdata <= readdata(14 downto 0) & miso;
                if counter = 0 then
                    state <= return_state;
                else
                    counter <= counter - "1";
                end if;
            end if;
            sclk_sig <= not sclk_sig;

        when deselect =>
            if counter = 0 then
                state <= return_state;
            else
                counter <= counter - 1;
                sclk_sig <= not sclk_sig;
            end if;

        when cmd_done =>
            init_done <= '1';

        when others =>
            sclk_sig <= sclk_sig;

    end case; -- state
    
    end if; -- clk_en = '1'
    end if; -- rising_edge(clk)

    end process;

end rtl;
