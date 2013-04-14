library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity fft_controller is
    port (sram_readdata : in std_logic_vector(15 downto 0);
          sram_writedata : out std_logic_vector(15 downto 0);
          sram_addr : out std_logic_vector(17 downto 0);
          sram_write : out std_logic;
          sram_req : out std_logic;
          sram_ack : in std_logic;
          sram_base : in unsigned(9 downto 0);

          clk : in std_logic;
          start : in std_logic);
end fft_controller;

architecture rtl of fft_controller is
    type control_state_type is (idle, loading, dftcomp, 
                                recomb1, recomb2, recomb3, recomb4, 
                                writing);
    signal control_state : control_state_type;
    signal tdom_writedata : signed(15 downto 0);
    signal tdom_writeaddr : unsigned(7 downto 0);
    signal tdom_write_en : std_logic;
    signal tdom_readdata : real_signed_array;
    signal tdom_readaddr : byte_array;
    signal fdom_writedata : complex_signed_array;
    signal fdom_readdata : complex_signed_array;
    signal fdom_readaddr : nibble_array;
    signal fdom_writeaddr : nibble_array;
    signal fdom_bigdata : signed(31 downto 0);
    signal fdom_bigaddr : unsigned(7 downto 0);
    signal fdom_write_en : std_logic_vector(0 to 15);
    signal dft_rom_data : complex_signed_array;
    signal dft_rom_addr : byte_array;
    signal dft_out_data : complex_signed_array;
    signal dft_out_addr : nibble_array;
    signal dft_out_write : std_logic_vector(0 to 15);
    signal dft_done : std_logic_vector(0 to 15);
    signal dft_reset : std_logic;
    signal mm_done : std_logic;
    signal start_write : std_logic;
    signal start_recomb : std_logic;
    type fft_reorder_type is array(0 to 15) of unsigned(3 downto 0); 
    constant fft_reorder : fft_reorder_type := (x"0", x"8", x"4", x"c", 
                                                x"2", x"a", x"6", x"e", 
                                                x"1", x"9", x"5", x"d",
                                                x"3", x"b", x"7", x"f");
    type rc_reorder_type is array(0 to 15) of integer range 0 to 15;
    constant rc1_out_ro : rc_reorder_type := (0, 8, 1, 9, 2, 10, 3, 11,
                                              4, 12, 5, 13, 6, 14, 7, 15);
    constant rc2_out_ro : rc_reorder_type := (0, 1, 8, 9, 2, 3, 10, 11,
                                              4, 5, 12, 13, 6, 7, 14, 15);
    constant rc3_out_ro : rc_reorder_type := (0, 1, 2, 3, 8, 9, 10, 11,
                                              4, 5, 6, 7, 12, 13, 14, 15);
    constant rc1_in_ro : rc_reorder_type := (0, 2, 4, 6, 8, 10, 12, 14,
                                             1, 3, 5, 7, 9, 11, 13, 15);
    constant rc2_in_ro : rc_reorder_type := (0, 1, 4, 5, 8, 9, 12, 13, 
                                             2, 3, 6, 7, 10, 11, 14, 15);
    constant rc3_in_ro : rc_reorder_type := (0, 1, 2, 3, 8, 9, 10, 11,
                                             4, 5, 6, 7, 12, 13, 14, 15);
    signal rcrom16_data : complex_signed_half_array;
    signal rcrom32_data : complex_signed_half_array;
    signal rcrom64_data : complex_signed_half_array;
    signal rcrom128_data : complex_signed_half_array;
    signal rcromcur_addr : nibble_half_array;
    signal rcromcur_data : complex_signed_half_array;
    signal recomb_writeaddr : nibble_array;
    signal recomb_writedata : complex_signed_array;
    signal recomb_readaddr : nibble_array;
    signal recomb_readdata : complex_signed_array;
    signal recomb_write : std_logic_vector(0 to 15);
    signal recomb_done : std_logic_vector(0 to 7);
begin
    TDOM_RAM : entity work.fft_tdom_ram port map (
        writedata => tdom_writedata,
        writeaddr => tdom_writeaddr,
        write_en => tdom_write_en,
        readdata => tdom_readdata,
        readaddr => tdom_readaddr,
        clk => clk
    );

    FDOM_RAM : entity work.fft_fdom_ram port map (
        writedata => fdom_writedata,
        readdata => fdom_readdata,
        bigdata => fdom_bigdata,
        bigaddr => fdom_bigaddr,
        readaddr => fdom_readaddr,
        writeaddr => fdom_writeaddr,
        write_en => fdom_write_en,
        clk => clk
    );

    COEFF_ROM : entity work.dft_coeff_rom port map (
        data => dft_rom_data,
        addr => dft_rom_addr
    );

    DFT_GEN : for i in 0 to 15 generate
        DFT : entity work.dft_top port map (
            tdom_data => tdom_readdata(to_integer(fft_reorder(i))),
            tdom_addr => tdom_readaddr(to_integer(fft_reorder(i))),
            tdom_offset => fft_reorder(i),

            clk => clk,
            reset => dft_reset,

            rom_data => dft_rom_data(i),
            rom_addr => dft_rom_addr(i),

            fdom_data => dft_out_data(i),
            fdom_addr => dft_out_addr(i),
            fdom_write => dft_out_write(i),
            done => dft_done(i)
        );
        

        with control_state select fdom_writedata(i) <=
            dft_out_data(i) when dftcomp,
            recomb_writedata(rc1_out_ro(i)) when recomb1,
            recomb_writedata(rc2_out_ro(i)) when recomb2,
            recomb_writedata(rc3_out_ro(i)) when recomb3,
            recomb_writedata(i) when recomb4,
            (others => '0') when others;
        with control_state select fdom_writeaddr(i) <=
            dft_out_addr(i) when dftcomp,
            recomb_writeaddr(rc1_out_ro(i)) when recomb1,
            recomb_writeaddr(rc2_out_ro(i)) when recomb2,
            recomb_writeaddr(rc3_out_ro(i)) when recomb3,
            recomb_writeaddr(i) when recomb4,
            (others => '0') when others;
        with control_state select fdom_write_en(i) <=
            dft_out_write(i) when dftcomp,
            recomb_write(rc1_out_ro(i)) when recomb1,
            recomb_write(rc2_out_ro(i)) when recomb2,
            recomb_write(rc3_out_ro(i)) when recomb3,
            recomb_write(i) when recomb4,
            '0' when others;
        with control_state select fdom_readaddr(i) <=
            recomb_readaddr(rc1_out_ro(i)) when recomb1,
            recomb_readaddr(rc2_out_ro(i)) when recomb2,
            recomb_readaddr(rc3_out_ro(i)) when recomb3,
            recomb_readaddr(i) when recomb4,
            (others => '0') when others;
        with control_state select recomb_readdata(i) <=
            fdom_readdata(rc1_in_ro(i)) when recomb1,
            fdom_readdata(rc2_in_ro(i)) when recomb2,
            fdom_readdata(rc3_in_ro(i)) when recomb3,
            fdom_readdata(i) when recomb4,
            (others => '0') when others;
    end generate DFT_GEN;

    RECOMB_GEN : for i in 0 to 7 generate
        RECOMB : entity work.fft_recomb port map (
            clk => clk,
            reset => start_recomb,
            rom_addr => rcromcur_addr(i),
            rom_data => rcromcur_data(i),
            low_readaddr => recomb_readaddr(i),
            low_writeaddr => recomb_writeaddr(i),
            low_readdata => recomb_readdata(i),
            low_writedata => recomb_writedata(i),
            low_write_en => recomb_write(i),
            high_readaddr => recomb_readaddr(i + 8),
            high_writeaddr => recomb_writeaddr(i + 8),
            high_readdata => recomb_readdata(i + 8),
            high_writedata => recomb_writedata(i + 8),
            high_write_en => recomb_write(i + 8),
            done => recomb_done(i)
        );
    end generate RECOMB_GEN;

    with control_state select rcromcur_data <=
        rcrom16_data when recomb1,
        rcrom32_data when recomb2,
        rcrom64_data when recomb3,
        rcrom128_data when others;

    MM : entity work.fft_middleman port map (
        clk => clk,
        done => mm_done,
        start_read => start,
        start_write => start_write,
        
        sram_req => sram_req,
        sram_ack => sram_ack,
        sram_write => sram_write,
        sram_readdata => sram_readdata,
        sram_writedata => sram_writedata,
        sram_addr => sram_addr,

        tdom_data => tdom_writedata,
        tdom_addr => tdom_writeaddr,
        tdom_write => tdom_write_en,
        tdom_base => sram_base,

        fdom_data => fdom_bigdata,
        fdom_addr => fdom_bigaddr
    );

    RCR16 : entity work.recomb_rom16 port map (
        addr => rcromcur_addr,
        data => rcrom16_data
    );

    RCR32 : entity work.recomb_rom32 port map (
        addr => rcromcur_addr,
        data => rcrom32_data
    );


    RCR64 : entity work.recomb_rom64 port map (
        addr => rcromcur_addr,
        data => rcrom64_data
    );


    RCR128 : entity work.recomb_rom128 port map (
        addr => rcromcur_addr,
        data => rcrom128_data
    );
    
    process (clk)
    begin
        if rising_edge(clk) then
            case control_state is
                when idle =>
                    if start = '1' then
                        control_state <= loading;
                    end if;
                when loading =>
                    if mm_done = '1' then
                        control_state <= dftcomp;
                        dft_reset <= '1';
                    end if;
                when dftcomp =>
                    dft_reset <= '0';
                    if dft_done = x"ffff" then
                        control_state <= recomb1;
                    end if;
                when others =>
                    control_state <= idle;
            end case;
        end if;
    end process;
end rtl;
