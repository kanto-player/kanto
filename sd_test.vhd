library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sd_test is
port (
    clk : in std_logic;
	 play : out std_logic;
    ready : out std_logic;
	 data_out : in std_logic_vector(15 downto 0);
	 hex : out std_logic_vector (6 downto 0));
end sd_test;

architecture rtl of sd_test is
signal count : integer range 0 to 25000000 := 0;
begin
    process(clk)
	 begin
	     if rising_edge(clk) then
  	         play <= '0';
		  
		      if count = 25000000 then
				   count <= 0;
				else
     				count <= count + 1;
				end if;
		  end if;
	 end process;
end rtl;