--
-- DE2 top-level module that includes the simple audio component
--
-- Stephen A. Edwards, Columbia University, sedwards@cs.columbia.edu
--
-- From an original by Terasic Technology, Inc.
-- (DE2_TOP.v, part of the DE2 system board CD supplied by Altera)
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.types_pkg.all;

entity kanto is
    port(
        -- Clocks
        
        CLOCK_27,                                      -- 27 MHz
        CLOCK_50,                                      -- 50 MHz
        EXT_CLOCK : in std_logic;                      -- External Clock

        -- Buttons and switches
        
        KEY : in std_logic_vector(3 downto 0);         -- Push buttons
        SW : in std_logic_vector(17 downto 0);         -- DPDT switches

        -- LED displays

        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 -- 7-segment displays
             : out std_logic_vector(6 downto 0);
        LEDG : out std_logic_vector(7 downto 0);       -- Green LEDs
        LEDR : out std_logic_vector(17 downto 0);      -- Red LEDs

        -- RS-232 interface

        UART_TXD : out std_logic;                      -- UART transmitter     
        UART_RXD : in std_logic;                       -- UART receiver

        -- IRDA interface

--        IRDA_TXD : out std_logic;                    -- IRDA Transmitter
        IRDA_RXD : in std_logic;                       -- IRDA Receiver

        -- SDRAM
     
        DRAM_DQ : inout std_logic_vector(15 downto 0); -- Data Bus
        DRAM_ADDR : out std_logic_vector(11 downto 0); -- Address Bus        
        DRAM_LDQM,                                     -- Low-byte Data Mask 
        DRAM_UDQM,                                     -- High-byte Data Mask
        DRAM_WE_N,                                     -- Write Enable
        DRAM_CAS_N,                                    -- Column Address Strobe
        DRAM_RAS_N,                                    -- Row Address Strobe
        DRAM_CS_N,                                     -- Chip Select
        DRAM_BA_0,                                     -- Bank Address 0
        DRAM_BA_1,                                     -- Bank Address 0
        DRAM_CLK,                                      -- Clock
        DRAM_CKE : out std_logic;                      -- Clock Enable

        -- FLASH
        
        FL_DQ : inout std_logic_vector(7 downto 0);    -- Data bus
        FL_ADDR : out std_logic_vector(21 downto 0);   -- Address bus
        FL_WE_N,                                       -- Write Enable
        FL_RST_N,                                      -- Reset
        FL_OE_N,                                       -- Output Enable
        FL_CE_N : out std_logic;                       -- Chip Enable

        -- SRAM
        
        SRAM_DQ : inout std_logic_vector(15 downto 0); -- Data bus 16 Bits
        SRAM_ADDR : out std_logic_vector(17 downto 0); -- Address bus 18 Bits
        SRAM_UB_N,                                     -- High-byte Data Mask 
        SRAM_LB_N,                                     -- Low-byte Data Mask 
        SRAM_WE_N,                                     -- Write Enable
        SRAM_CE_N,                                     -- Chip Enable
        SRAM_OE_N : out std_logic;                     -- Output Enable

        -- USB controller
        
        OTG_DATA : inout std_logic_vector(15 downto 0); -- Data bus
        OTG_ADDR : out std_logic_vector(1 downto 0);    -- Address
        OTG_CS_N,                                       -- Chip Select
        OTG_RD_N,                                       -- Write
        OTG_WR_N,                                       -- Read
        OTG_RST_N,                                      -- Reset
        OTG_FSPEED,                                     -- USB Full Speed, 0 = Enable, Z = Disable
        OTG_LSPEED : out std_logic;                     -- USB Low Speed, 0 = Enable, Z = Disable
        OTG_INT0,                                       -- Intfaultupt 0
        OTG_INT1,                                       -- Intfaultupt 1
        OTG_DREQ0,                                      -- DMA Request 0
        OTG_DREQ1 : in std_logic;                       -- DMA Request 1     
        OTG_DACK0_N,                                    -- DMA Acknowledge 0
        OTG_DACK1_N : out std_logic;                    -- DMA Acknowledge 1

        -- 16 X 2 LCD Module
        
        LCD_ON,                                         -- Power ON/OFF
        LCD_BLON,                                       -- Back Light ON/OFF
        LCD_RW,                                         -- Read/Write Select, 0 = Write, 1 = Read
        LCD_EN,                                         -- Enable
        LCD_RS : out std_logic;                         -- Command/Data Select, 0 = Command, 1 = Data
        LCD_DATA : inout std_logic_vector(7 downto 0);  -- Data bus 8 bits

        -- SD card interface
        
        SD_DAT,                                         -- SD Card Data
        SD_DAT3,                                        -- SD Card Data 3
        SD_CMD : inout std_logic;                       -- SD Card Command Signal
        SD_CLK : out std_logic;                         -- SD Card Clock

        -- USB JTAG link
        
        TDI,                                            -- CPLD -> FPGA (data in)
        TCK,                                            -- CPLD -> FPGA (clk)
        TCS : in std_logic;                             -- CPLD -> FPGA (CS)
        TDO : out std_logic;                            -- FPGA -> CPLD (data out)

        -- I2C bus
        
        I2C_SDAT : inout std_logic; -- I2C Data
        I2C_SCLK : out std_logic;   -- I2C Clock

        -- PS/2 port

        PS2_DAT,                        -- Data
        PS2_CLK : in std_logic;         -- Clock

        -- VGA output
        
        VGA_CLK,                                        -- Clock
        VGA_HS,                                         -- H_SYNC
        VGA_VS,                                         -- V_SYNC
        VGA_BLANK,                                      -- BLANK
        VGA_SYNC : out std_logic;                       -- SYNC
        VGA_R,                                          -- Red[9:0]
        VGA_G,                                          -- Green[9:0]
        VGA_B : out std_logic_vector(9 downto 0);       -- Blue[9:0]

        --    Ethernet Interface
        
        ENET_DATA : inout std_logic_vector(15 downto 0);        -- DATA bus 16Bits
        ENET_CMD,                     -- Command/Data Select, 0 = Command, 1 = Data
        ENET_CS_N,                                              -- Chip Select
        ENET_WR_N,                                              -- Write
        ENET_RD_N,                                              -- Read
        ENET_RST_N,                                             -- Reset
        ENET_CLK : out std_logic;                               -- Clock 25 MHz
        ENET_INT : in std_logic;                                -- Intfaultupt
        
        -- Audio CODEC
        
        AUD_ADCLRCK : inout std_logic;                         -- ADC LR Clock
        AUD_ADCDAT : in std_logic;                             -- ADC Data
        AUD_DACLRCK : inout std_logic;                         -- DAC LR Clock
        AUD_DACDAT : out std_logic;                            -- DAC Data
        AUD_BCLK : inout std_logic;                            -- Bit-Stream Clock
        AUD_XCK : out std_logic;                               -- Chip Clock
        
        -- Video Decoder
        
        TD_DATA : in std_logic_vector(7 downto 0);    -- Data bus 8 bits
        TD_HS,                                        -- H_SYNC
        TD_VS : in std_logic;                         -- V_SYNC
        TD_RESET : out std_logic;                     -- Reset
        
        -- General-purpose I/O
        
        GPIO_0,                                      -- GPIO Connection 0
        GPIO_1 : inout std_logic_vector(35 downto 0) -- GPIO Connection 1
        );
    
end kanto;

architecture datapath of kanto is
    signal ab_play : std_logic;
    signal ab_audio_ok : std_logic;
    signal ab_swapped : std_logic;
    signal ab_force_swap : std_logic;

	signal fft_req : std_logic;
	signal fft_ack : std_logic;
	signal fft_addr : std_logic_vector(17 downto 0);
	signal fft_readdata : std_logic_vector(15 downto 0);
	signal fft_start : std_logic;
    signal fft_tdom_addr : nibble_array;
    signal fft_tdom_data : real_signed_array;
    signal fft_tdom_sel : std_logic;
    signal fft_fdom_addr : unsigned(7 downto 0);
    signal fft_fdom_data : signed(31 downto 0);
	signal fft_done      : std_logic;
	
	signal main_clk : std_logic;
	signal aud_clk : std_logic;
	signal sdram_clk : std_logic;
	signal start : std_logic;
	 
	-- inserted for SDC testing
	signal sd_start : std_logic;
	signal sd_ready : std_logic;
    signal sd_err : std_logic;
    signal sd_waiting : std_logic;
    signal sd_resp_debug : std_logic_vector(7 downto 0);
    signal sd_state_debug : std_logic_vector(7 downto 0);
    signal sd_ccs : std_logic;
    signal sd_writedata : signed(15 downto 0);
    signal sd_writeaddr : unsigned(7 downto 0);
    signal sd_write_en : std_logic;
	  
    signal clk25 : std_logic := '0';
    signal master_reset_n : std_logic;
    signal viz_reset : std_logic; 
    signal cond_err : std_logic;
    signal viz_test_data : unsigned (15 downto 0) := (others =>'0'); 
    
    -- visUALIZER reset testing
    signal one_cycle_reset : std_logic := '0';
    signal reset_counter : integer := 0;


    component de2_i2c_av_config is
        port (iclk : in std_logic;
              irst_n : in std_logic;
              i2c_sclk : out std_logic;
              i2c_sdat : inout std_logic);
    end component;
begin

  process (CLOCK_50)
  begin
    if rising_edge(CLOCK_50) then
      clk25 <= not clk25;
    end if;
  end process;
  
  
  
  
  process (CLOCK_50)
  begin
    if rising_edge(CLOCK_50) then
        if reset_counter=125000000 then
            one_cycle_reset <= '1';
            reset_counter <= 0;
            viz_test_data <= not viz_test_data;
                LEDR(13) <= viz_test_data(15);
        else 
            one_cycle_reset <= '0';
            LEDR(13) <= viz_test_data(15);
     reset_counter<=reset_counter + 1;

        end if;
    -- viz_test_data <= viz_test_data + 1;
     end if;
  end process;

    LEDG(0) <= sd_ready;
    LEDG(1) <= sd_ccs;
    LEDG(2) <= ab_play;
    LEDR(0) <= sd_err;
    LEDR(1) <= cond_err;
    ab_play <= SW(17) and ab_audio_ok;
    master_reset_n <= KEY(0);

    PLL : entity work.audpll port map (
        inclk0 => CLOCK_50,
        c0 => main_clk,
        c1 => aud_clk,
        c2 => sdram_clk
    );
    
    AUD_XCK <= aud_clk;

    I2C_CONF : de2_i2c_av_config port map (
        iclk => main_clk,
        irst_n => '1',
        i2c_sdat => i2c_sdat,
        i2c_sclk => i2c_sclk
    );
    
    CDTR : entity work.conductor port map (
        clk => main_clk,
        reset_n => master_reset_n,
        ab_audio_ok => ab_audio_ok,
        ab_swapped => ab_swapped,
        ab_force_swap => ab_force_swap,
        sd_start => sd_start,
        sd_ready => sd_ready,
        fft_start => fft_start,
        fft_done => fft_done,
        cond_err => cond_err,
        viz_reset => viz_reset
    );

    AB : entity work.audio_buffer port map (
        clk => main_clk,
        aud_clk => aud_clk,
        play => ab_play,
        swapped => ab_swapped,
        force_swap => ab_force_swap,

        aud_adclrck => aud_adclrck,
        aud_adcdat => aud_adcdat,
        aud_daclrck => aud_daclrck,
        aud_dacdat => aud_dacdat,
        aud_bclk => aud_bclk,
        
        writeaddr => sd_writeaddr,
        writedata => sd_writedata,
        write_en => sd_write_en,
        
        readdata => fft_tdom_data,
        readaddr => fft_tdom_addr,
        readsel => fft_tdom_sel
    );

    SDC : entity work.sd_controller port map (
        clk50 => main_clk,

        cs   => SD_DAT3,
        mosi => SD_CMD,
        miso => SD_DAT,
        sclk => SD_CLK,
        
        start => sd_start,
        ready => sd_ready,
        err => sd_err,
        waiting => sd_waiting,
        ccs => sd_ccs,
        
        resp_debug => sd_resp_debug,
        state_debug => sd_state_debug,
        
        writedata => sd_writedata,
        writeaddr => sd_writeaddr,
        write_en => sd_write_en
    );

    FFT : entity work.fft_controller port map (
        clk => main_clk,
        start => fft_start,
        done => fft_done,
        
        tdom_addr => fft_tdom_addr,
        tdom_data => fft_tdom_data,
        tdom_sel => fft_tdom_sel,
        fdom_addr_out => fft_fdom_addr,
        fdom_data_out => fft_fdom_data
    );
    
	 VISUALIZER : entity work.visualizer port map(
		--clk   			=> main_clk,
		clk25 => clk25,
        clk50 => CLOCK_50,
--		reset_data		=> fft_done,
        --reset_data_test      => viz_reset,
        test_data => viz_test_data,
        reset_data_test => one_cycle_reset,
		fft_fdom_addr 	=> fft_fdom_addr,
		fft_fdom_data 	=> fft_fdom_data,
		VGA_CLK        => VGA_CLK,
		VGA_HS         => VGA_HS,
		VGA_VS         => VGA_VS,
		VGA_BLANK      => VGA_BLANK,
		VGA_SYNC 		=> VGA_SYNC,
		VGA_R      		=> VGA_R,
		VGA_G          => VGA_G,
		VGA_B 			=> VGA_B,
		ledr17				=> LEDR(17),
		ledr16				=> LEDR(16),
		ledr15				=> LEDR(15)
	 );
     
    SS0 : entity work.sevenseg port map (
        number => sd_resp_debug(3 downto 0),
        display => HEX0
    );

    SS1 : entity work.sevenseg port map (
        number => sd_resp_debug(7 downto 4),
        display => HEX1
    );
    
    SS2 : entity work.sevenseg port map (
        number => sd_state_debug(3 downto 0),
        display => HEX2
    );
    
    SS3 : entity work.sevenseg port map (
        number => sd_state_debug(7 downto 4),
        display => HEX3
    );
	 
    HEX7 <= (others => '1');
    HEX6 <= (others => '1');
    HEX5 <= (others => '1');
    HEX4 <= (others => '1');

    LEDG(7 downto 3) <= (others => '0');
    LEDR(12 downto 2) <= (others => '0');
    
    LCD_ON   <= '1';
    LCD_BLON <= '1';
    LCD_RW   <= '1';
    LCD_EN   <= '0';
    LCD_RS   <= '0';

    --SD_DAT3 <= '1';    
    --SD_CMD <= '1';
    --SD_CLK <= '1';

    UART_TXD <= '0';
    DRAM_ADDR <= (others => '0');
    DRAM_LDQM <= '0';
    DRAM_UDQM <= '0';
    DRAM_WE_N <= '1';
    DRAM_CAS_N <= '1';
    DRAM_RAS_N <= '1';
    DRAM_CS_N <= '1';
    DRAM_BA_0 <= '0';
    DRAM_BA_1 <= '0';
    DRAM_CLK <= '0';
    DRAM_CKE <= '0';

    SRAM_DQ <= (others => 'Z');
    SRAM_ADDR <= (others => '0');
    SRAM_UB_N <= '1';
    SRAM_LB_N <= '1';
    SRAM_CE_N <= '1';
    SRAM_WE_N <= '1';
    SRAM_OE_N <= '1';

    FL_ADDR <= (others => '0');
    FL_WE_N <= '1';
    FL_RST_N <= '0';
    FL_OE_N <= '1';
    FL_CE_N <= '1';

    OTG_ADDR <= (others => '0');
    OTG_CS_N <= '1';
    OTG_RD_N <= '1';
    OTG_RD_N <= '1';
    OTG_WR_N <= '1';
    OTG_RST_N <= '1';
    OTG_FSPEED <= '1';
    OTG_LSPEED <= '1';
    OTG_DACK0_N <= '1';
    OTG_DACK1_N <= '1';

    TDO <= '0';

    ENET_CMD <= '0';
    ENET_CS_N <= '1';
    ENET_WR_N <= '1';
    ENET_RD_N <= '1';
    ENET_RST_N <= '1';
    ENET_CLK <= '0';
    
    TD_RESET <= '0';

    -- Set all bidirectional ports to tri-state
    DRAM_DQ         <= (others => 'Z');
    FL_DQ             <= (others => 'Z');
    OTG_DATA        <= (others => 'Z');
    LCD_DATA        <= (others => 'Z');
    SD_DAT            <= 'Z';
    ENET_DATA     <= (others => 'Z');
    GPIO_0            <= (others => 'Z');
    GPIO_1            <= (others => 'Z');

end datapath;
