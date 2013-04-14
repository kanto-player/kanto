library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity recomb_rom16 is
    port (addr : in nibble_half_array;
          data : out complex_signed_half_array);
end recomb_rom16;

architecture rtl of recomb_rom16 is
    type rom_type is array(0 to 15) of signed(31 downto 0);
    constant rom_data : rom_type := 
        (x"7fff0000", x"7d890000", x"76400000", x"6a6c0000", 
         x"5a810000", x"471c0000", x"30fb0000", x"18f80000", 
         x"00000000", x"e7080000", x"cf050000", x"b8e40000", 
         x"a57f0000", x"95940000", x"89c00000", x"82770000");
begin
    READGEN : for i in 0 to 7 generate
        data(i) <= rom_data(to_integer(addr(i)));
    end generate READGEN;
end rtl;
