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
    signal tdom_addr_debug : unsigned(7 downto 0);
    signal fdom_addr_debug : unsigned(3 downto 0);
    signal s1_write_debug : std_logic;
    signal s2_write_debug : std_logic;
    signal fdom_write_debug : std_logic;
    signal sum_debug : signed(63 downto 0);
    signal mult_debug : signed(63 downto 0);

    type expected_type is array(0 to 15) of signed(31 downto 0);
    constant expected : expected_type := 
        (x"01b70000", x"fffffe55", x"fffffbbc", x"fffff2cf", 
         x"0d2f1744", x"061605ec", x"050e02ce", x"04b80136", 
         x"04a10000", x"fffffec9", x"fffffd31", x"fffffa13", 
         x"ffffe8bb", x"fd5f0d30", x"00d80443", x"018d01aa");
begin
    DFT_TEST : entity work.dft_test_setup port map (
        clk => clk,
        reset => reset,
        done => done,
        read_addr => read_addr,
        read_data => read_data,
        tdom_addr_debug => tdom_addr_debug,
        fdom_addr_debug => fdom_addr_debug,
        s1_write_debug => s1_write_debug,
        s2_write_debug => s2_write_debug,
        fdom_write_debug => fdom_write_debug,
        sum_debug => sum_debug,
        mult_debug => mult_debug
    );

    clk <= not clk after 10 ns;

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
            wait for 10 ns;
            assert read_data = expected(i);
            wait for 10 ns;
            i := i + 1;
        end loop;
    end process;
end sim;
