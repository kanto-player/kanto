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
    play            : in std_logic;
    ready           : out std_logic;
    err             : out std_logic
);
end sd_controller;

architecture rtl of sd_controller is
    signal clk_enable : std_logic := '1';
    signal clk_counter : integer range 0 to 255;
    signal init_done : std_logic := '0';
    signal init_done_old : std_logic;
    signal read_done : std_logic := '1';

    constant reset_cmd : std_logic_vector(0 to 47) := "010000000000000000000000000000000000000010010101";
    type state is (init_hold, send_cmd0, wait_cmd0_resp, cmd0_resp, 
                   send_cmd17, cmd17_check_noerr, cmd17_wait_data, cmd17_read_data,
                   mem_write, done, init_err);
    signal current_state : state := init_hold;
    signal sclk_sig : std_logic := '0';
    signal read_resp : std_logic_vector(15 downto 0) := (others => '1');

    signal hold_play : std_logic;
begin
    sclk <= sclk_sig;
    ready <= init_done and read_done;
    
    -- clock divider for sd clock
    process(clk50)
    begin

        -- if we change states (i.e. desired sd_clk frequency)
        -- then reset counter
        if rising_edge(clk50) then
            -- if we've reached the appropriate count
            -- enable clock for one cycle and reset counter
            if (init_done = '0' and clk_counter = 62)
                    or (init_done = '1' and clk_counter = 24) then
                clk_enable <= '1';
                clk_counter <= 0;
            else
                clk_enable <= '0';
                clk_counter <= clk_counter + 1;
            end if;
            
            if init_done /= init_done_old then
                clk_counter <= 0;
            end if;
            
            init_done_old <= init_done;

            if play = '1' then
                hold_play <= '1';
            end if;
        end if; -- rising_edge(clk50)

    end process;

    process(clk50)
        variable counter : integer range 0 to 127 := 0;
    begin

    if rising_edge(clk50) then
    if clk_enable = '1' then

    case current_state is

        -- asserting mosi and cs high for at least 74 clocks
        when init_hold =>
            init_done <= '0';
            cs <= '1';
            mosi <= '1';
            err <= '0';
            if sclk_sig = '1' then
                if counter /= 75 then
                    counter := counter + 1;
                else
                    counter := 0;
                    current_state <= send_cmd0;
                    cs <= '0';
                    mosi <= reset_cmd(counter);
                    sclk_sig <= '0';
                end if;
            end if;
            sclk_sig <= not sclk_sig;

        -- sending command for spi mode
        when send_cmd0 =>
            read_resp <= x"001d";
            if sclk_sig = '1' then
                if counter /= 47 then
                    counter := counter + 1;
                    mosi <= reset_cmd(counter);
                else -- clock should be high at this point
                    counter := 0;
                    current_state <= wait_cmd0_resp;
                    mosi <= '1';
                end if;
            end if;
            sclk_sig <= not sclk_sig;
                
        -- waiting for response after sending cmd
        -- if response does not begin within 16 cycles, resend
        when wait_cmd0_resp =>
            if sclk_sig = '1' then
                if miso = '0' then
                    counter := 0;
                    current_state <= cmd0_resp;
                    read_resp <= x"fffe";
                elsif counter = 15 then
                    counter := 0;
                    current_state <= send_cmd0;
                    mosi <= reset_cmd(counter);
                else
                    counter := counter + 1;
                end if;
            end if;
            sclk_sig <= not sclk_sig;

        -- wait 7 cycles for response
        -- if bad response, resend command
        when cmd0_resp =>
            if sclk_sig = '1' then
                if counter /= 7 then
                    read_resp <= read_resp(14 downto 0) & miso;
                    counter := counter + 1;
                elsif read_resp(7 downto 0) /= "00000001" then
                    current_state <= init_err;
                else
                    counter := 0;
                    current_state <= done;
                    init_done <= '1';
                end if;
            end if;
            sclk_sig <= not sclk_sig;

        -- finished with initialization - sd controller will give
        -- control of cs and mosi to another component
        when done =>
            init_done <= '1';
            read_done <= '1';
        
        when others =>
            err <= '1';

    end case; -- current_state
    
    end if; -- clk_en = '1'
    end if; -- rising_edge(clk)

    end process;

end rtl;
