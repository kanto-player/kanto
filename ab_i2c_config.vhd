library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ab_i2c_config is
    port (clk : in std_logic;
          i2c_sdat : inout std_logic;
          i2c_sclk : out std_logic;
          config_done : out std_logic;
          config_fault : out std_logic);
end ab_i2c_config;

architecture rtl of ab_i2c_config is
    type rom_type is array (0 to 8) of std_logic_vector(0 to 15);
    type state_type is (changing, holding, fault, done);
    constant slave_addr : std_logic_vector(0 to 6) := "0011010";
    constant sdat_rom : rom_type := (
        "0001001000000000", -- deactivate the codec
        "0000000110000000", -- mute the ADC
        "0000010101111001", -- set DAC volume to 0 dB
        "0000100011010010", -- disable side tone, mute line in, select DAC
        "0000101000000000", -- disable DAC soft mute control
        "0000110000000111", -- power down ADC, mic in, and line in
        "0000111000000001", -- 16-bit, left-justified mode
        "0001000000100000", -- normal mode, 44.1 kHz, 256fs
        "0001001000000001"  -- reactivate the codec
    );
    signal i2c_data : std_logic_vector(0 to 15);
    signal i2c_start : std_logic;
    signal i2c_done : std_logic;
    signal i2c_fault : std_logic;
    signal rom_index : unsigned(2 downto 0) := "111";
    signal state : state_type := changing;
begin
    I2C : entity work.i2c_controller port map (
        clk => clk,
        addr => slave_addr,
        data => i2c_data,
        start => i2c_start,
        done => i2c_done,
        fault => i2c_fault,

        i2c_sdat => i2c_sdat,
        i2c_sclk => i2c_sclk
    );
    process (clk)
    begin
        if rising_edge(clk) then
            case state is
                when changing =>
                    state <= holding;
                when holding =>
                    if i2c_fault = '1' then
                        state <= fault;
                    elsif i2c_done = '1' then
                        if rom_index = x"7" then
                            state <= done;
                        else
                            state <= changing;
                        end if;
                    end if;
                when fault =>
                    state <= fault;
                when done =>
                    state <= done;
            end case;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) and state = changing then
            rom_index <= rom_index + "1";
        end if;
    end process;

    i2c_data <= sdat_rom(to_integer(rom_index));
    i2c_start <= '1' when state = changing else '0';
    config_fault <= '1' when state = fault else '0';
    config_done <= '1' when state = done else '0';
end rtl;

