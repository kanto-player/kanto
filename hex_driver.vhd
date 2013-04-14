library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hex_driver is
port (
    digit : in std_logic_vector(3 downto 0);
    hex_out : out std_logic_vector(0 to 6)
);
end hex_driver;


architecture rtl of hex_driver is

constant SEG_0 : std_logic_vector(6 downto 0) := "1000000";
constant SEG_1 : std_logic_vector(6 downto 0) := "1111001";
constant SEG_2 : std_logic_vector(6 downto 0) := "0100100";
constant SEG_3 : std_logic_vector(6 downto 0) := "0110000";
constant SEG_4 : std_logic_vector(6 downto 0) := "0011001";
constant SEG_5 : std_logic_vector(6 downto 0) := "0010010";
constant SEG_6 : std_logic_vector(6 downto 0) := "0000010";
constant SEG_7 : std_logic_vector(6 downto 0) := "1111000";
constant SEG_8 : std_logic_vector(6 downto 0) := "0000000";
constant SEG_9 : std_logic_vector(6 downto 0) := "0010000";
constant SEG_A : std_logic_vector(6 downto 0) := "0001000";
constant SEG_B : std_logic_vector(6 downto 0) := "0000011";
constant SEG_C : std_logic_vector(6 downto 0) := "1000110";
constant SEG_D : std_logic_vector(6 downto 0) := "0100001";
constant SEG_E : std_logic_vector(6 downto 0) := "0000110";
constant SEG_F : std_logic_vector(6 downto 0) := "0001110";

begin

process(digit)
begin
case digit is
when "0001" => hex_out <= seg_1;
when "0010" => hex_out <= seg_2;
when "0011" => hex_out <= seg_3;
when "0100" => hex_out <= seg_4;
when "0101" => hex_out <= seg_5;
when "0110" => hex_out <= seg_6;
when "0111" => hex_out <= seg_7;
when "1000" => hex_out <= seg_8;
when "1001" => hex_out <= seg_9;
when "1010" => hex_out <= seg_a;
when "1011" => hex_out <= seg_b;
when "1100" => hex_out <= seg_c;
when "1101" => hex_out <= seg_d;
when "1110" => hex_out <= seg_e;
when "1111" => hex_out <= seg_f;
when others => hex_out <= seg_8;
end case;
end process;

end rtl;