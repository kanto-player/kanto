library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sd_reader is
port(
    clk_en      : in std_logic;
    clk         : in std_logic;
    clk_stretch : out std_logic;
    sd_data     : in std_logic_vector(15 downto 0);
    init_done   : in std_logic;
    mosi        : out std_logic;
    cs          : out std_logic;
    play        : in std_logic
);
end sd_reader;

architecture rtl of sd_reader is

    constant cmd_begin : std_logic_vector(0 to 7) := "01010001";
    constant cmd_end : std_logic_vector(0 to 7) := "00000001";
    signal cmd_addr : std_logic_vector(0 to 31) := (others => '0');

    type state is (idle, send_cmd_begin, send_cmd_addr, send_cmd_end,
            wait_resp_start, wait_resp, wait_data_start, data_recv,
            data_write, crc_rev);
    signal current_state : state := idle;

    signal write_done : std_logic;

begin

    cs <= '0';

    process(clk)

        variable counter : integer range 0 to 255 := 0;
        variable aux_counter : integer range 0 to 255 := 0;

    begin

    if rising_edge(clk) then

    case current_state is

        -- waiting for the signal to start loading the next 512B block
        -- do not check for clock enable - this should respond
        -- immediately on the 50MHz clock
        when idle =>
            mosi <= '1';
            clk_stretch <= '0';
            if play = '1' then
                current_state <= send_cmd_begin;
                counter := 0;
                mosi <= cmd_begin(counter);
            end if;

        -- sending the first 8 bits of cmd
        when send_cmd_begin =>
            if clk_en = '1' then
                if counter /= 7 then
                    counter := counter + 1;
                    mosi <= cmd_begin(counter);
                else
                    counter := 0;
                    current_state <= send_cmd_addr;
                    mosi <= cmd_addr(counter);
                end if;
            end if;

        -- sending sd card address
        when send_cmd_addr =>
            if clk_en = '1' then
                if counter /= 31 then
                    counter := counter + 1;
                    mosi <= cmd_addr(counter);
                else
                    counter := 0;
                    current_state <= send_cmd_end;
                    mosi <= cmd_end(counter);
                end if;
            end if;

        -- sending the last 8 bits of cmd
        when send_cmd_end =>
            if clk_en = '1' then
                if counter /= 7 then
                    counter := counter + 1;
                    mosi <= cmd_end(counter);
                else
                    counter := 0;
                    current_state <= wait_resp_start;
                    mosi <= '1';
                end if;
            end if;

        -- waiting for sd card to start responding
        -- if within 8 cycles no response resend cmd
        when wait_resp_start =>
            if clk_en = '1' then
                if sd_data(0) = '0' then
                    counter := 0;
                    current_state <= wait_resp;
                    mosi <= '1';
                elsif counter = 7 then
                    counter := 0;
                    current_state <= send_cmd_begin;
                    mosi <= cmd_begin(counter);
                else
                    counter := counter + 1;
                end if;
            end if;

        -- wait 7 more cycles for response
        -- if bad response, resend command
        when wait_resp =>
            if clk_en = '1' then
                if counter /= 6 then
                    counter := counter + 1;
                    mosi <= '1';
                elsif sd_data(7 downto 0) /= "00000000" then
                    counter := 0;
                    current_state <= send_cmd_begin;
                    mosi <= cmd_begin(counter);
                else
                    counter := 0;
                    current_state <= wait_data_start;
                    mosi <= '1';
                end if;
            end if;

        -- waiting for the 0xFE byte indiciating start of data
        when wait_data_start =>
            if clk_en = '1' then
                if sd_data(7 downto 0) = "11111110" then
                    counter := 0;
                    aux_counter := 0;
                    current_state <= data_recv;
                    mosi <= '1';
                end if;
            end if;

        -- receiving two bytes from sd card
        when data_recv =>
            if clk_en = '1' then
                if aux_counter /= 15 then
                    aux_counter := aux_counter + 1;
                    mosi <= '1';
                else
                    aux_counter := 0;
                    current_state <= data_write;
                    mosi <= '1';
                    clk_stretch <= '1';
                end if;
            end if;

        -- write two bytes to sram
        -- this is not synchronized to the clock enbale, so that
        -- writes happen as quickly as possible
        when data_write =>

            -- TODO: write to sram here

            if write_done = '1' then
                if counter /= 255 then
                    counter := counter + 1;
                    current_state <= data_recv;
                else
                    counter := 0;
                    current_state <= crc_rev;
                end if;
                mosi <= '1';
                clk_stretch <= '0';
            end if;

        -- simply ignore the 16 bit CRC data
        when crc_rev =>
            if clk_en = '1' then
                if counter /= 15 then
                    counter := counter + 1;
                    mosi <= '1';
                else
                    counter := 0;
                    current_state <= idle;
                    mosi <= '1';
                end if;
            end if;

    end case; -- current_state

    end if; -- rising_edge(clk)

    end process;

end rtl;
