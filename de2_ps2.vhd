
--
-- Simple (receive-only) PS/2 controller for the Altera Avalon bus
--
-- Presents a two-word interface:
--
-- Byte 0: LSB is a status bit: 1 = data received, 0 = no new data
-- Byte 4: least significant byte is received data,
--         reading it clears the input register
--
-- Make sure "Slave addressing" in the interfaces tab of SOPC Builder's
-- "New Component" dialog is set to "Register" mode.
--
--
-- Stephen A. Edwards and Yingjian Gu
-- Columbia University, sedwards@cs.columbia.edu
--
-- From an original by Bert Cuzeau
-- (c) ALSE. http://www.alse-fr.com
--
----------------------------------------------------------------------

-- ------------------------------------------------
--   Simplified PS/2 Controller  (kbd, mouse...)
-- ------------------------------------------------
-- Only the Receive function is implemented !
-- (c) ALSE. http://www.alse-fr.com
-- Author : Bert Cuzeau.
-- Fully synchronous solution, same Filter on PS2_Clk.
-- Still as compact as "Plain_wrong"...
-- Possible improvement : add TIMEOUT on PS2_Clk while shifting
-- Note: PS2_Data is resynchronized though this should not be
-- necessary (qualified by Fall_Clk and does not change at that time).
-- Note the tricks to correctly interpret 'H' as '1' in RTL simulation.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PS2_Ctrl is
  port(
    Clk       : in  std_logic;  -- System Clock
    Reset     : in  std_logic;  -- System Reset
    PS2_Clk   : in  std_logic;  -- Keyboard Clock Line
    PS2_Data  : in  std_logic;  -- Keyboard Data Line
    DoRead    : in  std_logic;  -- From outside when reading the scan code
    Scan_Err  : out std_logic;  -- To outside : Parity or Overflow error
    Scan_DAV  : out std_logic;  -- To outside when a scan code has arrived
    Scan_Code : out unsigned(7 downto 0) -- Eight bits Data Out
    );
end PS2_Ctrl;

architecture rtl of PS2_Ctrl is

  signal PS2_Datr  : std_logic;

  subtype Filter_t is unsigned(7 downto 0);
  signal Filter    : Filter_t;
  signal Fall_Clk  : std_logic;
  signal Bit_Cnt   : unsigned (3 downto 0);
  signal Parity    : std_logic;
  signal Scan_DAVi : std_logic;

  signal S_Reg     : unsigned(8 downto 0);

  signal PS2_Clk_f : std_logic;

  Type   State_t is (Idle, Shifting);
  signal State : State_t;

begin

  Scan_DAV <= Scan_DAVi;

-- This filters digitally the raw clock signal coming from the keyboard :
--  * Eight consecutive PS2_Clk=1 makes the filtered_clock go high
--  * Eight consecutive PS2_Clk=0 makes the filtered_clock go low
-- Implies a (FilterSize+1) x Tsys_clock delay on Fall_Clk wrt Data
-- Also in charge of the re-synchronization of PS2_Data

  process (Clk)
  begin
    if rising_edge(Clk) then   
      if Reset = '1' then
        PS2_Datr  <= '0';
        PS2_Clk_f <= '0';
        Filter    <= (others => '0');
        Fall_Clk  <= '0';
      else
        PS2_Datr <= PS2_Data and PS2_Data; -- also turns 'H' into '1'
        Fall_Clk <= '0';
        Filter   <= (PS2_Clk and PS2_CLK) & Filter(Filter'high downto 1);
        if Filter = Filter_t'(others=>'1') then
          PS2_Clk_f <= '1';
        elsif Filter = Filter_t'(others=>'0') then
          PS2_Clk_f <= '0';
          if PS2_Clk_f = '1' then
            Fall_Clk <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;

-- This simple State Machine reads in the Serial Data
-- coming from the PS/2 peripheral.

  process(Clk)
  begin
    if rising_edge(Clk) then   
      if Reset = '1' then
        State     <= Idle;
        Bit_Cnt   <= (others => '0');
        S_Reg     <= (others => '0');
        Scan_Code <= (others => '0');
        Parity    <= '0';
        Scan_DAVi <= '0';
        Scan_Err  <= '0';
      else
        
        if DoRead = '1' then
          Scan_DAVi <= '0'; -- note: this assgnmnt can be overriden
        end if;

        case State is

          when Idle =>
            Parity  <= '0';
            Bit_Cnt <= (others => '0');
            -- note that we do not need to clear the Shift Register
            if Fall_Clk='1' and PS2_Datr='0' then -- Start bit
              Scan_Err <= '0';
              State <= Shifting;
            end if;

          when Shifting =>
            if Bit_Cnt >= 9 then
              if Fall_Clk = '1' then -- Stop Bit
                -- Error is (wrong Parity) or (Stop='0') or Overflow
                Scan_Err  <= (not Parity) or (not PS2_Datr) or Scan_DAVi;
                Scan_Davi <= '1';
                Scan_Code <= S_Reg(7 downto 0);
                State <= Idle;
              end if;
            elsif Fall_Clk = '1' then
              Bit_Cnt <= Bit_Cnt + 1;
              S_Reg <= PS2_Datr & S_Reg (S_Reg'high downto 1); -- Shift right
              Parity <= Parity xor PS2_Datr;
            end if;

          when others => -- never reached
            State <= Idle;

        end case;
        
        --Scan_Err <= '0'; -- to create a deliberate error

      end if;

    end if;

  end process;

end rtl;

-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity de2_ps2 is

  port (
    avs_s1_clk        : in std_logic;
    avs_s1_reset      : in std_logic;
    avs_s1_address    : in std_logic_vector(2 downto 0);
    avs_s1_read       : in std_logic;
    avs_s1_chipselect : in std_logic;
    avs_s1_readdata   : out std_logic_vector(7 downto 0);
    
    PS2_Clk           : in std_logic;
    PS2_Data          : in std_logic
    );  
end de2_ps2;

architecture rtl of de2_ps2 is

  signal Data          : unsigned(7 downto 0);
  signal DataAvailable : std_logic;
  signal DoRead        : std_logic;

begin
  
  U1: entity work.PS2_CTRL port map(
    Clk       => avs_s1_clk,
    Reset     => avs_s1_reset,
    DoRead    => DoRead,
    PS2_Clk   => PS2_Clk,
    PS2_Data  => PS2_Data,
    Scan_Code => Data,
    Scan_DAV  => DataAvailable );

  process (avs_s1_clk)
  begin
    if rising_edge(avs_s1_clk) then
      DoRead <= avs_s1_read and avs_s1_chipselect and avs_s1_address(0);      
    end if;  
  end process;
  
  process (Data, DataAvailable, avs_s1_address, avs_s1_chipselect)
  begin
    if avs_s1_chipselect = '1' then 
      if avs_s1_address(2) = '1' then 
        avs_s1_readdata <= std_logic_vector(Data);
      else
        avs_s1_readdata <= "0000000" & DataAvailable;
      end if;	
    else 
      avs_s1_readdata <= "00000000";
    end if;
  end process;

end rtl;
