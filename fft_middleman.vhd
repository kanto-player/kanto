library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.types_pkg.all;

entity fft_middleman is
    port (sram_readdata : in std_logic_vector(15 downto 0);
          sram_addr : out std_logic_vector(17 downto 0);
          sram_req : out std_logic;
          sram_ack : in std_logic;

          tdom_data : out signed(15 downto 0);
          tdom_addr : out unsigned(7 downto 0);
          tdom_write : out std_logic;
          tdom_base : in unsigned(9 downto 0);
          
          done : out std_logic;
          clk : in std_logic;
          start_read : in std_logic);
end fft_middleman;

architecture rtl of fft_middleman is
    signal intern_addr : unsigned(7 downto 0) := x"00";
    signal full_addr : unsigned(17 downto 0);
    type state_type is (idle, tdom_req, tdom_ack);
    signal state : state_type := idle;
begin
    sram_req <= '1' when state = tdom_req;
    full_addr <= tdom_base & intern_addr;
    sram_addr <= std_logic_vector(full_addr); 
    
    tdom_data <= signed(sram_readdata) when state = tdom_ack else (others => '0');
    tdom_write <= '1' when state = tdom_ack else '0';
    tdom_addr <= intern_addr;

    done <= '1' when state = idle else '0';

    process (clk)
    begin
        if rising_edge(clk) then
            case state is
                when idle =>
                    if start_read = '1' then
                        state <= tdom_req;
                    end if;
                when tdom_req =>
                    if sram_ack = '1' then
                        state <= tdom_ack;
                    end if;
                when tdom_ack =>
                    if intern_addr = x"ff" then
                        state <= idle;
                        intern_addr <= x"00";
                    else
                        state <= tdom_req;
                        intern_addr <= intern_addr + "1";
                    end if;
            end case;
        end if;
    end process;
end rtl;
