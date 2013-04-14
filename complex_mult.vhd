library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity complex_mult is
    port (clk : in std_logic;
          realx : in signed(15 downto 0);
          imagx : in signed(15 downto 0);
          realy : in signed(15 downto 0);
          imagy : in signed(15 downto 0);
          realz : out signed(31 downto 0);
          imagz : out signed(31 downto 0));
end complex_mult;

architecture rtl of complex_mult is
    signal xryr : signed(31 downto 0);
    signal xryi : signed(31 downto 0);
    signal xiyr : signed(31 downto 0);
    signal xiyi : signed(31 downto 0);
begin
    MXRYR : entity work.mult port map (
        dataa => std_logic_vector(realx),
        datab => std_logic_vector(realy),
        signed(result) => xryr
    );

    MXRYI : entity work.mult port map (
        dataa => std_logic_vector(realx),
        datab => std_logic_vector(imagy),
        signed(result) => xryi
    );

    MXIYR : entity work.mult port map (
        dataa => std_logic_vector(imagx),
        datab => std_logic_vector(realy),
        signed(result) => xiyr
    );

    MXIYI : entity work.mult port map (
        dataa => std_logic_vector(imagx),
        datab => std_logic_vector(imagy),
        signed(result) => xiyi
    );

    process (clk)
    begin
        if rising_edge(clk) then
            realz <= xryr - xiyi;
            imagz <= xryi + xiyr;
        end if;
    end process;
end rtl;
