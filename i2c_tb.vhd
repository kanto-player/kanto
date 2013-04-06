library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c_tb is
end i2c_tb;

architecture sim of i2c_tb is
    signal clk : std_logic := '0';
    constant addr : std_logic_vector(0 to 6) := "0011010";
    constant data : std_logic_vector(0 to 15) := "0001001000000000";
    signal start : std_logic;
    signal done : std_logic;
    signal fault : std_logic;
    
    signal i2c_sdat : std_logic;
    signal i2c_sclk : std_logic;
begin
    clk <= not clk after 10 ns;

    I2C_CONTROL : entity work.i2c_controller port map (
        clk => clk,
        addr => addr,
        data => data,
        start => start,
        done => done,
        fault => fault,

        i2c_sdat => i2c_sdat,
        i2c_sclk => i2c_sclk
    );

    process
        variable i : integer range 0 to 16;
    begin
        i2c_sdat <= 'Z';
        wait for 20 ns; -- 20 ns
        start <= '1';
        wait for 20 ns; -- 40 ns
        start <= '0';
        wait for 100 ns; -- 140 ns
        assert i2c_sdat  = '1';
        wait for 20 ns;  -- 160 ns
        assert i2c_sdat = '0';
        wait for 100 ns; -- 260 ns

        i := 0;
        while i < 7 loop -- Make sure address sent correctly
            assert i2c_sdat = addr(i);
            wait for 80 ns;
            assert i2c_sdat = addr(i);
            wait for 80 ns;
            i := i + 1;
        end loop; -- 1380 ns

        assert i2c_sdat = '0'; -- make sure 'W' bit is sent
        wait for 80 ns; -- 1460 ns
        assert i2c_sdat = '0';
        wait for 80 ns; -- 1540 ns

        i2c_sdat <= '0'; -- send ACK
        wait for 160 ns; -- 1700 ns
        i2c_sdat <= 'Z';
        
        i := 0;
        while i < 8 loop
            assert i2c_sdat = data(i);
            wait for 80 ns;
            assert i2c_sdat = data(i);
            wait for 80 ns;
            i := i + 1;
        end loop; -- 2980 ns

        i2c_sdat <= '0';
        wait for 160 ns;
        i2c_sdat <= 'Z'; -- 3140 ns

        while i < 16 loop
            assert i2c_sdat = data(i);
            wait for 80 ns;
            assert i2c_sdat = data(i);
            wait for 80 ns;
            i := i + 1;
        end loop; -- 4420 ns
        
        i2c_sdat <= '0';
        wait for 100 ns; -- 4520 ns
        i2c_sdat <= 'Z';
        wait for 80 ns; -- 4600 ns
        assert i2c_sdat = '0';
        wait for 40 ns; -- 4640 ns
        assert i2c_sdat = '1';
        wait for 60 ns; -- 4700 ns
        assert done = '1';

        wait;

    end process;

end sim;
