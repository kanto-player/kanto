library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sd_checker is
    port (clk : in std_logic;
          err : out std_logic;
          ok  : out std_logic;
          phase_out : out std_logic;

          badaddr : out unsigned(7 downto 0);
          baddata : out unsigned(7 downto 0);
          
          writedata : in signed(15 downto 0);
          writeaddr : in unsigned(7 downto 0);
          write_en : in std_logic);
end sd_checker;

architecture rtl of sd_checker is
    type checker_state is (checking, aok, oops);
    signal state : checker_state;
    signal lower_byte : unsigned(7 downto 0);
    signal higher_lsb : std_logic;
    signal phase : std_logic := '0';
    signal old_write_en : std_logic;
begin
    lower_byte <= unsigned(writedata(7 downto 0));
    higher_lsb <= writedata(8);
    phase_out <= phase;

    process (clk)
    begin
        if rising_edge(clk) then
            old_write_en <= write_en;
            case state is
                when checking =>
                    if write_en = '1' and old_write_en = '0' then
                        if phase = '0' then
                            if lower_byte /= writeaddr then
                                state <= oops;
                                badaddr <= writeaddr;
                                baddata <= lower_byte;
                            elsif writeaddr = x"ff" then
                                phase <= '1';
                            end if;
                        else
                            if lower_byte /= (not writeaddr) then
                                state <= oops;
                                badaddr <= writeaddr;
                                baddata <= lower_byte;
                            elsif writeaddr = x"ff" then
                                state <= aok;
                            end if;
                        end if;
                    end if;
                    err <= '0';
                    ok <= '0';
                when oops =>
                    err <= '1';
                when aok =>
                    ok <= '1';
            end case;
        end if;
    end process;
end rtl;
