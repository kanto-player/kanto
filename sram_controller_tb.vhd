library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sram_controller_tb is
end sram_controller_tb;

architecture tb of sram_controller_tb is
	
	  signal SRAM_ADDR_out : STD_LOGIC_VECTOR (17 DOWNTO 0);
	  signal SRAM_CE_N_out : STD_LOGIC;
	  signal SRAM_DQ_inout : STD_LOGIC_VECTOR (15 DOWNTO 0);
	  signal SRAM_OE_N_out : STD_LOGIC;
	  signal SRAM_WE_N_out : STD_LOGIC;

		signal clk : std_logic := '0';
		signal reset : std_logic := '0';

	  --sd
		signal sd_readdata 	:  std_logic_vector(15 downto 0);
		signal sd_writedata 	:  std_logic_vector(15 downto 0);
		signal sd_addr 			:  std_logic_vector(17 downto 0);
		signal sd_write 		:  std_logic;
		signal sd_req 			:  std_logic;
		signal sd_ack			:  std_logic;
		
		-- fft
		signal fft_readdata 	:  std_logic_vector(15 downto 0);
		signal fft_writedata 	:  std_logic_vector(15 downto 0);
		signal fft_addr 		:  std_logic_vector(17 downto 0);
		signal fft_write 		:  std_logic;
		signal fft_req 			:  std_logic;
		signal fft_ack			:  std_logic;
		
		-- ab
		signal ab_readdata 	:  std_logic_vector(15 downto 0);
		signal ab_writedata 	:  std_logic_vector(15 downto 0);
		signal ab_addr 			:  std_logic_vector(17 downto 0);
		signal ab_write 		:  std_logic;
		signal ab_req 			:  std_logic;
		signal ab_ack			:  std_logic;
		
		-- viz
		signal viz_readdata 	:  std_logic_vector(15 downto 0);
		signal viz_writedata 	:  std_logic_vector(15 downto 0);
		signal viz_addr 			:  std_logic_vector(17 downto 0);
		signal viz_write 		:  std_logic;
		signal viz_req 			:  std_logic;
		signal viz_ack			:  std_logic;	

	--signal key    : std_logic_vector(3 downto 0);
	--signal hex4, hex5, hex6 : std_logic_vector(6 downto 0) ;
	--signal a      : unsigned(3 downto 0);
	--signal do : unsigned(7 downto 0);
	--signal we     : std_logic := '0';
	
begin

clk <= not clk after 10 ns;
process
begin
	-- sd read
	sd_write <= '1';
	sd_req <= '1';
	sd_addr <= "000100101010110100";
	sd_writedata <= "1111000011110000";
	wait for 50 ns;
	sd_req <= '0';
	wait for 100 ns;
	
	-- sd write
	sd_write <= '0';
	sd_req <= '1';
	sd_writedata <= (others => '0');
	sd_addr <= "110100111110100101";
	wait for 50 ns;
	sd_req <= '0';
	wait for 100 ns;
	
	-- fft read
	fft_write <= '1';
	fft_req <= '1';
	fft_addr <= "000100101010110100";
	fft_writedata <= "1011110100101110";
	wait for 50 ns;
	fft_req <= '0';
	wait for 100 ns;
	
	-- fft write
	fft_write <= '0';
	fft_req <= '1';
	fft_addr <= "110100111110100101";
	fft_writedata <= (others => '0');
	wait for 50 ns;
	fft_req <= '0';
	wait for 100 ns;
	
	-- ab read
	ab_write <= '1';
	ab_req <= '1';
	ab_addr <= "000100101010110100";
	ab_writedata <= "1111000011110000";
	wait for 50 ns;
	ab_req <= '0';
	wait for 100 ns;
	
	-- ab write
	ab_write <= '0';
	ab_req <= '1';
	ab_addr <= "110100111110100101";
	ab_writedata <= (others => '0');
	wait for 50 ns;
	ab_req <= '0';
	wait for 100 ns;	
	
	-- viz read
	viz_write <= '1';
	viz_req <= '1';
	viz_addr <= "000100101010110100";
	viz_writedata <= "1011110100101110";
	wait for 50 ns;
	viz_req <= '0';
	wait for 100 ns;
	
	-- viz write
	viz_write <= '0';
	viz_req <= '1';
	viz_addr <= "110100111110100101";
	viz_writedata <= (others => '0');
	wait for 50 ns;
	viz_req <= '0';
	wait for 100 ns;	
	
	-- then we have some intersections!!
	
	fft_write <= '1';
	fft_req <= '1';
	fft_addr <= "110100111110100101";
	fft_writedata <= (others => '0');	
	sd_write <= '1';
	sd_req <= '1';
	sd_addr <= "110111100001100000";
	sd_writedata <= (others => '0');
	wait for 50 ns;
	sd_req <= '0';
	fft_req <= '0';
	
		-- ab read
	ab_write <= '1';
	ab_req <= '1';
	ab_addr <= "000100101010110100";
	ab_writedata <= "1111000011110000";
	wait for 50 ns;
	ab_req <= '0';
	wait for 100 ns;
	
	-- ab write
	ab_write <= '0';
	ab_req <= '1';
	ab_addr <= "110100111110100101";
	ab_writedata <= (others => '0');
	wait for 50 ns;
	ab_req <= '0';
	wait for 100 ns;	

		-- fft read
	fft_write <= '1';
	fft_req <= '1';
	fft_addr <= "000100101010110100";
	fft_writedata <= "1011110100101110";
	wait for 50 ns;
	fft_req <= '0';
	wait for 100 ns;
	
	-- fft write
	fft_write <= '0';
	fft_req <= '1';
	fft_addr <= "110100111110100101";
	fft_writedata <= (others => '0');
	wait for 50 ns;
	fft_req <= '0';
	wait for 100 ns;
	
	-- sd read
	sd_write <= '1';
	sd_req <= '1';
	sd_addr <= "000100101010110100";
	sd_writedata <= "1111000011110000";
	wait for 50 ns;
	sd_req <= '0';
	wait for 100 ns;
	
	-- sd write
	sd_write <= '0';
	sd_req <= '1';
	sd_writedata <= (others => '0');
	sd_addr <= "110100111110100101";
	wait for 50 ns;
	sd_req <= '0';
	wait for 100 ns;
	
end process;

uut : entity work.sram_controller
port map ( 
		   clk          => clk,
			reset => reset,
			
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
			fft_ack	     => fft_ack,	
		
			ab_readdata => ab_readdata,
		ab_writedata => ab_writedata,
		ab_addr => ab_addr,
		ab_write => ab_write,
		ab_ack => ab_ack,
		ab_req => ab_req,
		
		viz_readdata => viz_readdata,
		viz_writedata => viz_writedata,
		viz_addr => viz_addr,
		viz_write => viz_write,
		viz_ack => viz_ack,
		viz_req => viz_req
	
           --do  => do
		     --a => a, 
			  --di => di,
			  --do => do, 
			  
			  );
end tb;