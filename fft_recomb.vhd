library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fft_recomb is
    port (clk : in std_logic;
          reset : in std_logic;
          done : out std_logic;
          rom_addr : out unsigned(3 downto 0);
          rom_data : in signed(31 downto 0);
          low_readaddr : out unsigned(3 downto 0);
          low_writeaddr : out unsigned(3 downto 0);
          low_readdata : in signed(31 downto 0);
          low_writedata : out signed(31 downto 0);
          low_write_en : out std_logic;
          high_readaddr : out unsigned(3 downto 0);
          high_writeaddr : out unsigned(3 downto 0);
          high_readdata : in signed(31 downto 0);
          high_writedata : out signed(31 downto 0);
          high_write_en : out std_logic);
end fft_recomb;

architecture rtl of fft_recomb is
    signal rom_real : signed(15 downto 0);
    signal rom_imag : signed(15 downto 0);
    signal even_real_s12 : signed(15 downto 0);
    signal even_imag_s12 : signed(15 downto 0);
    signal odd_real_s12 : signed(15 downto 0);
    signal odd_imag_s12 : signed(15 downto 0);
    signal even_real_s23 : signed(15 downto 0);
    signal even_imag_s23 : signed(15 downto 0);
    signal odd_real_s23 : signed(15 downto 0);
    signal odd_imag_s23 : signed(15 downto 0);
    signal addr_s12 : unsigned(3 downto 0);
    signal addr_s23 : unsigned(3 downto 0);
    signal write_s12 : std_logic;
    signal write_s23 : std_logic;
    signal done_s23 : std_logic;
begin
    S1 : entity work.recomb_stage1 port map (
        clk => clk,
        reset => reset,

        rom_addr => rom_addr,
        rom_data => rom_data,

        low_readaddr => low_readaddr,
        low_readdata => low_readdata,
        
        high_readaddr => high_readaddr,
        high_readdata => high_readdata,

        addrout => addr_s12,
        writeout => write_s12,

        even_real => even_real_s12,
        even_imag => even_imag_s12,
        odd_real => odd_real_s12,
        odd_imag => odd_imag_s12,
        rom_real => rom_real,
        rom_imag => rom_imag
    );

    S2 : entity work.recomb_stage2 port map (
        clk => clk,
        reset => reset,

        rom_real => rom_real,
        rom_imag => rom_imag,
        
        even_real_in => even_real_s12,
        even_imag_in => even_imag_s12,
        
        odd_real_in => odd_real_s12,
        odd_imag_in => odd_imag_s12,
        
        even_real_out => even_real_s23,
        even_imag_out => even_imag_s23,
        
        odd_real_out => odd_real_s23,
        odd_imag_out => odd_imag_s23,

        writein => write_s12,
        writeout => write_s23,
        doneout => done_s23,
        addrin => addr_s12,
        addrout => addr_s23
    );

    S3 : entity work.recomb_stage3 port map (
        clk => clk,
        reset => reset,
        done => done,

        even_real => even_real_s23,
        even_imag => even_imag_s23,
        odd_real => odd_real_s23,
        odd_imag => odd_imag_s23,

        addrin => addr_s23,
        writein => write_s23,
        donein => done_s23,

        low_writeaddr => low_writeaddr,
        low_writedata => low_writedata,
        low_write_en => low_write_en,
        
        high_writeaddr => high_writeaddr,
        high_writedata => high_writedata,
        high_write_en => high_write_en
    );
end rtl;
