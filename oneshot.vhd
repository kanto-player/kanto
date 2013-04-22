library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- oneshot trigger
-- assert edge high for one clock cycle
-- on rising edge of level

entity oneshot is
    port (clk : in std_logic;
          level : in std_logic;
          edge : out std_logic);
end oneshot;

architecture rtl of oneshot is
    signal oldlevel : std_logic;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            oldlevel <= level;
        end if;
    end process;

    edge <= (not oldlevel) and level;
end rtl;
