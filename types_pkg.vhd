library ieee;
use ieee.numeric_std.all;

package types_pkg is
    type complex_signed_array is array (0 to 7) of signed(31 downto 0);
    type real_signed_array is array(0 to 7) of signed(15 downto 0);
    type byte_array is array(0 to 7) of unsigned(7 downto 0);
    type nibble_array is array(0 to 7) of unsigned(3 downto 0);
    type nibble_double_array is array(0 to 15) of unsigned(3 downto 0);
    type complex_signed_double_array is array (0 to 15) of signed(31 downto 0);
    type nibble_half_array is array(0 to 3) of signed(3 downto 0);
    type complex_signed_half_array is array(0 to 3) of signed(31 downto 0);
end package;
