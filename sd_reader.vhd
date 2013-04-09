library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sd_reader is
port(
	clk_en	: in std_logic;
	clk		: in std_logic;
	sd_data	: in std_logic_vector(15 downto 0);
	ready	: in std_logic;
	mosi	: out std_logic;
	cs		: out std_logic;
	play	: in std_logic
);
end sd_reader;

architecture rtl of sd_reader is

constant cmd_begin : std_logic_vector(0 to 7) := "01010001";
constant cmd_end : std_logic_vector(0 to 7) := "00000001";

signal cmd_addr : std_logic_vector(0 to 31) := (others => '0');
signal cmd_begin_counter : integer range 0 to 8 := 0;
signal cmd_addr_counter : integer range 0 to 32 := 0;
signal cmd_end_counter : integer range 0 to 8 := 0;

signal wait_counter : integer range 0 to 8 := 0;
signal resp_counter : integer range 0 to 7 := 0;
signal data_counter : integer range 0 to 16 := 0;
signal package_counter : integer range -1 to 256 := 0;
signal crc_counter : integer range 0 to 16 :=0;
signal fe : std_logic := '0';

signal sending : std_logic := '1';
signal playing : std_logic := '0';

begin

	cs <= '0';

	process(clk)
	begin
		if rising_edge(clk) then
			if play = '1' then
				playing <= '1';
			end if;

			if clk_en = '1' and playing = '1' then


				if ready = '1' and sending = '1' then
					if cmd_begin_counter /= 8 then
						mosi <= cmd_begin(cmd_begin_counter);
						cmd_begin_counter <= cmd_begin_counter + 1;

					elsif cmd_addr_counter /= 32 then
						mosi <= cmd_addr(cmd_addr_counter);
						cmd_addr_counter <= cmd_addr_counter + 1;

					elsif cmd_end_counter /= 32 then
						mosi <= cmd_end(cmd_end_counter);
						cmd_end_counter <= cmd_end_counter + 1;

					elsif wait_counter /= 8 then
						if sd_data(0) = '0' then
							wait_counter <= 8;
						elsif wait_counter = 7 then
							cmd_begin_counter <= 0;
							cmd_addr_counter <= 0;
							cmd_end_counter <= 0;
							wait_counter <= 0;
						else
							wait_counter <= wait_counter + 1;
						end if;

					elsif resp_counter /= 7 then
						resp_counter <= resp_counter + 1;

					elsif sd_data(7 downto 0) /= "00000000" then
						cmd_begin_counter <= 0;
						cmd_addr_counter <= 0;
						cmd_end_counter <= 0;
						wait_counter <= 0;
						resp_counter <= 0;

					else
						sending <= '0';
						mosi <= '1';

					end if;

				elsif ready = '1' and sending = '0' then
					if fe = '1' then
						if package_counter = 256 then
							--package_counter<=0;
							--fe<='0';
							--data_counter<=0;
							--sending='1';
							
							-- ignore 16 bits of CRC data
							if crc_counter/=16 then
								crc_counter<=crc_counter+1;
							else
								fe<='0';
								package_counter<=0;
								data_counter<=0;
								crc_counter <= 0;
								sending<='0';

								-- wait for play before sending next read command
								playing <= '0';
							end if;
						elsif data_counter=16 then
							--SEND DATA TO SRAM IF PACKAGE COUNTER >= 0
							data_counter<=0;
							package_counter<=package_counter+1;
						else
							data_counter<=data_counter+1;
						end if;

					else
						if sd_data(7 downto 0)="11111110" then
							fe<='1';
						end if;
					end if;



				end if;
			end if;

		end if;
	end process;
end rtl;
