library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity dft_rom is
    port (data : out complex_signed_array;
          addr: in byte_array);
end dft_rom;

architecture rtl of dft_rom is
    type rom_type is array(0 to 255) of signed(35 downto 0);
    constant rom_data : rom_type;
begin
    LUMAP : for i in 0 to 15 generate
        data(i) <= rom_data(to_integer(addr(i)));
    end generate LUMAP;
end rtl;
