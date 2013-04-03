library ieee;
use ieee.std_logic_1164.all;

-- A dummy SRAM controller which just spits the address back on readdata
entity sram_id_dummy is
    port (addr : in std_logic_vector(17 downto 0);
          readdata : out std_logic_vector(15 downto 0);
          req : in std_logic;
          ack : out std_logic;
          clk : in std_logic);
end sram_id_dummy;

architecture rtl of sram_id_dummy is
    type state_type is (INACTIVE, RESPONDING);
    signal state : state_type := INACTIVE;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            case state is
                when INACTIVE =>
                    if req = '1' then
                        state <= RESPONDING;
                        readdata <= addr(15 downto 0);
                    end if;
                when RESPONDING =>
                    if req = '0' then
                        state <= INACTIVE;
                        readdata <= (others => '0');
                    end if;
            end case;
        end if;
    end process;

    ack <= '1' when state = RESPONDING else '0';
end rtl;
