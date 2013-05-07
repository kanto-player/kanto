-- sdbuf.vhd

-- This file was auto-generated as part of a generation operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sdbuf is
	port (
		clk        : in  std_logic                     := '0';             --          clock.clk
		reset_n    : in  std_logic                     := '0';             --          reset.reset_n
		read       : in  std_logic                     := '0';             -- avalon_slave_0.read
		chipselect : in  std_logic                     := '0';             --               .chipselect
		address    : in  std_logic_vector(7 downto 0)  := (others => '0'); --               .address
		readdata   : out std_logic_vector(15 downto 0);                    --               .readdata
		sdbuf_rden : out std_logic;                                        --    conduit_end.export
		sdbuf_addr : out std_logic_vector(7 downto 0);                     --               .export
		sdbuf_data : in  std_logic_vector(15 downto 0) := (others => '0')  --               .export
	);
end entity sdbuf;

architecture rtl of sdbuf is
	component de2_sd_buffer is
		port (
			clk        : in  std_logic                     := 'X';             -- clk
			reset_n    : in  std_logic                     := 'X';             -- reset_n
			read       : in  std_logic                     := 'X';             -- read
			chipselect : in  std_logic                     := 'X';             -- chipselect
			address    : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			readdata   : out std_logic_vector(15 downto 0);                    -- readdata
			sdbuf_rden : out std_logic;                                        -- export
			sdbuf_addr : out std_logic_vector(7 downto 0);                     -- export
			sdbuf_data : in  std_logic_vector(15 downto 0) := (others => 'X')  -- export
		);
	end component de2_sd_buffer;

begin

	sdbuf : component de2_sd_buffer
		port map (
			clk        => clk,        --          clock.clk
			reset_n    => reset_n,    --          reset.reset_n
			read       => read,       -- avalon_slave_0.read
			chipselect => chipselect, --               .chipselect
			address    => address,    --               .address
			readdata   => readdata,   --               .readdata
			sdbuf_rden => sdbuf_rden, --    conduit_end.export
			sdbuf_addr => sdbuf_addr, --               .export
			sdbuf_data => sdbuf_data  --               .export
		);

end architecture rtl; -- of sdbuf
