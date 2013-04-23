library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sd_dummy is
    port (clk : in std_logic;
          start : in std_logic;
          ready : out std_logic;

          writedata : out signed(15 downto 0);
          writeaddr : out unsigned(7 downto 0);
          write_en : out std_logic);
end sd_dummy;

architecture rtl of sd_dummy is
    signal running : std_logic := '0';
    signal rom_addr : unsigned(7 downto 0) := x"00";
    signal waddr_sig : unsigned(7 downto 0);
    type rom_type is array(0 to 168) of signed(15 downto 0);
    constant rom_data : rom_type := (x"7fff", x"7fe8", x"7fa3", x"7f32", 
        x"7e93", x"7dc7", x"7cce", x"7ba9", x"7a58", x"78dc", x"7734", 
        x"7562", x"7367", x"7142", x"6ef5", x"6c80", x"69e5", x"6725", 
        x"643f", x"6136", x"5e0b", x"5abe", x"5750", x"53c4", x"501a", 
        x"4c53", x"4871", x"4475", x"4061", x"3c37", x"37f6", x"33a2", 
        x"2f3c", x"2ac4", x"263e", x"21a9", x"1d09", x"185f", x"13ac", 
        x"0ef2", x"0a32", x"056f", x"00aa", x"fbe6", x"f722", x"f261", 
        x"eda6", x"e8f0", x"e443", x"dfa0", x"db08", x"d67e", x"d202", 
        x"cd97", x"c93d", x"c4f7", x"c0c6", x"bcac", x"b8a9", x"b4c0", 
        x"b0f2", x"ad3f", x"a9ab", x"a634", x"a2de", x"9fa9", x"9c96", 
        x"99a7", x"96dc", x"9436", x"91b7", x"8f5f", x"8d2f", x"8b27", 
        x"894a", x"8796", x"860e", x"84b0", x"837f", x"827a", x"81a2", 
        x"80f6", x"8078", x"8027", x"8003", x"800d", x"8045", x"80aa", 
        x"813c", x"81fc", x"82e8", x"8400", x"8545", x"86b6", x"8851", 
        x"8a17", x"8c07", x"8e21", x"9063", x"92cc", x"955c", x"9813", 
        x"9aee", x"9ded", x"a10f", x"a453", x"a7b8", x"ab3b", x"aedd", 
        x"b29c", x"b677", x"ba6b", x"be79", x"c29d", x"c6d8", x"cb26", 
        x"cf88", x"d3fb", x"d87d", x"dd0e", x"e1ab", x"e653", x"eb03", 
        x"efbc", x"f47a", x"f93c", x"fe01", x"02c5", x"0789", x"0c4b", 
        x"1108", x"15c0", x"1a6f", x"1f15", x"23b0", x"283f", x"2cbf", 
        x"312f", x"358e", x"39d9", x"3e10", x"4231", x"463a", x"4a2b", 
        x"4e01", x"51bb", x"5558", x"58d7", x"5c37", x"5f75", x"6292", 
        x"658b", x"6860", x"6b11", x"6d9b", x"6ffe", x"7239", x"744c", 
        x"7635", x"77f4", x"7989", x"7af2", x"7c30", x"7d42", x"7e27", 
        x"7edf", x"7f6a", x"7fc7", x"7ff7");
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if running = '0' then
                if start = '1' then
                    running <= '1';
                    waddr_sig <= x"00";
                end if;
            else
                if waddr_sig = 255 then
                    running <= '0';
                else
                    waddr_sig <= waddr_sig + 1;
                end if;

                if rom_addr = 168 then
                    rom_addr <= x"00";
                else
                    rom_addr <= rom_addr + 1;
                end if;
            end if;
        end if;
    end process;

    writeaddr <= waddr_sig;
    writedata <= rom_data(to_integer(rom_addr));
    write_en <= running;
    ready <= not running;
end rtl;
