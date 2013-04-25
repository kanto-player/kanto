--
-- Testbench for the simple VGA raster generator
--
-- Stephen A. Edwards, Columbia University, sedwards@cs.columbia.edu

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity viz_tb is
  
end viz_tb;

architecture tb of viz_tb is

  signal clk, reset : std_logic;
  signal VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC : std_logic;
  signal ledr15, ledr16, ledr17 : std_logic;
  signal VGA_R, VGA_G, VGA_B : std_logic_vector(9 downto 0);
    signal fft_fdom_addr : unsigned(7 downto 0);
    signal fft_fdom_data : signed(31 downto 0);

begin

  process
  begin
    loop
       clk <= '1';
       wait for 0.5 ns;
       clk <= '0';
       wait for 0.5 ns;
    end loop;
  end process;

  process
  begin
    wait 1 ns;
    reset <= '1';
    wait for 1 ns;
    reset <= '0';
    wait;
  end process;

  dut : entity work.visualizer port map (
    clk => clk,
        reset_data_test      => reset,
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
		ledr17				=> ledr17,
		ledr16				=> ledr16,
		ledr15				=> ledr15

  );

end tb;
