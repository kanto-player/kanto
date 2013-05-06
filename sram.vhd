-- sram.vhd

-- This file was auto-generated as part of a generation operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sram is
	port (
		chipselect : in    std_logic                     := '0';             -- avalon_slave_0.chipselect
		write      : in    std_logic                     := '0';             --               .write
		read       : in    std_logic                     := '0';             --               .read
		address    : in    std_logic_vector(17 downto 0) := (others => '0'); --               .address
		readdata   : out   std_logic_vector(15 downto 0);                    --               .readdata
		writedata  : in    std_logic_vector(15 downto 0) := (others => '0'); --               .writedata
		byteenable : in    std_logic_vector(1 downto 0)  := (others => '0'); --               .byteenable
		SRAM_DQ    : inout std_logic_vector(15 downto 0) := (others => '0'); --    conduit_end.export
		SRAM_ADDR  : out   std_logic_vector(17 downto 0);                    --               .export
		SRAM_UB_N  : out   std_logic;                                        --               .export
		SRAM_LB_N  : out   std_logic;                                        --               .export
		SRAM_WE_N  : out   std_logic;                                        --               .export
		SRAM_CE_N  : out   std_logic;                                        --               .export
		SRAM_OE_N  : out   std_logic                                         --               .export
	);
end entity sram;

architecture rtl of sram is
	component de2_sram_controller is
		port (
			chipselect : in    std_logic                     := 'X';             -- chipselect
			write      : in    std_logic                     := 'X';             -- write
			read       : in    std_logic                     := 'X';             -- read
			address    : in    std_logic_vector(17 downto 0) := (others => 'X'); -- address
			readdata   : out   std_logic_vector(15 downto 0);                    -- readdata
			writedata  : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			byteenable : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			SRAM_DQ    : inout std_logic_vector(15 downto 0) := (others => 'X'); -- export
			SRAM_ADDR  : out   std_logic_vector(17 downto 0);                    -- export
			SRAM_UB_N  : out   std_logic;                                        -- export
			SRAM_LB_N  : out   std_logic;                                        -- export
			SRAM_WE_N  : out   std_logic;                                        -- export
			SRAM_CE_N  : out   std_logic;                                        -- export
			SRAM_OE_N  : out   std_logic                                         -- export
		);
	end component de2_sram_controller;

begin

	sram : component de2_sram_controller
		port map (
			chipselect => chipselect, -- avalon_slave_0.chipselect
			write      => write,      --               .write
			read       => read,       --               .read
			address    => address,    --               .address
			readdata   => readdata,   --               .readdata
			writedata  => writedata,  --               .writedata
			byteenable => byteenable, --               .byteenable
			SRAM_DQ    => SRAM_DQ,    --    conduit_end.export
			SRAM_ADDR  => SRAM_ADDR,  --               .export
			SRAM_UB_N  => SRAM_UB_N,  --               .export
			SRAM_LB_N  => SRAM_LB_N,  --               .export
			SRAM_WE_N  => SRAM_WE_N,  --               .export
			SRAM_CE_N  => SRAM_CE_N,  --               .export
			SRAM_OE_N  => SRAM_OE_N   --               .export
		);

end architecture rtl; -- of sram
