-- vga.vhd

-- This file was auto-generated as part of a generation operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga is
	port (
		vga_read         : in  std_logic                     := '0';             --         vga.read
		vga_write        : in  std_logic                     := '0';             --            .write
		vga_chipselect   : in  std_logic                     := '0';             --            .chipselect
		vga_address      : in  std_logic_vector(10 downto 0) := (others => '0'); --            .address
		vga_readdata     : out std_logic_vector(31 downto 0);                    --            .readdata
		vga_writedata    : in  std_logic_vector(31 downto 0) := (others => '0'); --            .writedata
		vga_clk          : in  std_logic                     := '0';             --  clock_sink.clk
		vga_reset        : in  std_logic                     := '0';             --  reset_sink.reset
		display_pixel_on : out std_logic;                                        -- conduit_end.export
		display_x        : in  std_logic_vector(9 downto 0)  := (others => '0'); --            .export
		display_y        : in  std_logic_vector(6 downto 0)  := (others => '0')  --            .export
	);
end entity vga;

architecture rtl of vga is
	component de2_vga_text_buffer is
		port (
			vga_read         : in  std_logic                     := 'X';             -- read
			vga_write        : in  std_logic                     := 'X';             -- write
			vga_chipselect   : in  std_logic                     := 'X';             -- chipselect
			vga_address      : in  std_logic_vector(10 downto 0) := (others => 'X'); -- address
			vga_readdata     : out std_logic_vector(31 downto 0);                    -- readdata
			vga_writedata    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			vga_clk          : in  std_logic                     := 'X';             -- clk
			vga_reset        : in  std_logic                     := 'X';             -- reset
			display_pixel_on : out std_logic;                                        -- export
			display_x        : in  std_logic_vector(9 downto 0)  := (others => 'X'); -- export
			display_y        : in  std_logic_vector(6 downto 0)  := (others => 'X')  -- export
		);
	end component de2_vga_text_buffer;

begin

	vga : component de2_vga_text_buffer
		port map (
			vga_read         => vga_read,         --         vga.read
			vga_write        => vga_write,        --            .write
			vga_chipselect   => vga_chipselect,   --            .chipselect
			vga_address      => vga_address,      --            .address
			vga_readdata     => vga_readdata,     --            .readdata
			vga_writedata    => vga_writedata,    --            .writedata
			vga_clk          => vga_clk,          --  clock_sink.clk
			vga_reset        => vga_reset,        --  reset_sink.reset
			display_pixel_on => display_pixel_on, -- conduit_end.export
			display_x        => display_x,        --            .export
			display_y        => display_y         --            .export
		);

end architecture rtl; -- of vga
