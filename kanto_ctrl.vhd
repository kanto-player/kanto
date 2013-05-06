-- kanto_ctrl.vhd

-- This file was auto-generated as part of a generation operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity kanto_ctrl is
	port (
		clk            : in  std_logic                     := '0';             --          clock.clk
		reset_n        : in  std_logic                     := '0';             --               .reset_n
		write          : in  std_logic                     := '0';             -- avalon_slave_0.write
		chipselect     : in  std_logic                     := '0';             --               .chipselect
		address        : in  std_logic_vector(2 downto 0)  := (others => '0'); --               .address
		readdata       : out std_logic_vector(31 downto 0);                    --               .readdata
		writedata      : in  std_logic_vector(31 downto 0) := (others => '0'); --               .writedata
		read           : in  std_logic                     := '0';             --               .read
		nios_readblock : out std_logic;                                        --    conduit_end.export
		nios_play      : out std_logic;                                        --               .export
		nios_stop      : out std_logic;                                        --               .export
		nios_addr      : out std_logic_vector(31 downto 0);                    --               .export
		nios_done      : in  std_logic                     := '0';             --               .export
		sd_blockaddr   : in  std_logic_vector(31 downto 0) := (others => '0')  --               .export
	);
end entity kanto_ctrl;

architecture rtl of kanto_ctrl is
	component de2_kanto_ctrl is
		port (
			clk            : in  std_logic                     := 'X';             -- clk
			reset_n        : in  std_logic                     := 'X';             -- reset_n
			write          : in  std_logic                     := 'X';             -- write
			chipselect     : in  std_logic                     := 'X';             -- chipselect
			address        : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- address
			readdata       : out std_logic_vector(31 downto 0);                    -- readdata
			writedata      : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			read           : in  std_logic                     := 'X';             -- read
			nios_readblock : out std_logic;                                        -- export
			nios_play      : out std_logic;                                        -- export
			nios_stop      : out std_logic;                                        -- export
			nios_addr      : out std_logic_vector(31 downto 0);                    -- export
			nios_done      : in  std_logic                     := 'X';             -- export
			sd_blockaddr   : in  std_logic_vector(31 downto 0) := (others => 'X')  -- export
		);
	end component de2_kanto_ctrl;

begin

	kanto_ctrl : component de2_kanto_ctrl
		port map (
			clk            => clk,            --          clock.clk
			reset_n        => reset_n,        --               .reset_n
			write          => write,          -- avalon_slave_0.write
			chipselect     => chipselect,     --               .chipselect
			address        => address,        --               .address
			readdata       => readdata,       --               .readdata
			writedata      => writedata,      --               .writedata
			read           => read,           --               .read
			nios_readblock => nios_readblock, --    conduit_end.export
			nios_play      => nios_play,      --               .export
			nios_stop      => nios_stop,      --               .export
			nios_addr      => nios_addr,      --               .export
			nios_done      => nios_done,      --               .export
			sd_blockaddr   => sd_blockaddr    --               .export
		);

end architecture rtl; -- of kanto_ctrl
