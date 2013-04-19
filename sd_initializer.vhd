library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sd_initializer is
port(
    clk_en      : in std_logic;
    clk         : in std_logic;
    init_done   : out std_logic;
    mosi        : out std_logic;
    miso        : in std_logic;
    sclk        : out std_logic;
    cs          : out std_logic
);
end sd_initializer;

architecture rtl of sd_initializer is

    constant reset_cmd : std_logic_vector(0 to 47) := "010000000000000000000000000000000000000010010101";

    -- send_assert - start by asserting mosi, cs high
    -- send_cmd - send the 48 bit command specifying SPI mode
    -- wait_resp - waiting for sd card response to command
    -- done - successfully set to spi mode
    type state is (send_assert, send_cmd, wait_resp_start, wait_resp, done);
    signal current_state : state := send_assert;
    signal sclk_sig : std_logic := '0';
    signal read_resp : std_logic_vector(7 downto 0);

begin
    sclk <= sclk_sig;
    
    process(clk)
        variable counter : integer range 0 to 127 := 0;
    begin

    if rising_edge(clk) then
    if clk_en = '1' then

    case current_state is

        -- asserting mosi and cs high for at least 74 clocks
        when send_assert =>
            init_done <= '0';
            cs <= '1';
            mosi <= '1';
            if counter /= 75 then
                if sclk_sig = '1' then
                    counter := counter + 1;
                end if;
                sclk_sig <= not sclk_sig;
            else -- clock should be low at this point
                counter := 0;
                current_state <= send_cmd;
                cs <= '0';
                mosi <= reset_cmd(counter);
                sclk_sig <= '1';
            end if;

        -- sending command for spi mode
        when send_cmd =>
            if counter /= 47 then
                if sclk_sig = '0' then
                    counter := counter + 1;
                    mosi <= reset_cmd(counter);
                end if;
                sclk_sig <= not sclk_sig;
            else -- clock should be high at this point
                counter := 0;
                current_state <= wait_resp_start;
                mosi <= '1';
                sclk_sig <= '0';
            end if;
                
        -- waiting for response after sending cmd
        -- if response does not begin within 16 cycles, resend
        when wait_resp_start =>
            if miso = '0' and sclk_sig = '1' then
                counter := 0;
                current_state <= wait_resp;
                sclk_sig <= '0';
            elsif counter = 15 then -- should be low at this point
                counter := 0;
                current_state <= send_cmd;
                mosi <= reset_cmd(counter);
                sclk_sig <= '1';
            else
                if sclk_sig = '1' then
                    counter := counter + 1;
                end if;
                sclk_sig <= not sclk_sig;
            end if;

        -- wait 7 cycles for response
        -- if bad response, resend command
        when wait_resp =>
            if counter /= 6 then
                if sclk_sig = '1' then
                    read_resp <= read_resp(6 downto 0) & miso;
                    counter := counter + 1;
                end if;
                sclk_sig <= not sclk_sig;
            elsif read_resp /= "00000001" then -- sclk should be low here
                counter := 0;
                current_state <= send_cmd;
                mosi <= reset_cmd(counter);
            else
                counter := 0;
                current_state <= done;
                init_done <= '1';
            end if;

        -- finished with initialization - sd controller will give
        -- control of cs and mosi to another component
        when done =>
            init_done <= '1';

    end case; -- current_state
    
    end if; -- clk_en = '1'
    end if; -- rising_edge(clk)

    end process;

end rtl;
