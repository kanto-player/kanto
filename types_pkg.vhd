package types_pkg is
    type complex_signed_array is array (0 to 15) of signed(35 downto 0);
    type real_signed_array is array(0 to 15) of signed(17 downto 0);
    type byte_array is array(0 to 15) of unsigned(7 downto 0);
end package;
