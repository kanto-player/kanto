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

    type expected_type is array(0 to 15) of signed(31 downto 0);
    constant expected : expected_type := 
        (x"01b70000", x"018dfe55", x"00d8fbbc", x"fd5ff2cf", 
         x"0d2f1744", x"061605ec", x"050e02ce", x"04b80136", 
         x"04a10000", x"04b8fec9", x"050efd31", x"0616fa13", 
         x"0d2fe8bb", x"fd5f0d30", x"00d80443", x"018d01aa");
begin
    DFT_TEST : entity work.dft_test_setup port map (
        clk => clk,
        reset => reset,
        done => done,
        read_addr => read_addr,
        read_data => read_data
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
