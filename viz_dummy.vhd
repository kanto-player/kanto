library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity viz_dummy is
    port (      
        clk50 : in std_logic;
        viz_reset: out std_logic;
        fft_fdom_addr : in unsigned(7 downto 0);
        fft_fdom_data : out signed(31 downto 0)
    );
end viz_dummy;

architecture rtl of viz_dummy is
    signal counter : integer := 0;
    signal rom1 : std_logic := '1';
    type rom_type is array(0 to 35) of signed(31 downto 0);
    type rom_type2 is array(0 to 255) of signed(31 downto 0);
    constant rom_data1 : rom_type := (x"f0000017", x"00000005", x"f000002a", x"00000004", x"f0000233", x"000dd0d6", x"f0000001", x"00e0c005", x"000ff006", x"0ed00007", x"0f000083", x"10000014", x"0000002b", x"ffffffc3", x"00000017", x"ffffffbd", x"0000005b", x"0d000016", x"00000017", x"000e0005", x"f000002a", x"00000004", x"0d000233", x"0f0000d6", x"e0000001", x"00000005", x"0f000006", x"0e000007", x"00000083", x"10000014", x"0000002b", x"ffffffc3", x"00000017", x"ffffffbd", x"0000005b", x"00000016");
    constant rom_data2 : rom_type2 := (x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"764030fb", x"5a815a81", x"30fb7640", x"00007fff", x"cf057640", x"a57f5a81", x"89c030fb", x"80010000", x"89c0cf05", x"a57fa57f", x"cf0589c0", x"00008001", x"30fb89c0", x"5a81a57f", x"7640cf05", x"7fff0000", x"5a815a81", x"00007fff", x"a57f5a81", x"80010000", x"a57fa57f", x"00008001", x"5a81a57f", x"7fff0000", x"5a815a81", x"00007fff", x"a57f5a81", x"80010000", x"a57fa57f", x"00008001", x"5a81a57f", x"7fff0000", x"30fb7640", x"a57f5a81", x"89c0cf05", x"00008001", x"7640cf05", x"5a815a81", x"cf057640", x"80010000", x"cf0589c0", x"5a81a57f", x"764030fb", x"00007fff", x"89c030fb", x"a57fa57f", x"30fb89c0", x"7fff0000", x"00007fff", x"80010000", x"00008001", x"7fff0000", x"00007fff", x"80010000", x"00008001", x"7fff0000", x"00007fff", x"80010000", x"00008001", x"7fff0000", x"00007fff", x"80010000", x"00008001", x"7fff0000", x"cf057640", x"a57fa57f", x"7640cf05", x"00007fff", x"89c0cf05", x"5a81a57f", x"30fb7640", x"80010000", x"30fb89c0", x"5a815a81", x"89c030fb", x"00008001", x"764030fb", x"a57f5a81", x"cf0589c0", x"7fff0000", x"a57f5a81", x"00008001", x"5a815a81", x"80010000", x"5a81a57f", x"00007fff", x"a57fa57f", x"7fff0000", x"a57f5a81", x"00008001", x"5a815a81", x"80010000", x"5a81a57f", x"00007fff", x"a57fa57f", x"7fff0000", x"89c030fb", x"5a81a57f", x"cf057640", x"00008001", x"30fb7640", x"a57fa57f", x"764030fb", x"80010000", x"7640cf05", x"a57f5a81", x"30fb89c0", x"00007fff", x"cf0589c0", x"5a815a81", x"89c0cf05", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"89c0cf05", x"5a815a81", x"cf0589c0", x"00007fff", x"30fb89c0", x"a57f5a81", x"7640cf05", x"80010000", x"764030fb", x"a57fa57f", x"30fb7640", x"00008001", x"cf057640", x"5a81a57f", x"89c030fb", x"7fff0000", x"a57fa57f", x"00007fff", x"5a81a57f", x"80010000", x"5a815a81", x"00008001", x"a57f5a81", x"7fff0000", x"a57fa57f", x"00007fff", x"5a81a57f", x"80010000", x"5a815a81", x"00008001", x"a57f5a81", x"7fff0000", x"cf0589c0", x"a57f5a81", x"764030fb", x"00008001", x"89c030fb", x"5a815a81", x"30fb89c0", x"80010000", x"30fb7640", x"5a81a57f", x"89c0cf05", x"00007fff", x"7640cf05", x"a57fa57f", x"cf057640", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"30fb89c0", x"a57fa57f", x"89c030fb", x"00007fff", x"764030fb", x"5a81a57f", x"cf0589c0", x"80010000", x"cf057640", x"5a815a81", x"7640cf05", x"00008001", x"89c0cf05", x"a57f5a81", x"30fb7640", x"7fff0000", x"5a81a57f", x"00008001", x"a57fa57f", x"80010000", x"a57f5a81", x"00007fff", x"5a815a81", x"7fff0000", x"5a81a57f", x"00008001", x"a57fa57f", x"80010000", x"a57f5a81", x"00007fff", x"5a815a81", x"7fff0000", x"7640cf05", x"5a81a57f", x"30fb89c0", x"00008001", x"cf0589c0", x"a57fa57f", x"89c0cf05", x"80010000", x"89c030fb", x"a57f5a81", x"cf057640", x"00007fff", x"30fb7640", x"5a815a81", x"764030fb");
begin
    
    ResetData : process (clk50)
    begin
        if rising_edge(clk50) then
            counter <= counter + 1;
            if counter = 250000000 then
                viz_reset <= '1';
                rom1 <= not rom1;
                counter <= 0;
            else viz_reset <= '0';
            end if;
        end if;
    end process ResetData;
    
    GetData : process (clk50)
    begin
        if rising_edge(clk50) then
            if rom1 = '1' then
                fft_fdom_data <= rom_data1(to_integer(fft_fdom_addr));
            else
                fft_fdom_data <= rom_data2(to_integer(fft_fdom_addr));
            end if;
        end if;
    end process GetData;

    
end rtl;
