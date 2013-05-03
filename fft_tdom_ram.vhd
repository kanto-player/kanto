library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fft_tdom_ram is
    port (clk : std_logic;
          
          readaddr_even : in unsigned(3 downto 0);
          readaddr_odd  : in unsigned(3 downto 0);
          readdata_even : out signed(15 downto 0);
          readdata_odd  : out signed(15 downto 0);
          readsel : in unsigned(2 downto 0);

          writeaddr : in unsigned(7 downto 0);
          writedata : in signed(15 downto 0);
          write_en : in std_logic);
end fft_tdom_ram;

architecture rtl of fft_tdom_ram is
    signal even_write_en : std_logic;
    signal odd_write_en : std_logic;
    signal short_waddr : unsigned(6 downto 0);
    signal even_raddr  : unsigned(6 downto 0);
    signal odd_raddr   : unsigned(6 downto 0);
begin
    even_write_en <= write_en and (not writeaddr(0));
    odd_write_en <= write_en and writeaddr(0);

    short_waddr <= writeaddr(7 downto 1);
    even_raddr <= readaddr_even & readsel;
    odd_raddr <= readaddr_odd & readsel;

    EVEN_RAM : entity work.tdom_half_ram port map (
        clock => clk,
        data => std_logic_vector(writedata),
        rdaddress => std_logic_vector(even_raddr),
        wraddress => std_logic_vector(short_waddr),
        wren => even_write_en,
        signed(q) => readdata_even
    );
    
    ODD_RAM : entity work.tdom_half_ram port map (
        clock => clk,
        data => std_logic_vector(writedata),
        rdaddress => std_logic_vector(odd_raddr),
        wraddress => std_logic_vector(short_waddr),
        wren => odd_write_en,
        signed(q) => readdata_odd
    );
end rtl;
