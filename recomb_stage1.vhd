library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity recomb_stage1 is
    port (clk : in std_logic;
          reset : in std_logic;
          rom_addr : out unsigned(3 downto 0);
          rom_data : in signed(31 downto 0);
          low_readaddr : out unsigned(3 downto 0);
          low_readdata : in signed(31 downto 0);
          high_readaddr : out unsigned(3 downto 0);
          high_readdata : in signed(31 downto 0);
          addrout : out unsigned(3 downto 0);
          writeout : out std_logic;
          rom_real : out signed(15 downto 0);
          rom_imag : out signed(15 downto 0);
          even_real : out signed(15 downto 0);
          even_imag : out signed(15 downto 0);
          odd_real : out signed(15 downto 0);
          odd_imag : out signed(15 downto 0));
end recomb_stage1;

architecture rtl of recomb_stage1 is
    signal running : std_logic;
    signal addr : unsigned(3 downto 0);
begin
    rom_addr <= addr;
    low_readaddr <= addr;
    high_readaddr <= addr;

    process (clk)
    begin
        if rising_edge(clk) then
            writeout <= running;
            if running = '1' then
                addrout <= addr;
                rom_real <= rom_data(31 downto 16);
                rom_imag <= rom_data(15 downto 0);
                even_real <= low_readdata(31 downto 16);
                even_imag <= low_readdata(15 downto 0);
                odd_real <= high_readdata(31 downto 16);
                odd_imag <= high_readdata(15 downto 0);
            end if;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                running <= '1';
                addr <= x"0";
            elsif addr = x"f" then
                running <= '0';
            else
                addr <= addr + "1";
            end if;
        end if;
    end process;
end rtl;
