library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity recomb_test_memory is
    port (clk : in std_logic;
          tb_addr : in unsigned(3 downto 0);
          tb_lowdata : out signed(31 downto 0);
          tb_highdata : out signed(31 downto 0);
          rom_addr : in unsigned(3 downto 0);
          rom_data : out signed(31 downto 0);
          low_readaddr : in unsigned(3 downto 0);
          low_writeaddr : in unsigned(3 downto 0);
          low_readdata : out signed(31 downto 0);
          low_writedata : in signed(31 downto 0);
          low_write_en : in std_logic;
          high_readaddr : in unsigned(3 downto 0);
          high_writeaddr : in unsigned(3 downto 0);
          high_readdata : out signed(31 downto 0);
          high_writedata : in signed(31 downto 0);
          high_write_en : in std_logic);
end recomb_test_memory;

architecture rtl of recomb_test_memory is
    type mem_type is array(0 to 15) of signed(31 downto 0);
    constant rom_mem : mem_type :=
        (x"7fff0000", x"7d890000", x"76400000", x"6a6c0000", 
         x"5a810000", x"471c0000", x"30fb0000", x"18f80000", 
         x"00000000", x"e7080000", x"cf050000", x"b8e40000", 
         x"a57f0000", x"95940000", x"89c00000", x"82770000");
    signal low_mem : mem_type := 
        (x"63147d3a", x"0c3ac903", x"f39e20aa", x"5fa3080c", 
         x"8c34609a", x"9cf9709f", x"4efb55bf", x"271c2ce4", 
         x"9b959d9b", x"ddfdc775", x"609585d9", x"b5f76fed", 
         x"29fb2867", x"0c38abda", x"08a34c89", x"56df70a1");
    signal high_mem : mem_type := 
        (x"9ac10175", x"d03e0edd", x"425d0d5c", x"ac236b31", 
         x"228caea3", x"52ac3a8c", x"5a8fdf6b", x"2b4e796a", 
         x"d87a7236", x"e1bc27e1", x"c19c3b48", x"4301716c", 
         x"8db55085", x"c590beaa", x"5e2cb01d", x"9641db23");
begin
    rom_data <= rom_mem(to_integer(rom_addr));
    low_readdata <= low_mem(to_integer(low_readaddr));
    high_readdata <= high_mem(to_integer(high_readaddr));
    tb_lowdata <= low_mem(to_integer(tb_addr));
    tb_highdata <= high_mem(to_integer(tb_addr));

    process (clk)
    begin
        if rising_edge(clk) then
            if low_write_en = '1' then
                low_mem(to_integer(low_writeaddr)) <= low_writedata;
            end if;
            if high_write_en = '1' then
                high_mem(to_integer(high_writeaddr)) <= high_writedata;
            end if;
        end if;
    end process;
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity recomb_tb is
end recomb_tb;

architecture sim of recomb_tb is
    signal clk : std_logic := '0';
    signal reset : std_logic;
    signal done : std_logic;
    signal rom_addr : unsigned(3 downto 0);
    signal rom_data : signed(31 downto 0);
    signal low_readaddr : unsigned(3 downto 0);
    signal low_writeaddr : unsigned(3 downto 0);
    signal low_readdata : signed(31 downto 0);
    signal low_writedata : signed(31 downto 0);
    signal low_write_en : std_logic;
    signal high_readaddr : unsigned(3 downto 0);
    signal high_writeaddr : unsigned(3 downto 0);
    signal high_readdata : signed(31 downto 0);
    signal high_writedata : signed(31 downto 0);
    signal high_write_en : std_logic;
    signal tb_addr : unsigned(3 downto 0);
    signal tb_lowdata : signed(31 downto 0);
    signal tb_highdata : signed(31 downto 0);
    type expected_type is array(0 to 31) of signed(31 downto 0);
    constant expected : expected_type := 
        (x"183a3efa", x"fa67e825", x"0922136a", x"1e621a4d", 
         x"cc3521eb", x"d9f74070", x"302627c1", x"15aa1c5d", 
         x"cdcacecd", x"f077e1c8", x"3641bd40", x"d1ac2835", 
         x"293005f7", x"1241e381", x"ee9138b7", x"455c4159", 
         x"4ada3e40", x"11d3e0dd", x"ea7c0d40", x"4140edbf", 
         x"bfff3eaf", x"c301302e", x"1ed42dfd", x"11721087", 
         x"cdcacecd", x"ed85e5ac", x"2a53c898", x"e44a47b7", 
         x"00ca226f", x"f9f7c859", x"1a1113d1", x"11822f47");
begin
    RCMEM : entity work.recomb_test_memory port map (
        clk => clk,
        rom_addr => rom_addr,
        rom_data => rom_data,
        low_readaddr => low_readaddr,
        low_readdata => low_readdata,
        low_writeaddr => low_writeaddr,
        low_writedata => low_writedata,
        low_write_en => low_write_en,
        high_readaddr => high_readaddr,
        high_readdata => high_readdata,
        high_writeaddr => high_writeaddr,
        high_writedata => high_writedata,
        high_write_en => high_write_en,
        tb_addr => tb_addr,
        tb_lowdata => tb_lowdata,
        tb_highdata => tb_highdata
    );

    RC : entity work.fft_recomb port map (
        clk => clk,
        reset => reset,
        done => done,
        rom_addr => rom_addr,
        rom_data => rom_data,
        low_readaddr => low_readaddr,
        low_readdata => low_readdata,
        low_writeaddr => low_writeaddr,
        low_writedata => low_writedata,
        low_write_en => low_write_en,
        high_readaddr => high_readaddr,
        high_readdata => high_readdata,
        high_writeaddr => high_writeaddr,
        high_writedata => high_writedata,
        high_write_en => high_write_en
    );

    clk <= not clk after 10 ns;

    process
        variable i : integer range 0 to 32;
    begin
        tb_addr <= x"0";
        wait for 10 ns;
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 80 ns;
        while done = '0' loop
            wait for 20 ns;
        end loop;

        i := 0;
        while i < 16 loop
            tb_addr <= to_unsigned(i, 4);
            wait for 20 ns;
            assert tb_lowdata = expected(i);
            assert tb_highdata = expected(i + 16);
            i := i + 1;
        end loop;
        wait;
    end process;
end sim;
