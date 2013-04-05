library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c_controller is
    port (clk : in std_logic;
          addr : in std_logic_vector(0 to 6);
          data : in std_logic_vector(0 to 15);
          start : in std_logic;
          done : out std_logic;
          err : out std_logic;

          ack_debug : out std_logic_vector(1 downto 0);

          i2c_sdat : inout std_logic;
          i2c_sclk : out std_logic);
end i2c_controller;

architecture rtl of i2c_controller is
    signal i2c_clk_divider : unsigned(2 downto 0) := "000";
    signal i2c_clk_midlow : std_logic;
    signal i2c_clk_midhigh : std_logic;
    signal active : std_logic := '0';
    type state_type is (idle, success, fail, 
                        start0, start1, stop0, stop1,
                        sa0, sa1, rw, ack0,
                        d0, d1, ack1, ack2);
    signal i2c_state : state_type := idle;
    signal bitindex : unsigned(3 downto 0) := x"0";
    signal ack_debug_intern : std_logic_vector(1 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) and active = '1' then
            i2c_clk_divider <= i2c_clk_divider + "1";
        end if;
    end process;

    active <= '0' when i2c_state = idle else '1';
    i2c_sclk <= i2c_clk_divider(2) when active = '1' else '1';
    i2c_clk_midlow <= '1' when i2c_clk_divider = "000" else '0';
    i2c_clk_midhigh <= '1' when i2c_clk_divider = "101" else '0';

    process (clk)
    begin
        if rising_edge(clk) then
            if i2c_state = ack0 or i2c_state = ack2 then
                bitindex <= x"0";
            elsif i2c_state = sa0 or i2c_state = d0 then
                bitindex <= bitindex + "1";
            end if;
        end if;
    end process;

    i2c_sdat <= addr(to_integer(bitindex)) when i2c_state = sa1 
                        or i2c_state = sa0 else
                data(to_integer(bitindex)) when i2c_state = d1 
                        or i2c_state = d0 else
                '0' when i2c_state = rw or i2c_state = start1 
                        or i2c_state = stop0 else
                '1' when i2c_state = start0 or i2c_state = stop1 else 'Z';
    done <= '1' when i2c_state = success else '0';
    err <= '1' when i2c_state = fail else '0';

    process (clk)
    begin
        if rising_edge(clk) then
            case i2c_state is
                when start0 =>
                    ack_debug_intern <= "00";
                when ack0 =>
                    ack_debug_intern <= "01";
                when ack1 =>
                    ack_debug_intern <= "10";
                when ack2 =>
                    ack_debug_intern <= "11";
                when others => 
                    ack_debug_intern <= ack_debug_intern;
            end case;
        end if;
    end process;

    ack_debug <= ack_debug_intern;

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
                    if bitindex = x"6" then
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
                    if i2c_sdat = '1' then
                        i2c_state <= fail;
                    elsif i2c_clk_midlow = '1' then
                        i2c_state <= d1;
                    else
                        i2c_state <= ack0;
                    end if;
                when d0 =>
                    if bitindex = x"7" then
                        i2c_state <= ack1;
                    elsif bitindex = x"f" then
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
                    if i2c_sdat = '1' then
                        i2c_state <= fail;
                    elsif i2c_clk_midlow = '1' then
                        i2c_state <= d1;
                    else
                        i2c_state <= ack1;
                    end if;
                when ack2 =>
                    if i2c_sdat = '1' then
                        i2c_state <= fail;
                    elsif i2c_clk_midlow = '1' then
                        i2c_state <= stop0;
                    else
                        i2c_state <= ack2;
                    end if;
                when stop0 =>
                    if i2c_clk_midhigh = '1' then
                        i2c_state <= stop1;
                    else
                        i2c_state <= stop0;
                    end if;
                when stop1 =>
                    if i2c_clk_midlow = '1' then
                        i2c_state <= success;
                    else
                        i2c_state <= stop1;
                    end if;
                when success =>
                    i2c_state <= idle;
                when fail =>
                    i2c_state <= idle;
            end case;
        end if;
    end process;
end rtl;
