library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dft_top is
    port (tdom_data : in signed(15 downto 0);
          tdom_addr : out unsigned(3 downto 0);
          clk : in std_logic;
          reset : in std_logic;
          rom_data : in signed(31 downto 0);
          rom_addr : out unsigned(7 downto 0);
          fdom_data : out signed(31 downto 0);
          fdom_addr : out unsigned(3 downto 0);
          fdom_write : out std_logic;
          done : out std_logic);
end dft_top;

architecture rtl of dft_top is
    signal s1_rom_real : signed(15 downto 0);
    signal s1_rom_imag : signed(15 downto 0);
    signal s1_tdom_real : signed(15 downto 0);
    signal s1_k : unsigned(3 downto 0);
    signal s1_write : std_logic;
    signal s1_done : std_logic;

    signal s2_k : unsigned(3 downto 0);
    signal s2_write : std_logic;
    signal s2_done : std_logic;
    signal s2_res_real : signed(31 downto 0);
    signal s2_res_imag : signed(31 downto 0);

    signal s3_done : std_logic;
    signal done_delay : unsigned(2 downto 0);
begin
    -- make sure done goes low right after reset
    -- hold it there until first input propagates through pipeline
    done <= '1' when s3_done = '1' and done_delay = "111" else '0';
    
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                done_delay <= "000";
            elsif done_delay /= "111" then
                done_delay <= done_delay + "1";
            end if;
        end if;
    end process;
   
    S1 : entity work.dft_stage1 port map (
        tdom_data => tdom_data,
        tdom_addr => tdom_addr,

        clk => clk,
        reset => reset,

        rom_data => rom_data,
        rom_addr => rom_addr,

        rom_real => s1_rom_real,
        rom_imag => s1_rom_imag,
        tdom_real => s1_tdom_real,
        outk => s1_k,
        write => s1_write,
        done => s1_done
    );

    S2 : entity work.dft_stage2 port map (
        rom_real => s1_rom_real,
        rom_imag => s1_rom_imag,
        tdom_real => s1_tdom_real,

        clk => clk,
        reset => reset,

        res_real => s2_res_real,
        res_imag => s2_res_imag,

        ink => s1_k,
        outk => s2_k,
        inwrite => s1_write,
        outwrite => s2_write,
        indone => s1_done,
        outdone => s2_done
    );

    S3 : entity work.dft_stage3 port map (
        mult_real => s2_res_real,
        mult_imag => s2_res_imag,

        clk => clk,
        reset => reset,

        indone => s2_done,
        outdone => s3_done,
        inwrite => s2_write,
        outwrite => fdom_write,
        k => s2_k,
        
        fdom_addr => fdom_addr,
        fdom_data => fdom_data
    );
end rtl;
