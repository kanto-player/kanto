library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fft_controller is
    port (tdom_data_even : in signed(15 downto 0);
          tdom_addr_even : out unsigned(3 downto 0);
          tdom_data_odd : in signed(15 downto 0);
          tdom_addr_odd : out unsigned(3 downto 0);
          tdom_sel : out unsigned(2 downto 0);

          fdom_data_out : out signed(31 downto 0);
          fdom_addr_out : in unsigned(7 downto 0);

          clk : in std_logic;
          start : in std_logic;
          done : out std_logic);
end fft_controller;

architecture rtl of fft_controller is
    type control_state_type is (idle, dftsetup, dftcomp,
                                recomb_setup, recomb_comp);
    signal control_state : control_state_type;
    signal last_state : control_state_type;
    signal fdom_writedata_low : signed(31 downto 0);
    signal fdom_readdata_low : signed(31 downto 0);
    signal fdom_readaddr_low : unsigned(3 downto 0);
    signal fdom_writeaddr_low : unsigned(3 downto 0);
    signal fdom_write_en_low : std_logic;
    signal fdom_writedata_high : signed(31 downto 0);
    signal fdom_readdata_high : signed(31 downto 0);
    signal fdom_readaddr_high : unsigned(3 downto 0);
    signal fdom_writeaddr_high : unsigned(3 downto 0);
    signal fdom_write_en_high : std_logic;
    signal recomb_stage : unsigned(1 downto 0);
    signal comp_step : unsigned(2 downto 0);
    signal fdom_step : unsigned(2 downto 0);
    signal dft_rom_data_low : signed(31 downto 0);
    signal dft_rom_addr_low : unsigned(7 downto 0);
    signal dft_out_data_low : signed(31 downto 0);
    signal dft_out_addr_low : unsigned(3 downto 0);
    signal dft_out_write_low : std_logic;
    signal dft_rom_data_high : signed(31 downto 0);
    signal dft_rom_addr_high : unsigned(7 downto 0);
    signal dft_out_data_high : signed(31 downto 0);
    signal dft_out_addr_high : unsigned(3 downto 0);
    signal dft_out_write_high : std_logic;
    signal dft_done : std_logic_vector(1 downto 0);
    signal dft_reset : std_logic;
    signal recomb_reset : std_logic;
    type fft_reorder_type is array(0 to 7) of unsigned(2 downto 0);
    constant fft_reorder : fft_reorder_type := ("000", "100", "010", "110", 
                                                "001", "101", "011", "111");
    signal rcrom16_data : signed(31 downto 0);
    signal rcrom32_data : signed(31 downto 0);
    signal rcrom64_data : signed(31 downto 0);
    signal rcrom128_data : signed(31 downto 0);
    signal rcromcur_addr : unsigned(3 downto 0);
    signal rcromcur_data : signed(31 downto 0);
    signal rcrom32_addr : unsigned(4 downto 0);
    signal rcrom64_addr : unsigned(5 downto 0);
    signal rcrom128_addr : unsigned(6 downto 0);
    
    signal recomb_writeaddr_low : unsigned(3 downto 0);
    signal recomb_writedata_low : signed(31 downto 0);
    signal recomb_readaddr_low : unsigned(3 downto 0);
    signal recomb_readdata_low : signed(31 downto 0);
    signal recomb_write_low : std_logic;
    signal recomb_writeaddr_high : unsigned(3 downto 0);
    signal recomb_writedata_high : signed(31 downto 0);
    signal recomb_readaddr_high : unsigned(3 downto 0);
    signal recomb_readdata_high : signed(31 downto 0);
    signal recomb_write_high : std_logic;
    signal recomb_done : std_logic;
begin

    FDOM_RAM : entity work.fft_fdom_ram port map (
        readdata_low => fdom_readdata_low,
        readaddr_low => fdom_readaddr_low,
        writedata_low => fdom_writedata_low,
        writeaddr_low => fdom_writeaddr_low,
        write_en_low => fdom_write_en_low,
        readdata_high => fdom_readdata_high,
        readaddr_high => fdom_readaddr_high,
        writedata_high => fdom_writedata_high,
        writeaddr_high => fdom_writeaddr_high,
        write_en_high => fdom_write_en_high,
        stage => recomb_stage,
        step => fdom_step,
        clk => clk
    );

    COEFF_ROM : entity work.dft_coeff_rom port map (
        clk => clk,
        data_low => dft_rom_data_low,
        addr_low => dft_rom_addr_low,
        data_high => dft_rom_data_high,
        addr_high => dft_rom_addr_high
    );
    
    tdom_sel <= fft_reorder(to_integer(comp_step));

    DFT_EVEN : entity work.dft_top port map (
        tdom_data => tdom_data_even,
        tdom_addr => tdom_addr_even,

        clk => clk,
        reset => dft_reset,

        rom_data => dft_rom_data_low,
        rom_addr => dft_rom_addr_low,

        fdom_data => dft_out_data_low,
        fdom_addr => dft_out_addr_low,
        fdom_write => dft_out_write_low,
        done => dft_done(0)
    );
    
    DFT_ODD : entity work.dft_top port map (
        tdom_data => tdom_data_odd,
        tdom_addr => tdom_addr_odd,

        clk => clk,
        reset => dft_reset,

        rom_data => dft_rom_data_high,
        rom_addr => dft_rom_addr_high,

        fdom_data => dft_out_data_high,
        fdom_addr => dft_out_addr_high,
        fdom_write => dft_out_write_high,
        done => dft_done(1)
    );

    with control_state select fdom_writedata_low <=
        dft_out_data_low when dftsetup | dftcomp,
        recomb_writedata_low when recomb_setup | recomb_comp,
        (others => '0') when others;
    
    with control_state select fdom_writeaddr_low <=
        dft_out_addr_low when dftsetup | dftcomp,
        recomb_writeaddr_low when recomb_setup | recomb_comp,
        (others => '0') when others;
    
    with control_state select fdom_write_en_low <=
        dft_out_write_low when dftsetup | dftcomp,
        recomb_write_low when recomb_setup | recomb_comp,
        '0' when others;
    
    with control_state select fdom_readaddr_low <=
        recomb_readaddr_low when recomb_setup | recomb_comp,
        fdom_addr_out(3 downto 0) when idle,
        (others => '0') when others;

    recomb_readdata_low <= fdom_readdata_low;

    with control_state select fdom_writedata_high <=
        dft_out_data_high when dftsetup | dftcomp,
        recomb_writedata_high when recomb_setup | recomb_comp,
        (others => '0') when others;
    
    with control_state select fdom_writeaddr_high <=
        dft_out_addr_high when dftsetup | dftcomp,
        recomb_writeaddr_high when recomb_setup | recomb_comp,
        (others => '0') when others;
    
    with control_state select fdom_write_en_high <=
        dft_out_write_high when dftsetup | dftcomp,
        recomb_write_high when recomb_setup | recomb_comp,
        '0' when others;
    
    with control_state select fdom_readaddr_high <=
        recomb_readaddr_high when recomb_setup | recomb_comp,
        fdom_addr_out(3 downto 0) when idle,
        (others => '0') when others;

    recomb_readdata_high <= fdom_readdata_high;

    fdom_data_out <= fdom_readdata_high when fdom_addr_out(7) = '1' else
                     fdom_readdata_low;
    fdom_step <= fdom_addr_out(6 downto 4) when 
                    control_state = idle else comp_step;

    RECOMB : entity work.fft_recomb port map (
        clk => clk,
        reset => recomb_reset,
        rom_addr => rcromcur_addr,
        rom_data => rcromcur_data,
        low_readaddr => recomb_readaddr_low,
        low_writeaddr => recomb_writeaddr_low,
        low_readdata => recomb_readdata_low,
        low_writedata => recomb_writedata_low,
        low_write_en => recomb_write_low,
        high_readaddr => recomb_readaddr_high,
        high_writeaddr => recomb_writeaddr_high,
        high_readdata => recomb_readdata_high,
        high_writedata => recomb_writedata_high,
        high_write_en => recomb_write_high,
        done => recomb_done
    );

    with recomb_stage select rcromcur_data <=
        rcrom16_data when "00",
        rcrom32_data when "01",
        rcrom64_data when "10",
        rcrom128_data when others;

    RCR16 : entity work.rcrom16 port map (
        address => std_logic_vector(rcromcur_addr),
        signed(q) => rcrom16_data,
        clock => clk
    );

    rcrom32_addr <= comp_step(0) & rcromcur_addr;
    RCR32 : entity work.rcrom32 port map (
        address => std_logic_vector(rcrom32_addr),
        signed(q) => rcrom32_data,
        clock => clk
    );

    rcrom64_addr <= comp_step(1 downto 0) & rcromcur_addr;
    RCR64 : entity work.rcrom64 port map (
        address => std_logic_vector(rcrom64_addr),
        signed(q) => rcrom64_data,
        clock => clk
    );

    rcrom128_addr <= comp_step & rcromcur_addr;
    RCR128 : entity work.rcrom128 port map (
        address => std_logic_vector(rcrom128_addr),
        signed(q) => rcrom128_data,
        clock => clk
    );

    done <= '1' when control_state = idle else '0';
    dft_reset <= '1' when control_state = dftsetup else '0';
    recomb_reset <= '1' when control_state = recomb_setup else '0';
    
    process (clk)
    begin
        if rising_edge(clk) then
            last_state <= control_state;
            case control_state is
                when idle =>
                    recomb_stage <= "11";
                    comp_step <= "111";
                    if start = '1' then
                        control_state <= dftsetup;
                    end if;
                when dftsetup =>
                    recomb_stage <= "11";
                    comp_step <= comp_step + 1;
                    control_state <= dftcomp;
                when dftcomp =>
                    if dft_done = "11" then
                        if comp_step = "111" then
                            control_state <= recomb_setup;
                        else
                            control_state <= dftsetup;
                        end if;
                    end if;
                when recomb_setup =>
                    if comp_step = "111" then
                        recomb_stage <= recomb_stage + 1;
                        comp_step <= "000";
                    else
                        comp_step <= comp_step + 1;
                    end if;
                    control_state <= recomb_comp;
                when recomb_comp =>
                    if recomb_done = '1' then
                        if comp_step = "111" and recomb_stage = "11" then
                            control_state <= idle;
                        else
                            control_state <= recomb_setup;
                        end if;
                    end if;
            end case;
        end if;
    end process;
end rtl;
