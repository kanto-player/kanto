-- ps2.vhd

-- This file was auto-generated as part of a generation operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ps2 is
	port (
		avs_s1_address    : in  std_logic_vector(2 downto 0) := (others => '0'); -- avalon_slave_0.address
		avs_s1_read       : in  std_logic                    := '0';             --               .read
		avs_s1_chipselect : in  std_logic                    := '0';             --               .chipselect
		avs_s1_readdata   : out std_logic_vector(7 downto 0);                    --               .readdata
		PS2_Clk           : in  std_logic                    := '0';             --    conduit_end.export
		PS2_Data          : in  std_logic                    := '0';             --               .export
		avs_s1_clk        : in  std_logic                    := '0';             --     clock_sink.clk
		avs_s1_reset      : in  std_logic                    := '0'              --     reset_sink.reset
	);
end entity ps2;

architecture rtl of ps2 is
	component de2_ps2 is
		port (
			avs_s1_address    : in  std_logic_vector(2 downto 0) := (others => 'X'); -- address
			avs_s1_read       : in  std_logic                    := 'X';             -- read
			avs_s1_chipselect : in  std_logic                    := 'X';             -- chipselect
			avs_s1_readdata   : out std_logic_vector(7 downto 0);                    -- readdata
			PS2_Clk           : in  std_logic                    := 'X';             -- export
			PS2_Data          : in  std_logic                    := 'X';             -- export
			avs_s1_clk        : in  std_logic                    := 'X';             -- clk
			avs_s1_reset      : in  std_logic                    := 'X'              -- reset
		);
	end component de2_ps2;

begin

	ps2 : component de2_ps2
		port map (
			avs_s1_address    => avs_s1_address,    -- avalon_slave_0.address
			avs_s1_read       => avs_s1_read,       --               .read
			avs_s1_chipselect => avs_s1_chipselect, --               .chipselect
			avs_s1_readdata   => avs_s1_readdata,   --               .readdata
			PS2_Clk           => PS2_Clk,           --    conduit_end.export
			PS2_Data          => PS2_Data,          --               .export
			avs_s1_clk        => avs_s1_clk,        --     clock_sink.clk
			avs_s1_reset      => avs_s1_reset       --     reset_sink.reset
		);

end architecture rtl; -- of ps2
