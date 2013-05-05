library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity recomb_stage2 is
    port (clk : in std_logic;
          rom_real : in signed(15 downto 0);
          rom_imag : in signed(15 downto 0);
          even_real_in : in signed(15 downto 0);
          even_imag_in : in signed(15 downto 0);
          odd_real_in : in signed(15 downto 0);
          odd_imag_in : in signed(15 downto 0);
          even_real_out : out signed(15 downto 0);
          even_imag_out : out signed(15 downto 0);
          odd_real_out : out signed(15 downto 0);
          odd_imag_out : out signed(15 downto 0);
          writein : in std_logic;
          writeout : out std_logic;
          addrin : in unsigned(3 downto 0);
          addrout : out unsigned(3 downto 0));
end recomb_stage2;

architecture rtl of recomb_stage2 is
    signal odd_real_mid : signed(31 downto 0);
    signal odd_imag_mid : signed(31 downto 0);
    signal even_real_mid : signed(15 downto 0);
    signal even_imag_mid : signed(15 downto 0);
    signal addrmid : unsigned(3 downto 0);
    signal writemid : std_logic;
begin
    MULT : entity work.complex_mult port map (
        realx => odd_real_in,
        imagx => odd_imag_in,
        realy => rom_real,
        imagy => rom_imag,
        realz => odd_real_mid,
        imagz => odd_imag_mid,
        clk => clk
    );

    process (clk)
    begin
        if rising_edge(clk) then
            writemid <= writein;
            writeout <= writemid;
            addrmid <= addrin;
            addrout <= addrmid;
            even_real_mid <= even_real_in;
            even_imag_mid <= even_imag_in;
            even_real_out <= even_real_mid;
            even_imag_out <= even_imag_mid;
            odd_real_out <= odd_real_mid(31 downto 16);
            odd_imag_out <= odd_imag_mid(31 downto 16);
        end if;
    end process;
end rtl;
