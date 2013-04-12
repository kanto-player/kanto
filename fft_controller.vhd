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

          clk : in std_logic;
          start : in std_logic);
end fft_controller;

architecture rtl of fft_controller is
    type control_state_type is (idle, loading, dft, 
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
    signal fdom_addr : byte_array;
    signal fdom_write_en : std_logic_vector(0 to 15);
    signal dft_rom_data : complex_signed_array;
    signal dft_rom_addr : byte_array;
    signal dft_out_data : complex_signed_array;
    signal dft_out_addr : byte_array;
    signal dft_out_write : std_logic_vector(0 to 15);
    signal dft_done : std_logic_vector(0 to 15);
    type reorder_type is array(0 to 15) of unsigned(3 downto 0); 
    constant fft_reorder : reorder_type := (x"0", x"8", x"4", x"c", 
                                            x"2", x"a", x"6", x"e", 
                                            x"1", x"9", x"5", x"d",
                                            x"3", x"b", x"7", x"f");
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
        addr => fdom_addr,
        write_en => fdom_write_en,
        clk => clk
    );

    DFTR : entity work.dft_rom port map (
        data => dft_rom_data,
        addr => dft_rom_addr
    );

    DFT_GEN : for i in 0 to 15 generate
        DFT : entity work.dft_top port amp (
            tdom_data => tdom_readdata(to_integer(fft_reorder(i))),
            tdom_addr => tdom_readaddr(to_integer(fft_reorder(i))),
            tdom_offset => fft_reorder(i),

            clk => clk,
            reset => start,

            rom_data => dft_rom_data(i),
            rom_addr => dft_rom_addr(i),

            fdom_data => dft_out_data(i),
            fdom_addr => dft_out_addr(i),
            fdom_base => to_integer(i, 4),
            fdom_write => dft_out_write(i),
            done => dft_done(i)
        );

        with control_state select fdom_writedata(i) <=
            dft_out_data(i) when dft;
        with control_state select fdom_addr(i) <=
            dft_out_addr(i) when dft;
        with control_state select fdom_write_en(i) <=
            dft_out_write(i) when dft;
    end generate DFT_GEN;

    process (clk)
    begin
        if rising_edge(clk) then
            case control_state is
                when idle =>
                    if start = '1' then
                        control_state <= dft;
                    end if;
                when dft =>
                    if dft_done = x"ffff" then
                        control_state <= recomb1;
                    end if;
            end case;
        end if;
    end process;
end rtl;
