library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity recomb_rom64 is
    port (addr : in unsigned(3 downto 0);
          data : out signed(31 downto 0);
          clk : in std_logic;
          sel : in unsigned(1 downto 0));
end recomb_rom64;


architecture rtl of recomb_rom64 is
    type rom_type is array(0 to 63) of signed(31 downto 0);
    constant rom_data : rom_type := 
        (x"7fff0000", x"7fd70000", x"7f610000", x"7e9c0000", 
         x"7d890000", x"7c290000", x"7a7c0000", x"78830000", 
         x"76400000", x"73b50000", x"70e10000", x"6dc90000", 
         x"6a6c0000", x"66ce0000", x"62f10000", x"5ed60000", 
         x"5a810000", x"55f40000", x"51330000", x"4c3f0000", 
         x"471c0000", x"41cd0000", x"3c560000", x"36b90000", 
         x"30fb0000", x"2b1e0000", x"25270000", x"1f190000", 
         x"18f80000", x"12c70000", x"0c8b0000", x"06470000", 
         x"00000000", x"f9b90000", x"f3750000", x"ed390000", 
         x"e7080000", x"e0e70000", x"dad90000", x"d4e20000", 
         x"cf050000", x"c9470000", x"c3aa0000", x"be330000", 
         x"b8e40000", x"b3c10000", x"aecd0000", x"aa0c0000", 
         x"a57f0000", x"a12a0000", x"9d0f0000", x"99320000", 
         x"95940000", x"92370000", x"8f1f0000", x"8c4b0000", 
         x"89c00000", x"877d0000", x"85840000", x"83d70000", 
         x"82770000", x"81640000", x"809f0000", x"80290000");
    signal fulladdr : unsigned(5 downto 0);
begin
    fulladdr <= sel & addr;
    process (clk)
    begin
        data <= rom_data(to_integer(fulladdr));
    end process;
end rtl;
