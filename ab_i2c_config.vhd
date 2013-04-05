library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ab_i2c_config is
    port (clk : in std_logic;
          i2c_sdat : inout std_logic;
          i2c_sclk : out std_logic;
          finished : out std_logic;
          err : out std_logic);
end ab_i2c_config;

architecture rtl of ab_i2c_config is
    type rom_type is array (0 to 8) of std_logic_vector(0 to 15);
    constant slave_addr : std_logic_vector(0 to 6) := "0011010";
    constant sda_rom : rom_type := (
        "0001001000000000", -- deactivate the codec
        "0000000110000000", -- mute the ADC
        "0000010101111001", -- set DAC volume to 0 dB
        "0000100011010010", -- disable side tone, mute line in, select DAC
        "0000101000000000", -- disable DAC soft mute control
        "0000110000000111", -- power down ADC, mic in, and line in
        "0000111000000001", -- 16-bit, left-justified mode
        "0001000000100000", -- normal mode, 44.1 kHz, 256fs
        "0001001000000001", -- reactivate the codec
    );
begin
end rtl;

