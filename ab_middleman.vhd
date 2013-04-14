library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ab_middleman is
    port (addr : in unsigned(8 downto 0);
          data : out std_logic_vector(15 downto 0);
          clk  : in std_logic;
          en   : in std_logic;
          sram_req  : out std_logic;
          sram_ack  : in std_logic;
          sram_readdata : in std_logic_vector(15 downto 0);
          sram_addr : out std_logic_vector(17 downto 0));
end ab_middleman;

architecture rtl of ab_middleman is
    type state_type is (INACTIVE, REQUESTING, READING);
    signal state : state_type := INACTIVE;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            case state is
                when INACTIVE =>
                    if en = '1' then
                        state <= REQUESTING;
                    end if;
                when REQUESTING =>
                    if sram_ack = '1' then
                        state <= READING;
                    end if;
                when READING =>
                    state <= INACTIVE;
                    data <= sram_readdata;
            end case;
        end if;
    end process;

    sram_req <= '1' when state = REQUESTING else '0';
    sram_addr <= "000000000" & std_logic_vector(addr);
end rtl;
