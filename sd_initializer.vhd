library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sd_initializer is
port(
	clk_en		: in std_logic;
	clk		: in std_logic;
	sd_data		: in std_logic_vector(15 downto 0);
	mosi		: out std_logic;
	cs		: out std_logic;
	ready	: out std_logic
);
end sd_initializer;

architecture rtl of sd_initializer is
signal zero_counter : integer range 0 to 80 := 0;
constant reset_cmd : std_logic_vector(0 to 47) := "010000000000000000000000000000000000000010010101";
signal cmd_counter : integer range 0 to 48 := 0;
signal wait_counter : integer range 0 to 16 := 0;
signal resp_counter : integer range 0 to 7 := 0;
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if clk_en = '1' then

				-- sending mosi high and cs high for at least 74 clocks
				if zero_counter /= 80 then
					ready <= '0';
					mosi <= '1';
					cs <= '1';
					zero_counter <= zero_counter + 1;

				-- sending command
				elsif cmd_counter /= 48 then
					mosi <= reset_cmd(cmd_counter);
					cs <= '0';
					cmd_counter <= cmd_counter + 1;

				-- waiting for command
				elsif wait_counter /= 16 then
					mosi <= '1';
					if sd_data(0) = '0' then
						wait_counter <= 16;
					-- resend command if 0 not received within 16 clocks
					elsif wait_counter = 15 then
						cmd_counter <= 0;
						wait_counter <= 0;
					else
						wait_counter <= wait_counter + 1;
					end if;

				-- received 0 - wait 7 cycles for entire response
				else
					if resp_counter /= 7 then
						resp_counter <= resp_counter + 1;
					elsif sd_data(7 downto 0) /= "00000001" then
						cmd_counter <= 0;
						wait_counter <= 0;
						resp_counter <= 0;

					-- all good
					else
						ready <= '1';
					end if;

				end if;

			end if;


		end if;
	end process;
end rtl;
