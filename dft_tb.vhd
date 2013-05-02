library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dft_tb is
end dft_tb;

architecture sim of dft_tb is
    signal clk : std_logic := '1';
    signal reset : std_logic;
    signal done : std_logic;
    signal read_addr : unsigned(3 downto 0);
    signal read_data : signed(31 downto 0);
    signal rom_addr : unsigned(7 downto 0);
    signal rom_data : signed(31 downto 0);
    signal tdom_addr : unsigned(3 downto 0);
    signal tdom_data : signed(15 downto 0);
    signal fdom_addr : unsigned(3 downto 0);
    signal fdom_data : signed(31 downto 0);
    signal fdom_write : std_logic;

    type rom_type is array(0 to 15) of signed(15 downto 0);
    constant tdom_rom : rom_type := (x"7fff", x"12a0", x"856d", x"c9b4", 
                                     x"6ac5", x"555f", x"ae14", x"92c9", 
                                     x"3223", x"7bcf", x"f1e6", x"8016", 
                                     x"e8e1", x"792f", x"3a64", x"97d0");
    
    type expected_type is array(0 to 15) of signed(31 downto 0);
    constant expected : expected_type := 
        (x"01b70000", x"018dfe55", x"00d8fbbc", x"fd5ff2cf", 
         x"0d2f1744", x"061605ec", x"050e02ce", x"04b80136", 
         x"04a10000", x"04b8fec9", x"050efd31", x"0616fa13", 
         x"0d2fe8bb", x"fd5f0d30", x"00d80443", x"018d01aa");
begin
    clk <= not clk after 10 ns;

    process (clk)
    begin
        if rising_edge(clk) then
            tdom_data <= tdom_rom(to_integer(tdom_addr));
        end if;
    end process;

    DFT : entity work.dft_top port map (
        clk => clk,
        reset => reset,
        done => done,
        tdom_data => tdom_data,
        tdom_addr => tdom_addr,
        rom_data => rom_data,
        rom_addr => rom_addr,
        fdom_data => fdom_data,
        fdom_addr => fdom_addr,
        fdom_write => fdom_write
    );

    COEFF_ROM : entity work.dft_coeff_rom port map (
        clk => clk,
        data_low => rom_data,
        addr_low => rom_addr,
        addr_high => (others => '0')
    );

    FDOM_RAM : entity work.fft_fdom_ram port map (
        clk => clk,
        reset => reset,
        
        writedata_low => fdom_data,
        writeaddr_low => fdom_addr,
        write_en_low => fdom_write,
        readaddr_low => read_addr,
        readdata_low => read_data,
        
        writedata_high => (others => '0'),
        writeaddr_high => (others => '0'),
        write_en_high => '0',
        readaddr_high => (others => '0'),

        stage => "00",
        step => "000"
    );

    process
        variable i : integer range 0 to 16;
    begin
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        read_addr <= x"0";
        wait for 5200 ns; -- 5220 ns
        assert done = '1';
        
        i := 0;
        while i < 16 loop
            read_addr <= to_unsigned(i, 4);
            wait for 40 ns;
            assert read_data = expected(i);
            i := i + 1;
        end loop; -- 5860

        reset <= '1';
        wait for 20 ns; -- 5880
        reset <= '0';
        wait for 20 ns; -- 5900
        assert done = '0';
        wait;
    end process;
end sim;
