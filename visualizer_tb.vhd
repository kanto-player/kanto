library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity visualizer_tb is
End visualizer_tb;

architecture behaviour of visualizer_tb is
component visualizer port( 
	 clk   : in std_logic;                    -- Should be 25.125 MHz
	 reset_data: in std_logic;
	 
	 fft_fdom_addr : out unsigned(7 downto 0);
    fft_fdom_data : in signed(31 downto 0);
	 
    VGA_CLK,                         -- Clock
    VGA_HS,                          -- H_SYNC
    VGA_VS,                          -- V_SYNC
    VGA_BLANK,                       -- BLANK
    VGA_SYNC : out std_logic;        -- SYNC
    VGA_R,                           -- Red[9:0]
    VGA_G,                           -- Green[9:0]
    VGA_B : out std_logic_vector(9 downto 0)
	 );
end component;

signal clk : std_logic := '0';
signal reset_data : std_logic := '0';
signal fft_fdom_addr : unsigned (7 downto 0);
signal fft_fdom_data : signed (31 downto 0) := (others =>'0');
signal VGA_CLK : std_logic;              
signal VGA_HS : std_logic;                        
signal VGA_VS : std_logic;           
signal VGA_BLANK : std_logic;                    
signal VGA_SYNC : std_logic;       
signal VGA_R : std_logic_vector(9 downto 0);
signal VGA_G : std_logic_vector(9 downto 0);
signal VGA_B : std_logic_vector(9 downto 0);

begin
	uut : visualizer port map(
	 clk => clk,
	 reset_data => reset_data,
	 
	 fft_fdom_addr => fft_fdom_addr,
    fft_fdom_data => fft_fdom_data,
	 
    VGA_CLK=>VGA_CLK,
    VGA_HS=> VGA_HS,
    VGA_VS=> VGA_VS,
    VGA_BLANK=>VGA_BLANK,
    VGA_SYNC=>VGA_SYNC,
    VGA_R=>VGA_R,
    VGA_G=>VGA_G,
    VGA_B=>VGA_B
	);
	
clk_process : process
begin
--	clk <='0';
--	wait for clk_period/2;
--	clk<='1';
--	wait for clk_period/2;
end process;
	
supercool : process
	--reset_data <= '1'
	--fft_fdom_data <= "
	
begin
end process;
end;