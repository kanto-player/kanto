library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity dft_coeff_rom is
    port (data : out complex_signed_array;
          addr: in byte_array);
end dft_coeff_rom;

architecture rtl of dft_coeff_rom is
    type rom_type is array(0 to 255) of signed(31 downto 0);
    constant rom_data : rom_type := (x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"764030fb", x"5a815a81", x"30fb7640", x"00007fff", x"cf057640", x"a57f5a81", x"89c030fb", x"80010000", x"89c0cf05", x"a57fa57f", x"cf0589c0", x"00008001", x"30fb89c0", x"5a81a57f", x"7640cf05", x"7fff0000", x"5a815a81", x"00007fff", x"a57f5a81", x"80010000", x"a57fa57f", x"00008001", x"5a81a57f", x"7fff0000", x"5a815a81", x"00007fff", x"a57f5a81", x"80010000", x"a57fa57f", x"00008001", x"5a81a57f", x"7fff0000", x"30fb7640", x"a57f5a81", x"89c0cf05", x"00008001", x"7640cf05", x"5a815a81", x"cf057640", x"80010000", x"cf0589c0", x"5a81a57f", x"764030fb", x"00007fff", x"89c030fb", x"a57fa57f", x"30fb89c0", x"7fff0000", x"00007fff", x"80010000", x"00008001", x"7fff0000", x"00007fff", x"80010000", x"00008001", x"7fff0000", x"00007fff", x"80010000", x"00008001", x"7fff0000", x"00007fff", x"80010000", x"00008001", x"7fff0000", x"cf057640", x"a57fa57f", x"7640cf05", x"00007fff", x"89c0cf05", x"5a81a57f", x"30fb7640", x"80010000", x"30fb89c0", x"5a815a81", x"89c030fb", x"00008001", x"764030fb", x"a57f5a81", x"cf0589c0", x"7fff0000", x"a57f5a81", x"00008001", x"5a815a81", x"80010000", x"5a81a57f", x"00007fff", x"a57fa57f", x"7fff0000", x"a57f5a81", x"00008001", x"5a815a81", x"80010000", x"5a81a57f", x"00007fff", x"a57fa57f", x"7fff0000", x"89c030fb", x"5a81a57f", x"cf057640", x"00008001", x"30fb7640", x"a57fa57f", x"764030fb", x"80010000", x"7640cf05", x"a57f5a81", x"30fb89c0", x"00007fff", x"cf0589c0", x"5a815a81", x"89c0cf05", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"89c0cf05", x"5a815a81", x"cf0589c0", x"00007fff", x"30fb89c0", x"a57f5a81", x"7640cf05", x"80010000", x"764030fb", x"a57fa57f", x"30fb7640", x"00008001", x"cf057640", x"5a81a57f", x"89c030fb", x"7fff0000", x"a57fa57f", x"00007fff", x"5a81a57f", x"80010000", x"5a815a81", x"00008001", x"a57f5a81", x"7fff0000", x"a57fa57f", x"00007fff", x"5a81a57f", x"80010000", x"5a815a81", x"00008001", x"a57f5a81", x"7fff0000", x"cf0589c0", x"a57f5a81", x"764030fb", x"00008001", x"89c030fb", x"5a815a81", x"30fb89c0", x"80010000", x"30fb7640", x"5a81a57f", x"89c0cf05", x"00007fff", x"7640cf05", x"a57fa57f", x"cf057640", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"30fb89c0", x"a57fa57f", x"89c030fb", x"00007fff", x"764030fb", x"5a81a57f", x"cf0589c0", x"80010000", x"cf057640", x"5a815a81", x"7640cf05", x"00008001", x"89c0cf05", x"a57f5a81", x"30fb7640", x"7fff0000", x"5a81a57f", x"00008001", x"a57fa57f", x"80010000", x"a57f5a81", x"00007fff", x"5a815a81", x"7fff0000", x"5a81a57f", x"00008001", x"a57fa57f", x"80010000", x"a57f5a81", x"00007fff", x"5a815a81", x"7fff0000", x"7640cf05", x"5a81a57f", x"30fb89c0", x"00008001", x"cf0589c0", x"a57fa57f", x"89c0cf05", x"80010000", x"89c030fb", x"a57f5a81", x"cf057640", x"00007fff", x"30fb7640", x"5a815a81", x"764030fb");
begin
    LUMAP : for i in 0 to 15 generate
        data(i) <= rom_data(to_integer(addr(i)));
    end generate LUMAP;
end rtl;
