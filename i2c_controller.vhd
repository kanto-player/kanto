library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

entity i2c_controller is
    port (clk : in std_logic;
          address : in std_logic_vector(0 to 6);
          data : in std_logic_vector(0 to 15);
          start : in std_logic;
          done : out std_logic;

          I2C_SDA : inout std_logic;
          I2C_SCLK : out std_logic);
end i2c_controller;

architecture rtl of i2c_controller is
    signal long_clk : std_logic;
    signal last_clk : std_logic;
    signal long_clk_divider : std_logic_vector(9 downto 0);
    type state_type is (idle, start, 
                        a0, a1, a2, a3, a4, a5, a6, rw, ack0
                        d0, d1, d2, d3, d4, d5, d6, d7, ack1
                        d8, d9, d10, d11, d12, d13, d14, d15, ack2);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            long_clk_divider <= long_clk_divider + "1";
        end if;
    end process;

    long_clk <= long_clk_divider(9);

    process (clk)
    begin
        if rising_edge(clk) then
            last_clk <= long_clk;
        end if;
    end process;

    process (clk)
    begin
end rtl;
