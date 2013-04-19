library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sevenseg is
    port(number  : in std_logic_vector(3 downto 0);
         display : out std_logic_vector(6 downto 0));
end sevenseg;

architecture rtl of sevenseg is
begin
    with number select
        display <= "1000000" when x"0",
                      "1111001" when x"1",
                      "0100100" when x"2",
                      "0110000" when x"3",
                      "0011001" when x"4",
                      "0010010" when x"5",
                      "0000010" when x"6",
                      "1111000" when x"7",
                      "0000000" when x"8",
                      "0011000" when x"9",
                      "0001000" when x"A",
                      "0000011" when x"b",
                      "1000110" when x"C",
                      "0100001" when x"d",
                      "0000110" when x"E",
                      "0001110" when x"F",
                      "1111111" when others;
end rtl;
