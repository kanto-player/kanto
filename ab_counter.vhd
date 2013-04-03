library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ab_counter is
    port (addr : out unsigned(9 downto 0);
          clk  : in std_logic;
          en   : in std_logic);
end ab_counter;

architecture rtl of ab_counter is
    signal count : unsigned(9 downto 0) := "0000000000";
begin
    addr <= count;

    process (clk)
    begin
        if rising_edge(clk) and en = '1' then
            if count = "1011111111" then
                count <= "0000000000";
            else
                count <= count + "1";
            end if;
        end if;
    end process;
end rtl;
