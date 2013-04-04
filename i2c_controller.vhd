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
          err : out std_logic;

          i2c_sda : inout std_logic;
          i2c_sclk : out std_logic);
end i2c_controller;

architecture rtl of i2c_controller is
    signal i2c_clk_divider : std_logic_vector(9 downto 0);
    signal i2c_clk_midlow : std_logic;
    signal i2c_clk_midhigh : std_logic;
    signal active : std_logic := '0';
    type state_type is (idle, success, fail, 
                        start0, start1, 
                        sa0, sa1, rw, ack0,
                        d0, d1, ack1, ack2);
    signal i2c_state : state_type := idle;
    signal bitindex : std_logic_vector(3 downto 0) := x"0";
begin
    process (clk)
    begin
        if rising_edge(clk) and active = '1' then
            i2c_clk_divider <= i2c_clk_divider + "1";
        end if;
    end process;

    active <= '0' when state = idle else '1';
    i2c_sclk <= i2c_clk_divider(9) when active = '1' else '1';
    i2c_clk_midlow <= '1' when i2c_clk_divider = "0000000001" else '0';
    i2c_clk_midhigh <= '1' when i2c_clk_divider = "1000000001" else '0';

    process (clk)
    begin
        if rising_edge(clk) then
            if state = ack0 or state = ack2 then
                bitindex <= x"0";
            else
                bitindex <= bitindex + "1";
            end if;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            case i2c_state is
                when idle =>
                    if start = '1' then
                        i2c_state <= start0;
                    else
                        i2c_state <= idle;
                    end if;
                when start0 =>
                    if i2c_clk_midhigh = '1' then
                        i2c_state <= start1;
                    else
                        i2c_state <= start0;
                    end if;
                when start1 =>
                    if i2c_clk_midlow = '1' then
                        i2c_state <= sa1;
                    else
                        i2c_state <= start1;
                    end if;
                when sa0 =>
                    if bitindex = x"6"; then
                        i2c_state <= rw;
                    else
                        i2c_state <= sa1;
                    end if;
                when sa1 =>
                    if i2c_clk_midlow = '1' then
                        i2c_state <= sa0;
                    else
                        i2c_state <= sa1;
                    end if;
                when rw =>
                    if i2c_clk_midlow = '1' then
                        i2c_state <= ack0;
                    else
                        i2c_state <= rw;
                    end if;
                when ack0 =>
                    if i2c_sda = '1' then
                        i2c_state <= fail;
                    elsif i2c_clk_midlow = '1' then
                        i2c_state <= d1;
                    else
                        i2c_state <= ack0;
                    end if;
                when d0 =>
                    if bitindex = x"7"; then
                        i2c_state <= ack1;
                    elsif bitindex = x"f"; then
                        i2c_state <= ack2;
                    else
                        i2c_state <= d1;
                    end if;
                when d1 =>
                    if i2c_clk_midlow = '1' then
                        i2c_state <= d0;
                    else
                        i2c_state <= d1;
                    end if;
                when ack1 =>
                    if i2c_sda = '1' then
                        i2c_state <= fail;
                    elsif i2c_clk_midlow = '1' then
                        i2c_state <= d1;
                    else
                        i2c_state <= ack1;
                    end if;
                when ack2 =>
                    if i2c_sda = '1' then
                        i2c_state <= fail;
                    elsif i2c_clk_midlow = '1' then
                        i2c_state <= success;
                    else
                        i2c_state <= ack2;
                    end if;
                when success =>
                    i2c_state <= idle;
                when fail =>
                    i2c_state <= idle;
            end case;
        end if;
    end process;
end rtl;
