library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity viz_test_rom is
    port (    
        clk50           : in std_logic;
        reset_data_test : out std_logic;
        fft_fdom_addr   : in unsigned(7 downto 0);
        fft_fdom_data   : out signed(31 downto 0)
);
end viz_test_rom;

architecture rtl of viz_test_rom is
    type rom_type is array(0 to 255) of signed(31 downto 0);
    signal reset_counter : integer := 0;
    signal swap_roms : std_logic := '0';
    constant rom_data2 : rom_type := (x"ffff0f00", x"7fff00f0", x"7ffff000", x"ffff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff00f0", x"7fff0f00", x"7fff00f0", x"7fff0000", x"7fff0000", x"ffff00f0", x"7fff0000", x"764030fb", x"5a815a81", x"30fb7640", x"00007fff", x"cf057640", x"a57f5a81", x"89c030fb", x"80010000", x"89c0cfc5", x"ac7fafff", x"cf0ff9cc", x"0ff08001", x"c0fb89c0", x"5ac1c57f", x"7640cf05", x"7fff00ff", x"5a8fca81", x"0fc07fff", x"a5ff5a81", x"80010fcf", x"a57fa57f", x"ff008001", x"5a81a00f", x"000f0000", x"5a8ffa81", x"00007fff", x"a5f0fa81", x"80010000", x"a57fa57f", x"0ff08001", x"5a81a57f", x"7fdf0000", x"3fdc7640",x"a5230a81", x"0933ff05", x"ff008001", x"70c0c005", x"5aff0a81", x"34f57640", x"8001ffff", x"c03f89c0", x"00000000", x"ff0030fb", x"ff00730f", x"ff02f0fb", x"0d3fa57f", x"f3fd8920", x"000f0000", x"32f07fff", x"fff10000", x"00fff001", x"00003245", x"0fff7fff", x"fff10000", x"ddf08001", x"ffff0000", x"ff007fff", x"00010ff0", x"f0008001", x"700f0000", x"ff007fff", x"80dc0000", x"00008001", x"00ffff00", x"de057640", x"037f000f", x"39407645", x"ff007fff", x"f3c0cf05", x"5d80a57f", x"d24b7640", x"8f017640", x"300649c0", x"76415a81", x"ffc030fb", x"ff008001", x"004030fb", x"f57f7641", x"af764764", x"00f76400", x"30645a81", x"f0008001", x"0a815a81", x"10010000", x"3a81a57f", x"0000ffff", x"a35fa57f", x"7fff0000", x"a57f5a81", x"00008001", x"0a815a81", x"10010000", x"3a81a57f", x"00007fff", x"a57fa57f", x"7fff0000", x"89c0764b", x"5a81a57f", x"cf057640", x"00008001", x"30fb7640", x"a57fa57f", x"764030fb", x"80010000", x"7640cf05", x"a57f5a81", x"30fb89c0", x"00007fff", x"cf0589c0", x"5a815a81", x"89c0cf05", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"0a815a81", x"10010000", x"3a81a57f", x"0a815a81", x"10010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"5a815a81", x"cf0589c0", x"00007fff", x"30fb89c0", x"a57f5a81", x"7640cf05", x"80010000", x"764030fb", x"a57fa57f", x"30fb7640", x"00008001", x"cf057640", x"5a81a57f", x"89c030fb", x"7fff0000", x"a57fa57f", x"00007fff", x"5a81a57f", x"80010000", x"5a815a81", x"00008001", x"a57f5a81", x"7fff0000", x"a57fa57f", x"00007fff", x"5a81a57f", x"80010000", x"5a815a81", x"00008001", x"a57f5a81", x"7fff0000", x"cf0589c0", x"a57f5a81", x"764030fb", x"00008001", x"89c030fb", x"5a815a81", x"30fb89c0", x"80010000", x"30fb7640", x"5a81a57f", x"89c0cf05", x"00007fff", x"7640cf05", x"a57fa57f", x"cf057640", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"30fb89c0", x"a57fa57f", x"89c030fb", x"00007fff", x"764030fb", x"5a81a57f", x"cf0589c0", x"80010000", x"cf057640", x"5a815a81", x"7640cf05", x"00008001", x"89c0cf05", x"a57f5a81", x"30fb7640", x"7fff0000", x"5a81a57f", x"00008001", x"a57fa57f", x"ff010000", x"ff7f5a81", x"00007fff", x"5a815a81", x"7fff0000", x"5a81a57f", x"00008001", x"a57fa57f", x"80010000", x"a57f5a81", x"00007fff", x"5a815a81", x"7fff0000", x"7640cf05", x"3481a57f", x"fcfb89c0", x"ff008001", x"cff389c0", x"a57fa57f", x"89c03205", x"80010000", x"89c030fb", x"a57f5a81", x"cf057640", x"ffffffff", x"00000000", x"5a815a81", x"764030fb");
    constant rom_data : rom_type := (x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"764030fb", x"5a815a81", x"30fb7640", x"00007fff", x"cf057640", x"a57f5a81", x"89c030fb", x"80010000", x"89c0cf05", x"a57fa57f", x"cf0589c0", x"00008001", x"30fb89c0", x"5a81a57f", x"7640cf05", x"7fff0000", x"5a815a81", x"00007fff", x"a57f5a81", x"80010000", x"a57fa57f", x"00008001", x"5a81a57f", x"7fff0000", x"5a815a81", x"00007fff", x"a57f5a81", x"80010000", x"a57fa57f", x"00008001", x"5a81a57f", x"7fff0000", x"30fb7640", x"a57f5a81", x"89c0cf05", x"00008001", x"7640cf05", x"5a815a81", x"cf057640", x"80010000", x"cf0589c0", x"5a81a57f", x"764030fb", x"00007fff", x"89c030fb", x"a57fa57f", x"30fb89c0", x"7fff0000", x"00007fff", x"80010000", x"00008001", x"7fff0000", x"00007fff", x"80010000", x"00008001", x"70cf0000", x"00007fff", x"80010000", x"00008001", x"7fff0000", x"00007fff", x"80010000", x"fff08001", x"7fff0000", x"cf057640", x"a57fa57f", x"f640cf05", x"00007f00", x"89c0cf05", x"5a81a57f", x"30fb7640", x"80010000", x"30fb89c0", x"5a815a81", x"890030fb", x"00008001", x"764030fb", x"a57f5a81", x"cf0589c0", x"7fff0000", x"a57f5a81", x"00008001", x"5a815a81", x"80010000", x"5a81a57f", x"00007fff", x"a57fa57f", x"7fff0000", x"a57f5a81", x"00008001", x"5a815a81", x"80010000", x"5a81a57f", x"00007fff", x"a57fa57f", x"7fff0000", x"89c030fb", x"5a81a57f", x"cf057640", x"00008001", x"30fb7640", x"a57fa57f", x"764030fb", x"80010000", x"7640cf05", x"a57f5a81", x"30fb89c0", x"00007fff", x"cf0589c0", x"5a815a81", x"89c0cf05", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"89c0cf05", x"5a815a81", x"cf0589c0", x"00007fff", x"30fb89c0", x"a57f5a81", x"7640cf05", x"80010000", x"764030fb", x"a57fa57f", x"30fb7640", x"00008001", x"cf057640", x"5a81a57f", x"89c030fb", x"7fff0000", x"a57fa57f", x"00007fff", x"5a81a57f", x"80010000", x"5a815a81", x"00008001", x"a57f5a81", x"7fff0000", x"a57fa57f", x"00007fff", x"5a81a57f", x"80010000", x"5a815a81", x"00008001", x"a57f5a81", x"7fff0000", x"cf0589c0", x"a57f5a81", x"764030fb", x"00008001", x"89c030fb", x"5a815a81", x"30fb89c0", x"80010000", x"30fb7640", x"5a81a57f", x"89c0cf05", x"00007fff", x"7640cf05", x"a57fa57f", x"cf057640", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"30fb89c0", x"a57fa57f", x"89c030fb", x"00007fff", x"764030fb", x"5a81a57f", x"cf0589c0", x"80010000", x"cf057640", x"5a815a81", x"7640cf05", x"00008001", x"89c0cf05", x"a57f5a81", x"30fb7640", x"7fff0000", x"5a81a57f", x"00008001", x"a57fa57f", x"80010000", x"a57f5a81", x"00007fff", x"5a815a81", x"7fff0000", x"5a81a57f", x"00008001", x"a57fa57f", x"80010000", x"a57f5a81", x"00007fff", x"5a815a81", x"7fff0000", x"7640cf05", x"5a81a57f", x"30fb89c0", x"00008001", x"cf0589c0", x"a57fa57f", x"89c0cf05", x"80010000", x"89c030fb", x"a57f5a81", x"cf057640", x"00007fff", x"30fb7640", x"5a815a81", x"764030fb");
begin

  process (clk50)
  begin
    if rising_edge(clk50) then
    if swap_roms = '0' then
        fft_fdom_data <= rom_data(to_integer(fft_fdom_addr));
    else 
        fft_fdom_data <= rom_data2(to_integer(fft_fdom_addr));
    end if;
        if reset_counter=25000000 then
            reset_data_test <= '1';
            reset_counter <= 0;
            swap_roms <= not swap_roms;
        else 
            reset_data_test <= '0';
            reset_counter<=reset_counter + 1;
        end if;
     end if;
  end process;

end rtl;
