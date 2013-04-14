library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sd_test is
port (
    clk : in std_logic;
	play : out std_logic;
    ready : out std_logic;
	data_out : in std_logic_vector(15 downto 0);
	hex7 : out std_logic_vector (6 downto 0);
	hex6 : out std_logic_vector (6 downto 0);
	hex5 : out std_logic_vector (6 downto 0);
	hex4 : out std_logic_vector (6 downto 0);
    s_address : in std_logic_vector(17 downto 0);
    s_ack : out std_logic;
    s_req : in std_logic
);
end sd_test;

architecture rtl of sd_test is

    signal count : integer range 0 to 25000000 := 0;
    type state is (waiting, writing, wait_req, done);
    signal curr : state := waiting;
    type ram_type is array(0 to 7) of std_logic_vector(15 downto 0);
    signal ram : ram_type;
    
begin
    
    HEX_A : entity work.hex_driver port map (
        digit => ram(3)(3 downto 0),
        hex_out => hex7
    );
    
    HEX_B : entity work.hex_driver port map (
        digit => ram(3)(7 downto 4),
        hex_out => hex6
    );
    
    HEX_C : entity work.hex_driver port map (
        digit => ram(3)(11 downto 8),
        hex_out => hex5
    );
    
    HEX_D : entity work.hex_driver port map (
        digit => ram(3)(15 downto 12),
        hex_out => hex4
    );
    
    
    process(clk)
	begin
    
    if rising_edge(clk) then
    
    case curr is
    
    when waiting =>
        ram(0) <= "0101010101010101";
        ram(1) <= "0101010101010101";
        ram(2) <= "0101010101010101";
        ram(3) <= "0101010101010101";
        if count /= 25000000 then
            count <= count + 1;
        else
            count <= 0;
            play <= '1';
            curr <= writing;
        end if;
    
    when writing =>
        play <= '0';
        if count = 8 then
            curr <= done;
        elsif s_req = '1' then
        ram(0) <= "1010101010101010";
        ram(1) <= "1010101010101010";
        ram(2) <= "1010101010101010";
        ram(3) <= "1010101010101010";
            ram(count) <= data_out;
            s_ack <= '1';
            curr <= wait_req;
        end if;
        
    when wait_req =>
        if s_req = '0' then
            s_ack <= '0';
            count <= count + 1;
            curr <= writing;
        end if;
        
    when done =>
        count <= 0;
        
    end case;
        
    
    end if;
    
    end process;
end rtl;