library ieee;
use ieee.std_logic_1164.all;

entity sram_controller is

	port(
		clk, reset : in std_logic;
		
	  SRAM_ADDR_out : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
	  SRAM_CE_N_out : OUT STD_LOGIC;
	  SRAM_DQ_inout : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
	  SRAM_OE_N_out : OUT STD_LOGIC;
	  SRAM_WE_N_out : OUT STD_LOGIC;

	  --sd
		sd_readdata 	: out std_logic_vector(15 downto 0);
		sd_writedata 	: in std_logic_vector(15 downto 0);
		sd_addr 			: in std_logic_vector(17 downto 0);
		sd_write 		: in std_logic;
		sd_req 			: in std_logic;
		sd_ack			: out std_logic;
		
		-- fft
		fft_readdata 	: out std_logic_vector(15 downto 0);
		fft_writedata 	: in std_logic_vector(15 downto 0);
		fft_addr 		: in std_logic_vector(17 downto 0);
		fft_write 		: in std_logic;
		fft_req 			: in std_logic;
		fft_ack			: out std_logic;
		
		-- ab
		ab_readdata 	: out std_logic_vector(15 downto 0);
		ab_writedata 	: in std_logic_vector(15 downto 0);
		ab_addr 			: in std_logic_vector(17 downto 0);
		ab_write 		: in std_logic;
		ab_req 			: in std_logic;
		ab_ack			: out std_logic;
		
		-- viz
		viz_readdata 	: out std_logic_vector(15 downto 0);
		viz_writedata 	: in std_logic_vector(15 downto 0);
		viz_addr 			: in std_logic_vector(17 downto 0);
		viz_write 		: in std_logic;
		viz_req 			: in std_logic;
		viz_ack			: out std_logic		
	);
end sram_controller;

architecture moore of sram_controller is
	type states is (ZERO, 
						SD_1, SD_2, SD_3,
						AB_1, AB_2, AB_3,
						FFT_1, FFT_2, FFT_3,
						VIZ_1, VIZ_2, VIZ_3);
begin
	process (clk)
	variable state : states;
	begin
		SRAM_CE_N_out <= '0';
		SRAM_OE_N_out <= '0';
		if rising_edge(clk) then
			if reset = '1' then state := ZERO;
			else case state is
				when ZERO =>
					if sd_req = '1' then state := SD_1;
					elsif ab_req = '1' then state := AB_1;
					elsif fft_req = '1' then state := FFT_1;
					elsif viz_req = '1' then state := VIZ_1;
					else state := ZERO;
					end if;
					
				-- SD REQ AREA --	
				when SD_1 =>
					sd_ack <= '1';
					SRAM_WE_N_out <= NOT sd_write;
					SRAM_ADDR_out <= sd_addr;
					state := SD_2;
					
				when SD_2 => -- push or pull data from dq line
					if sd_write = '1' then SRAM_DQ_inout <= sd_writedata;
					else sd_readdata <= SRAM_DQ_inout;
					end if;
					state := SD_3;
					
				when SD_3 =>  -- waiting for sd_req to go low --
					if sd_req = '0' then
						sd_ack <= '0';
						state := ZERO;
					else state := SD_3;
					end if;
					
				-- AB REQ AREA --	
				when AB_1 =>
					ab_ack <= '1';
					SRAM_WE_N_out <= NOT ab_write;
					SRAM_ADDR_out <= ab_addr;
					state := AB_2;
					
				when AB_2 => -- push or pull data from dq line
					if ab_write = '1' then SRAM_DQ_inout <= ab_writedata;
					else ab_readdata <= SRAM_DQ_inout;
					end if;
					state := AB_3;
					
				when AB_3 =>  -- waiting for ab_req to go low --
					if ab_req = '0' then
						ab_ack <= '0';
						state := ZERO;
					else state := AB_3;
					end if;
							
				-- FFT REQ AREA --	
				when FFT_1 =>
					fft_ack <= '1';
					SRAM_WE_N_out <= NOT fft_write;
					SRAM_ADDR_out <= fft_addr;
					state := FFT_2;
					
				when FFT_2 => -- push or pull data from dq line
					if fft_write = '1' then SRAM_DQ_inout <= fft_writedata;
					else fft_readdata <= SRAM_DQ_inout;
					end if;
					state := FFT_3;

					
				when FFT_3 =>  -- waiting for fft_req to go low --
					if fft_req = '0' then
						fft_ack <= '0';
						state := ZERO;
					else state := FFT_3;
					end if;
					
				-- VIZ REQ AREA --	
				when VIZ_1 =>
					viz_ack <= '1';
					SRAM_WE_N_out <= NOT viz_write;
					SRAM_ADDR_out <= viz_addr;
					state := VIZ_2;
					
				when VIZ_2 => -- push or pull data from dq line
					if viz_write = '1' then SRAM_DQ_inout <= viz_writedata;
					else viz_readdata <= SRAM_DQ_inout;
					end if;
					state := VIZ_3;
					
				when VIZ_3 =>  -- waiting for viz_req to go low --
					if viz_req = '0' then
						viz_ack <= '0';
						state := ZERO;
					else state := VIZ_3;
					end if;	

		
				end case;
			end if;
		end if;
	end process;
	
end moore;
