library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sd_controller is
port (
    clk50           : in std_logic;
    cs              : out std_logic;
    mosi            : out std_logic;
    miso            : in std_logic;
    play            : in std_logic;
    ready           : out std_logic
);
end sd_controller;

architecture datapath of sd_controller is
     
    signal shift_reg_data : std_logic_vector(15 downto 0);
    signal init_done : std_logic;

    signal init_mosi : std_logic;
    signal init_cs : std_logic;

    signal reader_mosi : std_logic;
    signal reader_cs : std_logic;

    signal sd_clk_enable : std_logic := '1';
    signal clk_counter : integer range 0 to 255;
	 signal init_done_old : std_logic;

begin

    -- shift register which gets the data coming from the sd card
    SHIFT_REG : work.sd_shift_register port map (
        clk_en => sd_clk_enable,
        clk => clk50,
        data_in => miso,
        data_out => shift_reg_data
    );

    -- responsible for sending read commands to sd card and writing
    -- response to sram
    READER : work.sd_reader port map (
        clk_en => sd_clk_enable,
        clk => clk50,
        sd_data => shift_reg_data,
        init_done => init_done,
        mosi => reader_mosi,
        cs => reader_cs,
        play => play
    );

    -- initializes the sd card in spi mode. asserts done to high when
    -- initialization is complete
    INIT : work.sd_initializer port map (
        clk_en => sd_clk_enable,
        clk => clk50,
        sd_data => shift_reg_data,
        init_done => init_done,
        mosi => init_mosi,
        cs => init_cs
    );

    -- multiplex mosi and cs signals between initializer and reader
    mosi <= init_mosi when init_done = '0'
            else reader_mosi;
    cs <= init_cs when init_done = '0'
          else reader_cs;


    -- clock divider for sd clock
    process(init_done, clk50)
    begin

        -- if we change states (i.e. desired sd_clk frequency)
        -- then reset counter
        if init_done /= init_done_old then
            clk_counter <= 0;

        elsif rising_edge(clk50) then

            -- if we've reached the appropriate count
            -- enable clock for one cycle and reset counter
            if (init_done = '0' and clk_counter = 249)
                    or (init_done = '1' and clk_counter = 24) then
                sd_clk_enable <= '1';
                clk_counter <= 0;
				else
				    sd_clk_enable <= '0';
					 clk_counter <= clk_counter + 1;
            end if;

        end if; -- rising_edge(clk50)

		  init_done_old <= init_done;
		  
    end process;

end datapath;
