library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ab_counter is
    port (addr : out unsigned(8 downto 0);
          clk  : in std_logic;
          en   : in std_logic);
end ab_counter;

architecture rtl of ab_counter is
    signal count : unsigned(8 downto 0) := "000000000";
begin
    addr <= count;

    process (clk)
    begin
        if rising_edge(clk) and en = '1' then
            count <= count + "1";
        end if;
    end process;
end rtl;
