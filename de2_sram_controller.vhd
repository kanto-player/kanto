library ieee;
use ieee.std_logic_1164.all;

entity de2_sram_controller is
port (
    signal chipselect : in std_logic;
    signal write, read : in std_logic;
    signal address : in std_logic_vector(17 downto 0);
    signal readdata : out std_logic_vector(15 downto 0);
    signal writedata : in std_logic_vector(15 downto 0);
    signal byteenable : in std_logic_vector(1 downto 0);
    signal SRAM_DQ : inout std_logic_vector(15 downto 0);
    signal SRAM_ADDR : out std_logic_vector(17 downto 0);
    signal SRAM_UB_N, SRAM_LB_N : out std_logic;
    signal SRAM_WE_N, SRAM_CE_N : out std_logic;
    signal SRAM_OE_N : out std_logic
);
end de2_sram_controller;

architecture dp of de2_sram_controller is
begin
    SRAM_DQ <= writedata when write = '1'
        else (others => 'Z');
    readdata <= SRAM_DQ;
    SRAM_ADDR <= address;
    SRAM_UB_N <= not byteenable(1);
    SRAM_LB_N <= not byteenable(0);
    SRAM_WE_N <= not write;
    SRAM_CE_N <= not chipselect;
    SRAM_OE_N <= not read;
end dp;