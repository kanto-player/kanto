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
begin
end rtl;