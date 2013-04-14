library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sram_controller_tb is
end sram_controller_tb;

architecture tb of sram_controller_tb is
	signal clk    : std_logic := '0';
	
	  signal SRAM_ADDR_out : STD_LOGIC_VECTOR (17 DOWNTO 0);
	  signal SRAM_CE_N_out : STD_LOGIC;
	  signal SRAM_DQ_inout : STD_LOGIC_VECTOR (15 DOWNTO 0);
	  signal SRAM_OE_N_out : STD_LOGIC;
	  signal SRAM_WE_N_out : STD_LOGIC;

	  	  --sd
		signal sd_readdata 	: std_logic_vector(15 downto 0);
		signal sd_writedata 	: std_logic_vector(15 downto 0);
		signal sd_addr 			: std_logic_vector(17 downto 0);
		signal sd_write 		: std_logic;
		signal sd_req 			: std_logic;
		signal sd_ack			: std_logic;
		
		-- fft
		signal fft_readdata 	: std_logic_vector(15 downto 0);
		signal fft_writedata 	: std_logic_vector(15 downto 0);
		signal fft_addr 		: std_logic_vector(17 downto 0);
		signal fft_write 		: std_logic;
		signal fft_req 			: std_logic;
		signal fft_ack			: std_logic;

	--signal key    : std_logic_vector(3 downto 0);
	--signal hex4, hex5, hex6 : std_logic_vector(6 downto 0) ;
	--signal a      : unsigned(3 downto 0);
	--signal do : unsigned(7 downto 0);
	--signal we     : std_logic := '0';
	
begin

clk <= not clk after 10 ns;
process
begin
	sd_write <= '1';
		
	wait for 200000000 ns;
	key <= "0111"; 
	wait for 200000000 ns;
	key <= "1011"; 
	wait for 200000000 ns;
	key <= "1111"; 
	wait for 200000000 ns;
	key <= "1110"; 
	wait for 200000000 ns;
	key <= "1101"; 
	wait;
end process;

uut : entity work.sram_controller
port map ( 
		   clk          => clk,
			
			SRAM_ADDR_out => SRAM_ADDR_out,
			SRAM_CE_N_out => SRAM_CE_N_out,
			SRAM_DQ_inout => SRAM_DQ_inout,
			SRAM_WE_N_out => SRAM_WE_N_out,
			
         sd_readdata  => sd_readdata,  	
			sd_writedata => sd_writedata,
			sd_addr      => sd_addr,			
			sd_write 	 => sd_write,	
			sd_req 	    => sd_req,		
	    	sd_ack 		 => sd_ack,
		
		-- fft
			fft_readdata  => fft_readdata,
			fft_writedata => fft_writedata,
			fft_addr      => fft_addr,
			fft_write     => fft_write,
			fft_req       => fft_req,
			fft_ack	     => fft_ack		
           --do  => do
		     --a => a, 
			  --di => di,
			  --do => do, 
			  
			  );
end tb;