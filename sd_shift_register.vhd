library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sd_shift_register is
port(
	clk_en		: in std_logic;
	clk		: in std_logic;
	data_in		: in std_logic;
	data_out	: out std_logic_vector(15 downto 0)
);
end sd_shift_register;

architecture rtl of sd_shift_register is
signal data_out_old	: std_logic_vector(15 downto 0) := "0000000000000000";
begin
	shifter : process(clk)
	begin
		if rising_edge(clk) then
			if clk_en = '1' then
				data_out_old(15 downto 1) <= data_out_old(14 downto 0);
				data_out_old(0) <= data_in;
			end if;
		end if;
	end process shifter;

	data_out <= data_out_old;
end rtl;
