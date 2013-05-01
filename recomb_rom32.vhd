library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity recomb_rom32 is
    port (addr : in unsigned(3 downto 0);
          data : out signed(31 downto 0);
          sel : in std_logic);
end recomb_rom32;

architecture rtl of recomb_rom32 is
    type rom_type is array(0 to 31) of signed(31 downto 0);
    constant rom_data : rom_type := 
        (x"7fff0000", x"7f610000", x"7d890000", x"7a7c0000", 
         x"76400000", x"70e10000", x"6a6c0000", x"62f10000", 
         x"5a810000", x"51330000", x"471c0000", x"3c560000", 
         x"30fb0000", x"25270000", x"18f80000", x"0c8b0000", 
         x"00000000", x"f3750000", x"e7080000", x"dad90000", 
         x"cf050000", x"c3aa0000", x"b8e40000", x"aecd0000", 
         x"a57f0000", x"9d0f0000", x"95940000", x"8f1f0000", 
         x"89c00000", x"85840000", x"82770000", x"809f0000");
    signal fulladdr : unsigned(4 downto 0);
begin
    fulladdr <= sel & addr;
    data <= rom_data(to_integer(fulladdr));
end rtl;
