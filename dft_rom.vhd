library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dft_rom is
    port (data1  : out signed(35 downto 0);
          addr1  : in unsigned(7 downto 0);
          data2  : out signed(35 downto 0);
          addr2  : in unsigned(7 downto 0);
          data3  : out signed(35 downto 0);
          addr3  : in unsigned(7 downto 0);
          data4  : out signed(35 downto 0);
          addr4  : in unsigned(7 downto 0);
          data5  : out signed(35 downto 0);
          addr5  : in unsigned(7 downto 0);
          data6  : out signed(35 downto 0);
          addr6  : in unsigned(7 downto 0);
          data7  : out signed(35 downto 0);
          addr7  : in unsigned(7 downto 0);
          data8  : out signed(35 downto 0);
          addr8  : in unsigned(7 downto 0);
          data9  : out signed(35 downto 0);
          addr9  : in unsigned(7 downto 0);
          data10 : out signed(35 downto 0);
          addr10 : in unsigned(7 downto 0);
          data11 : out signed(35 downto 0);
          addr11 : in unsigned(7 downto 0);
          data12 : out signed(35 downto 0);
          addr12 : in unsigned(7 downto 0);
          data13 : out signed(35 downto 0);
          addr13 : in unsigned(7 downto 0);
          data14 : out signed(35 downto 0);
          addr14 : in unsigned(7 downto 0);
          data15 : out signed(35 downto 0);
          addr15 : in unsigned(7 downto 0));
end dft_rom;

architecture rtl of dft_rom is
    type rom_type is array(0 to 255) of signed(35 downto 0);
    constant rom_data : rom_type;
begin
    data1  <= rom_data(to_integer(addr1));
    data2  <= rom_data(to_integer(addr2));
    data3  <= rom_data(to_integer(addr3));
    data4  <= rom_data(to_integer(addr4));
    data5  <= rom_data(to_integer(addr5));
    data6  <= rom_data(to_integer(addr6));
    data7  <= rom_data(to_integer(addr7));
    data8  <= rom_data(to_integer(addr8));
    data9  <= rom_data(to_integer(addr9));
    data10 <= rom_data(to_integer(addr10));
    data11 <= rom_data(to_integer(addr11));
    data12 <= rom_data(to_integer(addr12));
    data13 <= rom_data(to_integer(addr13));
    data14 <= rom_data(to_integer(addr14));
    data15 <= rom_data(to_integer(addr15));
end rtl;
