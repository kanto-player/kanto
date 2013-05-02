library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity recomb_rom128 is
    port (addr : in unsigned(3 downto 0);
          data : out signed(31 downto 0);
          clk : in std_logic;
          sel : in unsigned(2 downto 0));
end recomb_rom128;

architecture rtl of recomb_rom128 is
    type rom_type is array(0 to 127) of signed(31 downto 0);
    constant rom_data : rom_type :=
        (x"7fff0000", x"7ff50000", x"7fd70000", x"7fa60000", 
         x"7f610000", x"7f080000", x"7e9c0000", x"7e1c0000", 
         x"7d890000", x"7ce20000", x"7c290000", x"7b5c0000", 
         x"7a7c0000", x"79890000", x"78830000", x"776b0000", 
         x"76400000", x"75030000", x"73b50000", x"72540000", 
         x"70e10000", x"6f5e0000", x"6dc90000", x"6c230000", 
         x"6a6c0000", x"68a50000", x"66ce0000", x"64e70000", 
         x"62f10000", x"60eb0000", x"5ed60000", x"5cb30000", 
         x"5a810000", x"58420000", x"55f40000", x"539a0000", 
         x"51330000", x"4ebf0000", x"4c3f0000", x"49b30000", 
         x"471c0000", x"447a0000", x"41cd0000", x"3f160000", 
         x"3c560000", x"398c0000", x"36b90000", x"33de0000", 
         x"30fb0000", x"2e100000", x"2b1e0000", x"28260000", 
         x"25270000", x"22230000", x"1f190000", x"1c0b0000", 
         x"18f80000", x"15e10000", x"12c70000", x"0fab0000", 
         x"0c8b0000", x"096a0000", x"06470000", x"03240000", 
         x"00000000", x"fcdc0000", x"f9b90000", x"f6960000", 
         x"f3750000", x"f0550000", x"ed390000", x"ea1f0000", 
         x"e7080000", x"e3f50000", x"e0e70000", x"dddd0000", 
         x"dad90000", x"d7da0000", x"d4e20000", x"d1f00000", 
         x"cf050000", x"cc220000", x"c9470000", x"c6740000", 
         x"c3aa0000", x"c0ea0000", x"be330000", x"bb860000", 
         x"b8e40000", x"b64d0000", x"b3c10000", x"b1410000", 
         x"aecd0000", x"ac660000", x"aa0c0000", x"a7be0000", 
         x"a57f0000", x"a34d0000", x"a12a0000", x"9f150000", 
         x"9d0f0000", x"9b190000", x"99320000", x"975b0000", 
         x"95940000", x"93dd0000", x"92370000", x"90a20000", 
         x"8f1f0000", x"8dac0000", x"8c4b0000", x"8afd0000", 
         x"89c00000", x"88950000", x"877d0000", x"86770000", 
         x"85840000", x"84a40000", x"83d70000", x"831e0000", 
         x"82770000", x"81e40000", x"81640000", x"80f80000", 
         x"809f0000", x"805a0000", x"80290000", x"800b0000");
    signal fulladdr : unsigned(6 downto 0);
begin
    fulladdr <= sel & addr;
    process (clk)
    begin
        if rising_edge(clk) then
            data <= rom_data(to_integer(fulladdr));
        end if;
    end process;
end rtl;
