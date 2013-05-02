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
    
    signal rc_low_readaddr : unsigned(3 downto 0);
    signal rc_low_writeaddr : unsigned(3 downto 0);
    signal rc_low_writedata : signed(31 downto 0);
    signal rc_low_write_en : std_logic;
    signal rc_high_readaddr : unsigned(3 downto 0);
    signal rc_high_writeaddr : unsigned(3 downto 0);
    signal rc_high_writedata : signed(31 downto 0);
    signal rc_high_write_en : std_logic;
    
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
    
    signal tb_readaddr : unsigned(3 downto 0);
    signal tb_writeaddr : unsigned(3 downto 0);
    signal tb_write_en : std_logic;
    signal tb_low_writedata : signed(31 downto 0);
    signal tb_high_writedata : signed(31 downto 0);

    signal stage : unsigned(1 downto 0);
    signal step : unsigned(2 downto 0);
    
    type expected_type is array(0 to 31) of signed(31 downto 0);
    type mem_type is array(0 to 15) of signed(31 downto 0);
    
    signal user_mem : std_logic;
    
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
    low_readaddr <= tb_readaddr when user_mem = '1' else rc_low_readaddr;
    low_writeaddr <= tb_writeaddr when user_mem = '1' else rc_low_writeaddr;
    low_writedata <= tb_low_writedata when user_mem = '1' else rc_low_writedata;
    low_write_en <= tb_write_en when user_mem = '1' else rc_low_write_en;
    
    high_readaddr <= tb_readaddr when user_mem = '1' else rc_high_readaddr;
    high_writeaddr <= tb_writeaddr when user_mem = '1' else rc_high_writeaddr;
    high_writedata <= tb_high_writedata when user_mem = '1' else rc_high_writedata;
    high_write_en <= tb_write_en when user_mem = '1' else rc_high_write_en;

    RCR16 : entity work.recomb_rom16 port map (
        addr => rom_addr,
        data => rom_data,
        clk =>  clk
    );

    FDOM_RAM : entity work.fft_fdom_ram port map (
        readdata_low => low_readdata,
        readaddr_low => low_readaddr,
        writedata_low => low_writedata,
        writeaddr_low => low_writeaddr,
        write_en_low => low_write_en,
        readdata_high => high_readdata,
        readaddr_high => high_readaddr,
        writedata_high => high_writedata,
        writeaddr_high => high_writeaddr,
        write_en_high => high_write_en,
        reset => '0',
        stage => stage,
        step => step,
        clk => clk
    );

    RC : entity work.fft_recomb port map (
        clk => clk,
        reset => reset,
        done => done,
        rom_addr => rom_addr,
        rom_data => rom_data,
        low_readaddr => rc_low_readaddr,
        low_readdata => low_readdata,
        low_writeaddr => rc_low_writeaddr,
        low_writedata => rc_low_writedata,
        low_write_en => rc_low_write_en,
        high_readaddr => rc_high_readaddr,
        high_readdata => high_readdata,
        high_writeaddr => rc_high_writeaddr,
        high_writedata => rc_high_writedata,
        high_write_en => rc_high_write_en
    );

    clk <= not clk after 10 ns;

    process
        variable i : integer range 0 to 32;
    begin
        user_mem <= '1';
        stage <= "00";
        step <= "000";
        wait for 10 ns; -- 10 ns

        tb_write_en <= '1';
        
        i := 0;
        while i < 16 loop
            tb_writeaddr <= to_unsigned(i, 4);
            tb_low_writedata <= low_mem(i);
            tb_high_writedata <= high_mem(i);
            wait for 20 ns;
            i := i + 1;
        end loop; -- 330 ns

        tb_write_en <= '0';
        user_mem <= '0';
        stage <= "11";
        step <= "111";
        wait for 20 ns; -- 350 ns
        
        reset <= '1';
        wait for 20 ns; -- 370 ns
        stage <= "00";
        step <= "000";
        reset <= '0';
        
        wait for 420 ns; -- 790 ns
        assert done = '1';
        user_mem <= '1';
        wait for 20 ns; -- 810 ns

        i := 0;
        while i < 16 loop
            tb_readaddr <= to_unsigned(i, 4);
            wait for 40 ns;
            assert low_readdata = expected(i);
            assert high_readdata = expected(i + 16);
            i := i + 1;
        end loop; -- 1450 ns
        wait;
    end process;
end sim;
