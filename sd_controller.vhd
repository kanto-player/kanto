library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sd_controller is
port(
	clk50	: in std_logic;
	cs	: out std_logic;
	mosi	: out std_logic;
	miso	: in std_logic;
	play	: in std_logic;
	ready	: out std_logic;
);
end sd_controller;

architecture datapath of sd_controller is

component sd_initializer
port(
	clk_en		: in std_logic;
	clk		: in std_logic;
	sd_data		: in std_logic_vector(15 downto 0);
	mosi		: out std_logic;
	cs		: out std_logic;
	ready	: out std_logic
);
end component;

component sd_reader;
port(
	clk_en		: in std_logic;
	clk		: in std_logic;
	sd_data	: in std_logic_vector(15 downto 0);
	ready	: in std_logic;
	mosi	: out std_logic;
	cs		: out std_logic;
	play	: in std_logic;
);
end component;

component sd_shift_register;
port(
	clk_en		: in std_logic;
	clk		: in std_logic;
	data_in		: in std_logic;
	data_out	: out std_logic_vector(15 downto 0)
);
end component;

signal shift_reg_data : std_logic_vector(15 downto 0);
signal init_done : std_logic;

signal init_mosi : std_logic;
signal reader_mosi : std_logic;
signal init_cs : std_logic;
signal reader_cs : std_logic;

signal sd_clk_enable : std_logic := '1';

signal clk_counter : integer range 0 to 250;

begin

	SHIFT_REG : sd_shift_register port map(
		clk_en => sd_clk_enable,
		clk => clk50,
		data_in => miso,
		data_out => shift_reg_data
	);

	READER : sd_reader port map(
		clk_en => sd_clk_enable,
		clk => clk50,
		sd_data => shift_reg_data,
		ready => init_done,
		mosi => reader_mosi,
		cs => reader_cs
		play => play;
	);

	INIT : sd_initializer port map(
		clk_en	=> sd_clk_enable,
		clk => clk50,
		sd_data => shift_reg_data,
		mosi => init_mosi,
		cs => init_cs,
		ready => init_done
	);

	mosi <= init_mosi when not init_done
			else reader_mosi;
	cs <= init_cs when not init_done
			else reader_cs;

	ready <= init_done;

	-- clock divider
	process(clk)
	begin

		if rising_edge(clk) then

			if init_done then
				-- assuming 25MHz sd clock for transfers
				sd_clk_enable <= not sd_clk_enable;
			else
				sd_clk_enable <= '0';
				if clk_counter /= 250 then
					clk_counter <= clk_counter + 1;
				else
					sd_clk_enable <= '1';
					clk_counter <= 0;
				end if;
			end if;

		end if;

	end process;

end datapath;
