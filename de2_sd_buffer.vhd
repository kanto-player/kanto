library ieee;
use ieee.std_logic_1164.all;

entity de2_sd_buffer is
    port (clk : in std_logic;
          reset_n : in std_logic;
          read : in std_logic;
          chipselect : in std_logic;
          address : in std_logic_vector(7 downto 0);
          readdata : out std_logic_vector(15 downto 0);

          sdbuf_rden : out std_logic;
          sdbuf_addr : out std_logic_vector(7 downto 0);
          sdbuf_data : in std_logic_vector(15 downto 0));
end de2_sd_buffer;

architecture rtl of de2_sd_buffer is
begin
    sdbuf_addr <= address;
    readdata <= sdbuf_data;
    sdbuf_rden <= read and chipselect and reset_n;
end rtl;
