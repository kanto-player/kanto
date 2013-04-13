library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dft_test_coeff_rom is
    port (data : out signed(31 downto 0);
          addr : in unsigned(7 downto 0));
end dft_test_coeff_rom;

architecture rtl of dft_test_coeff_rom is
    type rom_type is array(0 to 255) of signed(31 downto 0);
    constant rom_data : rom_type := (x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"7fff0000", x"764030fb", x"5a815a81", x"30fb7640", x"00007fff", x"cf057640", x"a57f5a81", x"89c030fb", x"80010000", x"89c0cf05", x"a57fa57f", x"cf0589c0", x"00008001", x"30fb89c0", x"5a81a57f", x"7640cf05", x"7fff0000", x"5a815a81", x"00007fff", x"a57f5a81", x"80010000", x"a57fa57f", x"00008001", x"5a81a57f", x"7fff0000", x"5a815a81", x"00007fff", x"a57f5a81", x"80010000", x"a57fa57f", x"00008001", x"5a81a57f", x"7fff0000", x"30fb7640", x"a57f5a81", x"89c0cf05", x"00008001", x"7640cf05", x"5a815a81", x"cf057640", x"80010000", x"cf0589c0", x"5a81a57f", x"764030fb", x"00007fff", x"89c030fb", x"a57fa57f", x"30fb89c0", x"7fff0000", x"00007fff", x"80010000", x"00008001", x"7fff0000", x"00007fff", x"80010000", x"00008001", x"7fff0000", x"00007fff", x"80010000", x"00008001", x"7fff0000", x"00007fff", x"80010000", x"00008001", x"7fff0000", x"cf057640", x"a57fa57f", x"7640cf05", x"00007fff", x"89c0cf05", x"5a81a57f", x"30fb7640", x"80010000", x"30fb89c0", x"5a815a81", x"89c030fb", x"00008001", x"764030fb", x"a57f5a81", x"cf0589c0", x"7fff0000", x"a57f5a81", x"00008001", x"5a815a81", x"80010000", x"5a81a57f", x"00007fff", x"a57fa57f", x"7fff0000", x"a57f5a81", x"00008001", x"5a815a81", x"80010000", x"5a81a57f", x"00007fff", x"a57fa57f", x"7fff0000", x"89c030fb", x"5a81a57f", x"cf057640", x"00008001", x"30fb7640", x"a57fa57f", x"764030fb", x"80010000", x"7640cf05", x"a57f5a81", x"30fb89c0", x"00007fff", x"cf0589c0", x"5a815a81", x"89c0cf05", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"80010000", x"7fff0000", x"89c0cf05", x"5a815a81", x"cf0589c0", x"00007fff", x"30fb89c0", x"a57f5a81", x"7640cf05", x"80010000", x"764030fb", x"a57fa57f", x"30fb7640", x"00008001", x"cf057640", x"5a81a57f", x"89c030fb", x"7fff0000", x"a57fa57f", x"00007fff", x"5a81a57f", x"80010000", x"5a815a81", x"00008001", x"a57f5a81", x"7fff0000", x"a57fa57f", x"00007fff", x"5a81a57f", x"80010000", x"5a815a81", x"00008001", x"a57f5a81", x"7fff0000", x"cf0589c0", x"a57f5a81", x"764030fb", x"00008001", x"89c030fb", x"5a815a81", x"30fb89c0", x"80010000", x"30fb7640", x"5a81a57f", x"89c0cf05", x"00007fff", x"7640cf05", x"a57fa57f", x"cf057640", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"00008001", x"80010000", x"00007fff", x"7fff0000", x"30fb89c0", x"a57fa57f", x"89c030fb", x"00007fff", x"764030fb", x"5a81a57f", x"cf0589c0", x"80010000", x"cf057640", x"5a815a81", x"7640cf05", x"00008001", x"89c0cf05", x"a57f5a81", x"30fb7640", x"7fff0000", x"5a81a57f", x"00008001", x"a57fa57f", x"80010000", x"a57f5a81", x"00007fff", x"5a815a81", x"7fff0000", x"5a81a57f", x"00008001", x"a57fa57f", x"80010000", x"a57f5a81", x"00007fff", x"5a815a81", x"7fff0000", x"7640cf05", x"5a81a57f", x"30fb89c0", x"00008001", x"cf0589c0", x"a57fa57f", x"89c0cf05", x"80010000", x"89c030fb", x"a57f5a81", x"cf057640", x"00007fff", x"30fb7640", x"5a815a81", x"764030fb");
begin
    data <= rom_data(to_integer(addr));
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dft_test_tdom_rom is
    port (data : out signed(15 downto 0);
          addr : in unsigned(7 downto 0));
end dft_test_tdom_rom;

architecture rtl of dft_test_tdom_rom is
    type rom_type is array(0 to 15) of signed(15 downto 0);
    constant rom_data : rom_type := (x"7fff", x"12a0", x"856d", x"c9b4", 
                                     x"6ac5", x"555f", x"ae14", x"92c9", 
                                     x"3223", x"7bcf", x"f1e6", x"8016", 
                                     x"e8e1", x"792f", x"3a64", x"97d0");
begin
    data <= rom_data(to_integer(addr(7 downto 4)));
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dft_test_fdom_ram is
    port (write_data : in signed(31 downto 0);
          write_addr : in unsigned(3 downto 0);
          write_en : in std_logic;
          read_data : out signed(31 downto 0);
          read_addr : in unsigned(3 downto 0);
          clk : in std_logic);
end dft_test_fdom_ram;

architecture rtl of dft_test_fdom_ram is
    type ram_type is array(0 to 15) of signed(31 downto 0);
    signal ram_data : ram_type;
begin
    process (clk)
    begin
        if rising_edge(clk) and write_en = '1' then
            ram_data(to_integer(write_addr)) <= write_data;
        end if;
    end process;
    read_data <= ram_data(to_integer(read_addr));
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dft_test_setup is
    port (clk : in std_logic;
          reset : in std_logic;
          done : out std_logic;
          tdom_addr_debug : out unsigned(7 downto 0);
          fdom_addr_debug : out unsigned(3 downto 0);
          rom_addr_debug : out unsigned(7 downto 0);
          tdom_data_debug : out signed(15 downto 0);
          rom_data_debug : out signed(31 downto 0);
          s1_write_debug : out std_logic;
          s2_write_debug : out std_logic;
          fdom_write_debug : out std_logic;
          sum_debug : out signed(63 downto 0);
          mult_debug : out signed(63 downto 0);
          read_addr : in unsigned(3 downto 0);
          read_data : out signed(31 downto 0));
end dft_test_setup;

architecture rtl of dft_test_setup is
    signal tdom_data : signed(15 downto 0);
    signal tdom_addr : unsigned(7 downto 0);
    signal rom_data : signed(31 downto 0);
    signal rom_addr : unsigned(7 downto 0);
    signal fdom_data : signed(31 downto 0);
    signal fdom_addr : unsigned(3 downto 0);
    signal fdom_write : std_logic;
begin
    tdom_addr_debug <= tdom_addr;
    fdom_addr_debug <= fdom_addr;
    fdom_write_debug <= fdom_write;
    rom_addr_debug <= rom_addr;
    rom_data_debug <= rom_data;
    tdom_data_debug <= tdom_data;

    DFT : entity work.dft_top port map (
        tdom_data => tdom_data,
        tdom_addr => tdom_addr,
        tdom_offset => x"0",

        clk => clk,
        reset => reset,
        done => done,
        s1_write_debug => s1_write_debug,
        s2_write_debug => s2_write_debug,
        sum_debug => sum_debug,
        mult_debug => mult_debug,

        rom_data => rom_data,
        rom_addr => rom_addr,

        fdom_data => fdom_data,
        fdom_addr => fdom_addr,
        fdom_write => fdom_write
    );

    COEFF : entity work.dft_test_coeff_rom port map (
        addr => rom_addr,
        data => rom_data
    );

    TDOM : entity work.dft_test_tdom_rom port map (
        addr => tdom_addr,
        data => tdom_data
    );

    FDOM : entity work.dft_test_fdom_ram port map (
        read_addr => read_addr,
        read_data => read_data,
        write_addr => fdom_addr,
        write_data => fdom_data,
        write_en => fdom_write,
        clk => clk
    );
end rtl;
