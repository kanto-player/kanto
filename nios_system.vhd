--megafunction wizard: %Altera SOPC Builder%
--GENERATION: STANDARD
--VERSION: WM1.0


--Legal Notice: (C)2013 Altera Corporation. All rights reserved.  Your
--use of Altera Corporation's design tools, logic functions and other
--software and tools, and its AMPP partner logic functions, and any
--output files any of the foregoing (including device programming or
--simulation files), and any associated documentation or information are
--expressly subject to the terms and conditions of the Altera Program
--License Subscription Agreement or other applicable license agreement,
--including, without limitation, that your use is for the sole purpose
--of programming logic devices manufactured by Altera and sold by Altera
--or its authorized distributors.  Please refer to the applicable
--agreement for further details.


-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity cpu_0_jtag_debug_module_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_0_data_master_debugaccess : IN STD_LOGIC;
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_0_instruction_master_read : IN STD_LOGIC;
                 signal cpu_0_jtag_debug_module_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_jtag_debug_module_resetrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_granted_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_requests_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_address : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                 signal cpu_0_jtag_debug_module_begintransfer : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_0_jtag_debug_module_chipselect : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_debugaccess : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_jtag_debug_module_reset_n : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_resetrequest_from_sa : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_write : OUT STD_LOGIC;
                 signal cpu_0_jtag_debug_module_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_cpu_0_jtag_debug_module_end_xfer : OUT STD_LOGIC
              );
end entity cpu_0_jtag_debug_module_arbitrator;


architecture europa of cpu_0_jtag_debug_module_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_instruction_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_instruction_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_instruction_master_continuerequest :  STD_LOGIC;
                signal cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_allgrants :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_allow_new_arb_cycle :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_any_bursting_master_saved_grant :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_any_continuerequest :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_arb_addend :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_arb_counter_enable :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_arb_share_counter :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal cpu_0_jtag_debug_module_arb_share_counter_next_value :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal cpu_0_jtag_debug_module_arb_share_set_values :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal cpu_0_jtag_debug_module_arb_winner :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_arbitration_holdoff_internal :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_beginbursttransfer_internal :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_begins_xfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_chosen_master_double_vector :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_0_jtag_debug_module_chosen_master_rot_left :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_end_xfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_firsttransfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_grant_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_in_a_read_cycle :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_in_a_write_cycle :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_master_qreq_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_non_bursting_master_requests :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_reg_firsttransfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_saved_chosen_master_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_jtag_debug_module_slavearbiterlockenable :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_slavearbiterlockenable2 :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_unreg_firsttransfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_waits_for_read :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_waits_for_write :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal wait_for_cpu_0_jtag_debug_module_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT cpu_0_jtag_debug_module_end_xfer;
    end if;

  end process;

  cpu_0_jtag_debug_module_begins_xfer <= NOT d1_reasons_to_wait AND ((internal_cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module OR internal_cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module));
  --assign cpu_0_jtag_debug_module_readdata_from_sa = cpu_0_jtag_debug_module_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  cpu_0_jtag_debug_module_readdata_from_sa <= cpu_0_jtag_debug_module_readdata;
  internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(20 DOWNTO 11) & std_logic_vector'("00000000000")) = std_logic_vector'("100000000100000000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --cpu_0_jtag_debug_module_arb_share_counter set values, which is an e_mux
  cpu_0_jtag_debug_module_arb_share_set_values <= std_logic_vector'("001");
  --cpu_0_jtag_debug_module_non_bursting_master_requests mux, which is an e_mux
  cpu_0_jtag_debug_module_non_bursting_master_requests <= ((internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module OR internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module) OR internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module) OR internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  --cpu_0_jtag_debug_module_any_bursting_master_saved_grant mux, which is an e_mux
  cpu_0_jtag_debug_module_any_bursting_master_saved_grant <= std_logic'('0');
  --cpu_0_jtag_debug_module_arb_share_counter_next_value assignment, which is an e_assign
  cpu_0_jtag_debug_module_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(cpu_0_jtag_debug_module_firsttransfer) = '1'), (((std_logic_vector'("000000000000000000000000000000") & (cpu_0_jtag_debug_module_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(cpu_0_jtag_debug_module_arb_share_counter)) = '1'), (((std_logic_vector'("000000000000000000000000000000") & (cpu_0_jtag_debug_module_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 3);
  --cpu_0_jtag_debug_module_allgrants all slave grants, which is an e_mux
  cpu_0_jtag_debug_module_allgrants <= (((or_reduce(cpu_0_jtag_debug_module_grant_vector)) OR (or_reduce(cpu_0_jtag_debug_module_grant_vector))) OR (or_reduce(cpu_0_jtag_debug_module_grant_vector))) OR (or_reduce(cpu_0_jtag_debug_module_grant_vector));
  --cpu_0_jtag_debug_module_end_xfer assignment, which is an e_assign
  cpu_0_jtag_debug_module_end_xfer <= NOT ((cpu_0_jtag_debug_module_waits_for_read OR cpu_0_jtag_debug_module_waits_for_write));
  --end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module <= cpu_0_jtag_debug_module_end_xfer AND (((NOT cpu_0_jtag_debug_module_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --cpu_0_jtag_debug_module_arb_share_counter arbitration counter enable, which is an e_assign
  cpu_0_jtag_debug_module_arb_counter_enable <= ((end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module AND cpu_0_jtag_debug_module_allgrants)) OR ((end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module AND NOT cpu_0_jtag_debug_module_non_bursting_master_requests));
  --cpu_0_jtag_debug_module_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_jtag_debug_module_arb_share_counter <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_0_jtag_debug_module_arb_counter_enable) = '1' then 
        cpu_0_jtag_debug_module_arb_share_counter <= cpu_0_jtag_debug_module_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu_0_jtag_debug_module_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_jtag_debug_module_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((or_reduce(cpu_0_jtag_debug_module_master_qreq_vector) AND end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module)) OR ((end_xfer_arb_share_counter_term_cpu_0_jtag_debug_module AND NOT cpu_0_jtag_debug_module_non_bursting_master_requests)))) = '1' then 
        cpu_0_jtag_debug_module_slavearbiterlockenable <= or_reduce(cpu_0_jtag_debug_module_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master cpu_0/jtag_debug_module arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= cpu_0_jtag_debug_module_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --cpu_0_jtag_debug_module_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  cpu_0_jtag_debug_module_slavearbiterlockenable2 <= or_reduce(cpu_0_jtag_debug_module_arb_share_counter_next_value);
  --cpu_0/data_master cpu_0/jtag_debug_module arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= cpu_0_jtag_debug_module_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --cpu_0/instruction_master cpu_0/jtag_debug_module arbiterlock, which is an e_assign
  cpu_0_instruction_master_arbiterlock <= cpu_0_jtag_debug_module_slavearbiterlockenable AND cpu_0_instruction_master_continuerequest;
  --cpu_0/instruction_master cpu_0/jtag_debug_module arbiterlock2, which is an e_assign
  cpu_0_instruction_master_arbiterlock2 <= cpu_0_jtag_debug_module_slavearbiterlockenable2 AND cpu_0_instruction_master_continuerequest;
  --cpu_0/instruction_master granted cpu_0/jtag_debug_module last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((cpu_0_jtag_debug_module_arbitration_holdoff_internal OR NOT internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module))))));
    end if;

  end process;

  --cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  cpu_0_instruction_master_continuerequest <= last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module AND internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  --cpu_0_jtag_debug_module_any_continuerequest at least one master continues requesting, which is an e_mux
  cpu_0_jtag_debug_module_any_continuerequest <= cpu_0_instruction_master_continuerequest OR cpu_0_data_master_continuerequest;
  internal_cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module <= internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module AND NOT (((((NOT cpu_0_data_master_waitrequest) AND cpu_0_data_master_write)) OR cpu_0_instruction_master_arbiterlock));
  --cpu_0_jtag_debug_module_writedata mux, which is an e_mux
  cpu_0_jtag_debug_module_writedata <= cpu_0_data_master_writedata;
  internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module <= ((to_std_logic(((Std_Logic_Vector'(cpu_0_instruction_master_address_to_slave(20 DOWNTO 11) & std_logic_vector'("00000000000")) = std_logic_vector'("100000000100000000000")))) AND (cpu_0_instruction_master_read))) AND cpu_0_instruction_master_read;
  --cpu_0/data_master granted cpu_0/jtag_debug_module last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((cpu_0_jtag_debug_module_arbitration_holdoff_internal OR NOT internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module))))));
    end if;

  end process;

  --cpu_0_data_master_continuerequest continued request, which is an e_mux
  cpu_0_data_master_continuerequest <= last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module AND internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  internal_cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module <= internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module AND NOT (cpu_0_data_master_arbiterlock);
  --allow new arb cycle for cpu_0/jtag_debug_module, which is an e_assign
  cpu_0_jtag_debug_module_allow_new_arb_cycle <= NOT cpu_0_data_master_arbiterlock AND NOT cpu_0_instruction_master_arbiterlock;
  --cpu_0/instruction_master assignment into master qualified-requests vector for cpu_0/jtag_debug_module, which is an e_assign
  cpu_0_jtag_debug_module_master_qreq_vector(0) <= internal_cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  --cpu_0/instruction_master grant cpu_0/jtag_debug_module, which is an e_assign
  internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module <= cpu_0_jtag_debug_module_grant_vector(0);
  --cpu_0/instruction_master saved-grant cpu_0/jtag_debug_module, which is an e_assign
  cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module <= cpu_0_jtag_debug_module_arb_winner(0) AND internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  --cpu_0/data_master assignment into master qualified-requests vector for cpu_0/jtag_debug_module, which is an e_assign
  cpu_0_jtag_debug_module_master_qreq_vector(1) <= internal_cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  --cpu_0/data_master grant cpu_0/jtag_debug_module, which is an e_assign
  internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module <= cpu_0_jtag_debug_module_grant_vector(1);
  --cpu_0/data_master saved-grant cpu_0/jtag_debug_module, which is an e_assign
  cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module <= cpu_0_jtag_debug_module_arb_winner(1) AND internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  --cpu_0/jtag_debug_module chosen-master double-vector, which is an e_assign
  cpu_0_jtag_debug_module_chosen_master_double_vector <= A_EXT (((std_logic_vector'("0") & ((cpu_0_jtag_debug_module_master_qreq_vector & cpu_0_jtag_debug_module_master_qreq_vector))) AND (((std_logic_vector'("0") & (Std_Logic_Vector'(NOT cpu_0_jtag_debug_module_master_qreq_vector & NOT cpu_0_jtag_debug_module_master_qreq_vector))) + (std_logic_vector'("000") & (cpu_0_jtag_debug_module_arb_addend))))), 4);
  --stable onehot encoding of arb winner
  cpu_0_jtag_debug_module_arb_winner <= A_WE_StdLogicVector((std_logic'(((cpu_0_jtag_debug_module_allow_new_arb_cycle AND or_reduce(cpu_0_jtag_debug_module_grant_vector)))) = '1'), cpu_0_jtag_debug_module_grant_vector, cpu_0_jtag_debug_module_saved_chosen_master_vector);
  --saved cpu_0_jtag_debug_module_grant_vector, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_jtag_debug_module_saved_chosen_master_vector <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_0_jtag_debug_module_allow_new_arb_cycle) = '1' then 
        cpu_0_jtag_debug_module_saved_chosen_master_vector <= A_WE_StdLogicVector((std_logic'(or_reduce(cpu_0_jtag_debug_module_grant_vector)) = '1'), cpu_0_jtag_debug_module_grant_vector, cpu_0_jtag_debug_module_saved_chosen_master_vector);
      end if;
    end if;

  end process;

  --onehot encoding of chosen master
  cpu_0_jtag_debug_module_grant_vector <= Std_Logic_Vector'(A_ToStdLogicVector(((cpu_0_jtag_debug_module_chosen_master_double_vector(1) OR cpu_0_jtag_debug_module_chosen_master_double_vector(3)))) & A_ToStdLogicVector(((cpu_0_jtag_debug_module_chosen_master_double_vector(0) OR cpu_0_jtag_debug_module_chosen_master_double_vector(2)))));
  --cpu_0/jtag_debug_module chosen master rotated left, which is an e_assign
  cpu_0_jtag_debug_module_chosen_master_rot_left <= A_EXT (A_WE_StdLogicVector((((A_SLL(cpu_0_jtag_debug_module_arb_winner,std_logic_vector'("00000000000000000000000000000001")))) /= std_logic_vector'("00")), (std_logic_vector'("000000000000000000000000000000") & ((A_SLL(cpu_0_jtag_debug_module_arb_winner,std_logic_vector'("00000000000000000000000000000001"))))), std_logic_vector'("00000000000000000000000000000001")), 2);
  --cpu_0/jtag_debug_module's addend for next-master-grant
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_jtag_debug_module_arb_addend <= std_logic_vector'("01");
    elsif clk'event and clk = '1' then
      if std_logic'(or_reduce(cpu_0_jtag_debug_module_grant_vector)) = '1' then 
        cpu_0_jtag_debug_module_arb_addend <= A_WE_StdLogicVector((std_logic'(cpu_0_jtag_debug_module_end_xfer) = '1'), cpu_0_jtag_debug_module_chosen_master_rot_left, cpu_0_jtag_debug_module_grant_vector);
      end if;
    end if;

  end process;

  cpu_0_jtag_debug_module_begintransfer <= cpu_0_jtag_debug_module_begins_xfer;
  --cpu_0_jtag_debug_module_reset_n assignment, which is an e_assign
  cpu_0_jtag_debug_module_reset_n <= reset_n;
  --assign cpu_0_jtag_debug_module_resetrequest_from_sa = cpu_0_jtag_debug_module_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  cpu_0_jtag_debug_module_resetrequest_from_sa <= cpu_0_jtag_debug_module_resetrequest;
  cpu_0_jtag_debug_module_chipselect <= internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module OR internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  --cpu_0_jtag_debug_module_firsttransfer first transaction, which is an e_assign
  cpu_0_jtag_debug_module_firsttransfer <= A_WE_StdLogic((std_logic'(cpu_0_jtag_debug_module_begins_xfer) = '1'), cpu_0_jtag_debug_module_unreg_firsttransfer, cpu_0_jtag_debug_module_reg_firsttransfer);
  --cpu_0_jtag_debug_module_unreg_firsttransfer first transaction, which is an e_assign
  cpu_0_jtag_debug_module_unreg_firsttransfer <= NOT ((cpu_0_jtag_debug_module_slavearbiterlockenable AND cpu_0_jtag_debug_module_any_continuerequest));
  --cpu_0_jtag_debug_module_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_0_jtag_debug_module_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_0_jtag_debug_module_begins_xfer) = '1' then 
        cpu_0_jtag_debug_module_reg_firsttransfer <= cpu_0_jtag_debug_module_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --cpu_0_jtag_debug_module_beginbursttransfer_internal begin burst transfer, which is an e_assign
  cpu_0_jtag_debug_module_beginbursttransfer_internal <= cpu_0_jtag_debug_module_begins_xfer;
  --cpu_0_jtag_debug_module_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  cpu_0_jtag_debug_module_arbitration_holdoff_internal <= cpu_0_jtag_debug_module_begins_xfer AND cpu_0_jtag_debug_module_firsttransfer;
  --cpu_0_jtag_debug_module_write assignment, which is an e_mux
  cpu_0_jtag_debug_module_write <= internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module AND cpu_0_data_master_write;
  shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --cpu_0_jtag_debug_module_address mux, which is an e_mux
  cpu_0_jtag_debug_module_address <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module)) = '1'), (A_SRL(shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010"))), (A_SRL(shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master,std_logic_vector'("00000000000000000000000000000010")))), 9);
  shifted_address_to_cpu_0_jtag_debug_module_from_cpu_0_instruction_master <= cpu_0_instruction_master_address_to_slave;
  --d1_cpu_0_jtag_debug_module_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_cpu_0_jtag_debug_module_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_cpu_0_jtag_debug_module_end_xfer <= cpu_0_jtag_debug_module_end_xfer;
    end if;

  end process;

  --cpu_0_jtag_debug_module_waits_for_read in a cycle, which is an e_mux
  cpu_0_jtag_debug_module_waits_for_read <= cpu_0_jtag_debug_module_in_a_read_cycle AND cpu_0_jtag_debug_module_begins_xfer;
  --cpu_0_jtag_debug_module_in_a_read_cycle assignment, which is an e_assign
  cpu_0_jtag_debug_module_in_a_read_cycle <= ((internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module AND cpu_0_data_master_read)) OR ((internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module AND cpu_0_instruction_master_read));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= cpu_0_jtag_debug_module_in_a_read_cycle;
  --cpu_0_jtag_debug_module_waits_for_write in a cycle, which is an e_mux
  cpu_0_jtag_debug_module_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_jtag_debug_module_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --cpu_0_jtag_debug_module_in_a_write_cycle assignment, which is an e_assign
  cpu_0_jtag_debug_module_in_a_write_cycle <= internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= cpu_0_jtag_debug_module_in_a_write_cycle;
  wait_for_cpu_0_jtag_debug_module_counter <= std_logic'('0');
  --cpu_0_jtag_debug_module_byteenable byte enable port mux, which is an e_mux
  cpu_0_jtag_debug_module_byteenable <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module)) = '1'), (std_logic_vector'("0000000000000000000000000000") & (cpu_0_data_master_byteenable)), -SIGNED(std_logic_vector'("00000000000000000000000000000001"))), 4);
  --debugaccess mux, which is an e_mux
  cpu_0_jtag_debug_module_debugaccess <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module)) = '1'), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_debugaccess))), std_logic_vector'("00000000000000000000000000000000")));
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_cpu_0_jtag_debug_module <= internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module <= internal_cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_cpu_0_jtag_debug_module <= internal_cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_granted_cpu_0_jtag_debug_module <= internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module <= internal_cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_requests_cpu_0_jtag_debug_module <= internal_cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
--synthesis translate_off
    --cpu_0/jtag_debug_module enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_0_data_master_granted_cpu_0_jtag_debug_module))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_0_instruction_master_granted_cpu_0_jtag_debug_module))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line, now);
          write(write_line, string'(": "));
          write(write_line, string'("> 1 of grant signals are active simultaneously"));
          write(output, write_line.all);
          deallocate (write_line);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --saved_grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line1 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line1, now);
          write(write_line1, string'(": "));
          write(write_line1, string'("> 1 of saved_grant signals are active simultaneously"));
          write(output, write_line1.all);
          deallocate (write_line1);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cpu_0_data_master_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_0_data_master_byteenable_sram_avalon_slave_0 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_data_master_granted_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_ps2_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_sdbuf_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_sram_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_data_master_granted_vga_vga : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_ps2_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_sdbuf_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_sram_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_vga_vga : IN STD_LOGIC;
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_kanto_ctrl_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_ps2_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdbuf_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sram_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_vga_vga : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_ps2_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_sdbuf_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_sram_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_data_master_requests_vga_vga : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_cpu_0_jtag_debug_module_end_xfer : IN STD_LOGIC;
                 signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer : IN STD_LOGIC;
                 signal d1_kanto_ctrl_avalon_slave_0_end_xfer : IN STD_LOGIC;
                 signal d1_ps2_avalon_slave_0_end_xfer : IN STD_LOGIC;
                 signal d1_sdbuf_avalon_slave_0_end_xfer : IN STD_LOGIC;
                 signal d1_sram_avalon_slave_0_end_xfer : IN STD_LOGIC;
                 signal d1_vga_vga_end_xfer : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_irq_from_sa : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal kanto_ctrl_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal ps2_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal sdbuf_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sram_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal vga_vga_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal cpu_0_data_master_address_to_slave : OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_0_data_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_data_master_dbs_write_16 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal cpu_0_data_master_irq : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_data_master_no_byte_enables_and_last_term : OUT STD_LOGIC;
                 signal cpu_0_data_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_data_master_waitrequest : OUT STD_LOGIC
              );
end entity cpu_0_data_master_arbitrator;


architecture europa of cpu_0_data_master_arbitrator is
                signal cpu_0_data_master_dbs_increment :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_run :  STD_LOGIC;
                signal dbs_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal dbs_8_reg_segment_0 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal dbs_8_reg_segment_1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal dbs_8_reg_segment_2 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal dbs_count_enable :  STD_LOGIC;
                signal dbs_counter_overflow :  STD_LOGIC;
                signal internal_cpu_0_data_master_address_to_slave :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal internal_cpu_0_data_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_cpu_0_data_master_no_byte_enables_and_last_term :  STD_LOGIC;
                signal internal_cpu_0_data_master_waitrequest :  STD_LOGIC;
                signal last_dbs_term_and_run :  STD_LOGIC;
                signal next_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p1_dbs_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal p1_dbs_8_reg_segment_0 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal p1_dbs_8_reg_segment_1 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal p1_dbs_8_reg_segment_2 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal p1_registered_cpu_0_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pre_dbs_count_enable :  STD_LOGIC;
                signal r_0 :  STD_LOGIC;
                signal r_1 :  STD_LOGIC;
                signal registered_cpu_0_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

  --r_0 master_run cascaded wait assignment, which is an e_assign
  r_0 <= Vector_To_Std_Logic((((((((((((((((((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module OR NOT cpu_0_data_master_requests_cpu_0_jtag_debug_module)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_granted_cpu_0_jtag_debug_module OR NOT cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave OR NOT cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave OR NOT ((cpu_0_data_master_read OR cpu_0_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_read OR cpu_0_data_master_write)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave OR NOT ((cpu_0_data_master_read OR cpu_0_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_read OR cpu_0_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0 OR NOT cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0 OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0 OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_ps2_avalon_slave_0 OR NOT cpu_0_data_master_read)))) OR ((((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((internal_cpu_0_data_master_dbs_address(1) AND internal_cpu_0_data_master_dbs_address(0))))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_ps2_avalon_slave_0 OR NOT cpu_0_data_master_write)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((internal_cpu_0_data_master_dbs_address(1) AND internal_cpu_0_data_master_dbs_address(0))))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_sdbuf_avalon_slave_0 OR NOT cpu_0_data_master_read)))) OR ((((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_0_data_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_sdbuf_avalon_slave_0 OR NOT cpu_0_data_master_write)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_0_data_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")));
  --cascaded wait assignment, which is an e_assign
  cpu_0_data_master_run <= r_0 AND r_1;
  --r_1 master_run cascaded wait assignment, which is an e_assign
  r_1 <= Vector_To_Std_Logic((((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((((cpu_0_data_master_qualified_request_sram_avalon_slave_0 OR (((cpu_0_data_master_write AND NOT(or_reduce(cpu_0_data_master_byteenable_sram_avalon_slave_0))) AND internal_cpu_0_data_master_dbs_address(1)))) OR NOT cpu_0_data_master_requests_sram_avalon_slave_0)) AND ((cpu_0_data_master_granted_sram_avalon_slave_0 OR NOT cpu_0_data_master_qualified_request_sram_avalon_slave_0)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_sram_avalon_slave_0 OR NOT cpu_0_data_master_read)))) OR ((((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_0_data_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_sram_avalon_slave_0 OR NOT cpu_0_data_master_write)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_0_data_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_qualified_request_vga_vga OR NOT cpu_0_data_master_requests_vga_vga)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_vga_vga OR NOT cpu_0_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_data_master_qualified_request_vga_vga OR NOT cpu_0_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_write)))))))));
  --optimize select-logic by passing only those address bits which matter.
  internal_cpu_0_data_master_address_to_slave <= cpu_0_data_master_address(20 DOWNTO 0);
  --cpu_0/data_master readdata mux, which is an e_mux
  cpu_0_data_master_readdata <= (((((((A_REP(NOT cpu_0_data_master_requests_cpu_0_jtag_debug_module, 32) OR cpu_0_jtag_debug_module_readdata_from_sa)) AND ((A_REP(NOT cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave, 32) OR registered_cpu_0_data_master_readdata))) AND ((A_REP(NOT cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0, 32) OR kanto_ctrl_avalon_slave_0_readdata_from_sa))) AND ((A_REP(NOT cpu_0_data_master_requests_ps2_avalon_slave_0, 32) OR Std_Logic_Vector'(ps2_avalon_slave_0_readdata_from_sa(7 DOWNTO 0) & dbs_8_reg_segment_2 & dbs_8_reg_segment_1 & dbs_8_reg_segment_0)))) AND ((A_REP(NOT cpu_0_data_master_requests_sdbuf_avalon_slave_0, 32) OR Std_Logic_Vector'(sdbuf_avalon_slave_0_readdata_from_sa(15 DOWNTO 0) & dbs_16_reg_segment_0)))) AND ((A_REP(NOT cpu_0_data_master_requests_sram_avalon_slave_0, 32) OR Std_Logic_Vector'(sram_avalon_slave_0_readdata_from_sa(15 DOWNTO 0) & dbs_16_reg_segment_0)))) AND ((A_REP(NOT cpu_0_data_master_requests_vga_vga, 32) OR vga_vga_readdata_from_sa));
  --actual waitrequest port, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_0_data_master_waitrequest <= Vector_To_Std_Logic(NOT std_logic_vector'("00000000000000000000000000000000"));
    elsif clk'event and clk = '1' then
      internal_cpu_0_data_master_waitrequest <= Vector_To_Std_Logic(NOT (A_WE_StdLogicVector((std_logic'((NOT ((cpu_0_data_master_read OR cpu_0_data_master_write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_data_master_run AND internal_cpu_0_data_master_waitrequest))))))));
    end if;

  end process;

  --unpredictable registered wait state incoming data, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      registered_cpu_0_data_master_readdata <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      registered_cpu_0_data_master_readdata <= p1_registered_cpu_0_data_master_readdata;
    end if;

  end process;

  --registered readdata mux, which is an e_mux
  p1_registered_cpu_0_data_master_readdata <= A_REP(NOT cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave, 32) OR jtag_uart_0_avalon_jtag_slave_readdata_from_sa;
  --irq assign, which is an e_assign
  cpu_0_data_master_irq <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(jtag_uart_0_avalon_jtag_slave_irq_from_sa));
  --input to dbs-8 stored 0, which is an e_mux
  p1_dbs_8_reg_segment_0 <= ps2_avalon_slave_0_readdata_from_sa;
  --dbs register for dbs-8 segment 0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dbs_8_reg_segment_0 <= std_logic_vector'("00000000");
    elsif clk'event and clk = '1' then
      if std_logic'((dbs_count_enable AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & ((internal_cpu_0_data_master_dbs_address(1 DOWNTO 0)))) = std_logic_vector'("00000000000000000000000000000000")))))) = '1' then 
        dbs_8_reg_segment_0 <= p1_dbs_8_reg_segment_0;
      end if;
    end if;

  end process;

  --input to dbs-8 stored 1, which is an e_mux
  p1_dbs_8_reg_segment_1 <= ps2_avalon_slave_0_readdata_from_sa;
  --dbs register for dbs-8 segment 1, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dbs_8_reg_segment_1 <= std_logic_vector'("00000000");
    elsif clk'event and clk = '1' then
      if std_logic'((dbs_count_enable AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & ((internal_cpu_0_data_master_dbs_address(1 DOWNTO 0)))) = std_logic_vector'("00000000000000000000000000000001")))))) = '1' then 
        dbs_8_reg_segment_1 <= p1_dbs_8_reg_segment_1;
      end if;
    end if;

  end process;

  --input to dbs-8 stored 2, which is an e_mux
  p1_dbs_8_reg_segment_2 <= ps2_avalon_slave_0_readdata_from_sa;
  --dbs register for dbs-8 segment 2, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dbs_8_reg_segment_2 <= std_logic_vector'("00000000");
    elsif clk'event and clk = '1' then
      if std_logic'((dbs_count_enable AND to_std_logic((((std_logic_vector'("000000000000000000000000000000") & ((internal_cpu_0_data_master_dbs_address(1 DOWNTO 0)))) = std_logic_vector'("00000000000000000000000000000010")))))) = '1' then 
        dbs_8_reg_segment_2 <= p1_dbs_8_reg_segment_2;
      end if;
    end if;

  end process;

  --dbs count increment, which is an e_mux
  cpu_0_data_master_dbs_increment <= A_EXT (A_WE_StdLogicVector((std_logic'((cpu_0_data_master_requests_ps2_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'((cpu_0_data_master_requests_sdbuf_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((cpu_0_data_master_requests_sram_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000000")))), 2);
  --dbs counter overflow, which is an e_assign
  dbs_counter_overflow <= internal_cpu_0_data_master_dbs_address(1) AND NOT((next_dbs_address(1)));
  --next master address, which is an e_assign
  next_dbs_address <= A_EXT (((std_logic_vector'("0") & (internal_cpu_0_data_master_dbs_address)) + (std_logic_vector'("0") & (cpu_0_data_master_dbs_increment))), 2);
  --dbs count enable, which is an e_mux
  dbs_count_enable <= ((pre_dbs_count_enable AND (NOT (((cpu_0_data_master_requests_ps2_avalon_slave_0 AND NOT internal_cpu_0_data_master_waitrequest) AND cpu_0_data_master_write)))) AND (NOT (((cpu_0_data_master_requests_sdbuf_avalon_slave_0 AND NOT internal_cpu_0_data_master_waitrequest) AND cpu_0_data_master_write)))) AND (NOT (((cpu_0_data_master_requests_sram_avalon_slave_0 AND NOT internal_cpu_0_data_master_waitrequest) AND cpu_0_data_master_write)));
  --dbs counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_0_data_master_dbs_address <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(dbs_count_enable) = '1' then 
        internal_cpu_0_data_master_dbs_address <= next_dbs_address;
      end if;
    end if;

  end process;

  --pre dbs count enable, which is an e_mux
  pre_dbs_count_enable <= Vector_To_Std_Logic((((((((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_0_data_master_granted_ps2_avalon_slave_0 AND cpu_0_data_master_read)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_ps2_avalon_slave_0_end_xfer))))) OR ((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_0_data_master_granted_ps2_avalon_slave_0 AND cpu_0_data_master_write)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")))) OR (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_0_data_master_granted_sdbuf_avalon_slave_0 AND cpu_0_data_master_read)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_sdbuf_avalon_slave_0_end_xfer)))))) OR ((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_0_data_master_granted_sdbuf_avalon_slave_0 AND cpu_0_data_master_write)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")))) OR (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((((NOT internal_cpu_0_data_master_no_byte_enables_and_last_term) AND cpu_0_data_master_requests_sram_avalon_slave_0) AND cpu_0_data_master_write) AND NOT(or_reduce(cpu_0_data_master_byteenable_sram_avalon_slave_0)))))))) OR (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_0_data_master_granted_sram_avalon_slave_0 AND cpu_0_data_master_read)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_sram_avalon_slave_0_end_xfer)))))) OR ((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_0_data_master_granted_sram_avalon_slave_0 AND cpu_0_data_master_write)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")))));
  --input to dbs-16 stored 0, which is an e_mux
  p1_dbs_16_reg_segment_0 <= A_WE_StdLogicVector((std_logic'((cpu_0_data_master_requests_sdbuf_avalon_slave_0)) = '1'), sdbuf_avalon_slave_0_readdata_from_sa, sram_avalon_slave_0_readdata_from_sa);
  --dbs register for dbs-16 segment 0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dbs_16_reg_segment_0 <= std_logic_vector'("0000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((dbs_count_enable AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_0_data_master_dbs_address(1))))) = std_logic_vector'("00000000000000000000000000000000")))))) = '1' then 
        dbs_16_reg_segment_0 <= p1_dbs_16_reg_segment_0;
      end if;
    end if;

  end process;

  --no_byte_enables_and_last_term, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_0_data_master_no_byte_enables_and_last_term <= std_logic'('0');
    elsif clk'event and clk = '1' then
      internal_cpu_0_data_master_no_byte_enables_and_last_term <= last_dbs_term_and_run;
    end if;

  end process;

  --compute the last dbs term, which is an e_mux
  last_dbs_term_and_run <= (to_std_logic(((internal_cpu_0_data_master_dbs_address = std_logic_vector'("10")))) AND cpu_0_data_master_write) AND NOT(or_reduce(cpu_0_data_master_byteenable_sram_avalon_slave_0));
  --mux write dbs 1, which is an e_mux
  cpu_0_data_master_dbs_write_16 <= A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_dbs_address(1))) = '1'), cpu_0_data_master_writedata(31 DOWNTO 16), cpu_0_data_master_writedata(15 DOWNTO 0));
  --vhdl renameroo for output signals
  cpu_0_data_master_address_to_slave <= internal_cpu_0_data_master_address_to_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_dbs_address <= internal_cpu_0_data_master_dbs_address;
  --vhdl renameroo for output signals
  cpu_0_data_master_no_byte_enables_and_last_term <= internal_cpu_0_data_master_no_byte_enables_and_last_term;
  --vhdl renameroo for output signals
  cpu_0_data_master_waitrequest <= internal_cpu_0_data_master_waitrequest;

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity cpu_0_instruction_master_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_instruction_master_address : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_0_instruction_master_granted_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_instruction_master_granted_sram_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_instruction_master_qualified_request_sram_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_instruction_master_read : IN STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_sram_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_instruction_master_requests_cpu_0_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_0_instruction_master_requests_sram_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_0_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_cpu_0_jtag_debug_module_end_xfer : IN STD_LOGIC;
                 signal d1_sram_avalon_slave_0_end_xfer : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sram_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal cpu_0_instruction_master_address_to_slave : OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_0_instruction_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_instruction_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_0_instruction_master_waitrequest : OUT STD_LOGIC
              );
end entity cpu_0_instruction_master_arbitrator;


architecture europa of cpu_0_instruction_master_arbitrator is
                signal active_and_waiting_last_time :  STD_LOGIC;
                signal cpu_0_instruction_master_address_last_time :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal cpu_0_instruction_master_dbs_increment :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_instruction_master_read_last_time :  STD_LOGIC;
                signal cpu_0_instruction_master_run :  STD_LOGIC;
                signal dbs_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal dbs_count_enable :  STD_LOGIC;
                signal dbs_counter_overflow :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_address_to_slave :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal internal_cpu_0_instruction_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_cpu_0_instruction_master_waitrequest :  STD_LOGIC;
                signal next_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p1_dbs_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal pre_dbs_count_enable :  STD_LOGIC;
                signal r_0 :  STD_LOGIC;
                signal r_1 :  STD_LOGIC;

begin

  --r_0 master_run cascaded wait assignment, which is an e_assign
  r_0 <= Vector_To_Std_Logic((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module OR NOT cpu_0_instruction_master_requests_cpu_0_jtag_debug_module)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_instruction_master_granted_cpu_0_jtag_debug_module OR NOT cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module OR NOT cpu_0_instruction_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_cpu_0_jtag_debug_module_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_instruction_master_read)))))))));
  --cascaded wait assignment, which is an e_assign
  cpu_0_instruction_master_run <= r_0 AND r_1;
  --r_1 master_run cascaded wait assignment, which is an e_assign
  r_1 <= Vector_To_Std_Logic((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_instruction_master_qualified_request_sram_avalon_slave_0 OR NOT cpu_0_instruction_master_requests_sram_avalon_slave_0)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_0_instruction_master_granted_sram_avalon_slave_0 OR NOT cpu_0_instruction_master_qualified_request_sram_avalon_slave_0)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_0_instruction_master_qualified_request_sram_avalon_slave_0 OR NOT cpu_0_instruction_master_read)))) OR ((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_sram_avalon_slave_0_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_0_instruction_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_instruction_master_read)))))))));
  --optimize select-logic by passing only those address bits which matter.
  internal_cpu_0_instruction_master_address_to_slave <= cpu_0_instruction_master_address(20 DOWNTO 0);
  --cpu_0/instruction_master readdata mux, which is an e_mux
  cpu_0_instruction_master_readdata <= ((A_REP(NOT cpu_0_instruction_master_requests_cpu_0_jtag_debug_module, 32) OR cpu_0_jtag_debug_module_readdata_from_sa)) AND ((A_REP(NOT cpu_0_instruction_master_requests_sram_avalon_slave_0, 32) OR Std_Logic_Vector'(sram_avalon_slave_0_readdata_from_sa(15 DOWNTO 0) & dbs_16_reg_segment_0)));
  --actual waitrequest port, which is an e_assign
  internal_cpu_0_instruction_master_waitrequest <= NOT cpu_0_instruction_master_run;
  --input to dbs-16 stored 0, which is an e_mux
  p1_dbs_16_reg_segment_0 <= sram_avalon_slave_0_readdata_from_sa;
  --dbs register for dbs-16 segment 0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dbs_16_reg_segment_0 <= std_logic_vector'("0000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((dbs_count_enable AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_0_instruction_master_dbs_address(1))))) = std_logic_vector'("00000000000000000000000000000000")))))) = '1' then 
        dbs_16_reg_segment_0 <= p1_dbs_16_reg_segment_0;
      end if;
    end if;

  end process;

  --dbs count increment, which is an e_mux
  cpu_0_instruction_master_dbs_increment <= A_EXT (A_WE_StdLogicVector((std_logic'((cpu_0_instruction_master_requests_sram_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000000")), 2);
  --dbs counter overflow, which is an e_assign
  dbs_counter_overflow <= internal_cpu_0_instruction_master_dbs_address(1) AND NOT((next_dbs_address(1)));
  --next master address, which is an e_assign
  next_dbs_address <= A_EXT (((std_logic_vector'("0") & (internal_cpu_0_instruction_master_dbs_address)) + (std_logic_vector'("0") & (cpu_0_instruction_master_dbs_increment))), 2);
  --dbs count enable, which is an e_mux
  dbs_count_enable <= pre_dbs_count_enable;
  --dbs counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_0_instruction_master_dbs_address <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(dbs_count_enable) = '1' then 
        internal_cpu_0_instruction_master_dbs_address <= next_dbs_address;
      end if;
    end if;

  end process;

  --pre dbs count enable, which is an e_mux
  pre_dbs_count_enable <= Vector_To_Std_Logic(((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_0_instruction_master_granted_sram_avalon_slave_0 AND cpu_0_instruction_master_read)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_sram_avalon_slave_0_end_xfer)))));
  --vhdl renameroo for output signals
  cpu_0_instruction_master_address_to_slave <= internal_cpu_0_instruction_master_address_to_slave;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_dbs_address <= internal_cpu_0_instruction_master_dbs_address;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_waitrequest <= internal_cpu_0_instruction_master_waitrequest;
--synthesis translate_off
    --cpu_0_instruction_master_address check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_0_instruction_master_address_last_time <= std_logic_vector'("000000000000000000000");
      elsif clk'event and clk = '1' then
        cpu_0_instruction_master_address_last_time <= cpu_0_instruction_master_address;
      end if;

    end process;

    --cpu_0/instruction_master waited last time, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        active_and_waiting_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        active_and_waiting_last_time <= internal_cpu_0_instruction_master_waitrequest AND (cpu_0_instruction_master_read);
      end if;

    end process;

    --cpu_0_instruction_master_address matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line2 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((cpu_0_instruction_master_address /= cpu_0_instruction_master_address_last_time))))) = '1' then 
          write(write_line2, now);
          write(write_line2, string'(": "));
          write(write_line2, string'("cpu_0_instruction_master_address did not heed wait!!!"));
          write(output, write_line2.all);
          deallocate (write_line2);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --cpu_0_instruction_master_read check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_0_instruction_master_read_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        cpu_0_instruction_master_read_last_time <= cpu_0_instruction_master_read;
      end if;

    end process;

    --cpu_0_instruction_master_read matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line3 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((std_logic'(cpu_0_instruction_master_read) /= std_logic'(cpu_0_instruction_master_read_last_time)))))) = '1' then 
          write(write_line3, now);
          write(write_line3, string'(": "));
          write(write_line3, string'("cpu_0_instruction_master_read did not heed wait!!!"));
          write(output, write_line3.all);
          deallocate (write_line3);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity jtag_uart_0_avalon_jtag_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_0_avalon_jtag_slave_dataavailable : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_irq : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_0_avalon_jtag_slave_readyfordata : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                 signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_address : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_chipselect : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_irq_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_read_n : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_reset_n : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_write_n : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity jtag_uart_0_avalon_jtag_slave_arbitrator;


architecture europa of jtag_uart_0_avalon_jtag_slave_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_allgrants :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_any_continuerequest :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_arb_counter_enable :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_arb_share_counter :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_arb_share_set_values :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_begins_xfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_end_xfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_firsttransfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_grant_vector :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_in_a_read_cycle :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_in_a_write_cycle :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_master_qreq_vector :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_reg_firsttransfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_waits_for_read :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_cpu_0_data_master :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal wait_for_jtag_uart_0_avalon_jtag_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT jtag_uart_0_avalon_jtag_slave_end_xfer;
    end if;

  end process;

  jtag_uart_0_avalon_jtag_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave);
  --assign jtag_uart_0_avalon_jtag_slave_readdata_from_sa = jtag_uart_0_avalon_jtag_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_readdata_from_sa <= jtag_uart_0_avalon_jtag_slave_readdata;
  internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(20 DOWNTO 3) & std_logic_vector'("000")) = std_logic_vector'("100000001001000100000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --assign jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_0_avalon_jtag_slave_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa <= jtag_uart_0_avalon_jtag_slave_dataavailable;
  --assign jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_0_avalon_jtag_slave_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa <= jtag_uart_0_avalon_jtag_slave_readyfordata;
  --assign jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_0_avalon_jtag_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa <= jtag_uart_0_avalon_jtag_slave_waitrequest;
  --jtag_uart_0_avalon_jtag_slave_arb_share_counter set values, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_arb_share_set_values <= std_logic_vector'("001");
  --jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests mux, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests <= internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  --jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant mux, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(jtag_uart_0_avalon_jtag_slave_firsttransfer) = '1'), (((std_logic_vector'("000000000000000000000000000000") & (jtag_uart_0_avalon_jtag_slave_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(jtag_uart_0_avalon_jtag_slave_arb_share_counter)) = '1'), (((std_logic_vector'("000000000000000000000000000000") & (jtag_uart_0_avalon_jtag_slave_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 3);
  --jtag_uart_0_avalon_jtag_slave_allgrants all slave grants, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_allgrants <= jtag_uart_0_avalon_jtag_slave_grant_vector;
  --jtag_uart_0_avalon_jtag_slave_end_xfer assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_end_xfer <= NOT ((jtag_uart_0_avalon_jtag_slave_waits_for_read OR jtag_uart_0_avalon_jtag_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave <= jtag_uart_0_avalon_jtag_slave_end_xfer AND (((NOT jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --jtag_uart_0_avalon_jtag_slave_arb_share_counter arbitration counter enable, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave AND jtag_uart_0_avalon_jtag_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave AND NOT jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests));
  --jtag_uart_0_avalon_jtag_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_0_avalon_jtag_slave_arb_share_counter <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      if std_logic'(jtag_uart_0_avalon_jtag_slave_arb_counter_enable) = '1' then 
        jtag_uart_0_avalon_jtag_slave_arb_share_counter <= jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((jtag_uart_0_avalon_jtag_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave)) OR ((end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave AND NOT jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests)))) = '1' then 
        jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable <= or_reduce(jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master jtag_uart_0/avalon_jtag_slave arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 <= or_reduce(jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value);
  --cpu_0/data_master jtag_uart_0/avalon_jtag_slave arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --jtag_uart_0_avalon_jtag_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave AND NOT ((((cpu_0_data_master_read AND (NOT cpu_0_data_master_waitrequest))) OR (((NOT cpu_0_data_master_waitrequest) AND cpu_0_data_master_write))));
  --jtag_uart_0_avalon_jtag_slave_writedata mux, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_writedata <= cpu_0_data_master_writedata;
  --master is always granted when requested
  internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  --cpu_0/data_master saved-grant jtag_uart_0/avalon_jtag_slave, which is an e_assign
  cpu_0_data_master_saved_grant_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  --allow new arb cycle for jtag_uart_0/avalon_jtag_slave, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  jtag_uart_0_avalon_jtag_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  jtag_uart_0_avalon_jtag_slave_master_qreq_vector <= std_logic'('1');
  --jtag_uart_0_avalon_jtag_slave_reset_n assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_reset_n <= reset_n;
  jtag_uart_0_avalon_jtag_slave_chipselect <= internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  --jtag_uart_0_avalon_jtag_slave_firsttransfer first transaction, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_firsttransfer <= A_WE_StdLogic((std_logic'(jtag_uart_0_avalon_jtag_slave_begins_xfer) = '1'), jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer, jtag_uart_0_avalon_jtag_slave_reg_firsttransfer);
  --jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer first transaction, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer <= NOT ((jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable AND jtag_uart_0_avalon_jtag_slave_any_continuerequest));
  --jtag_uart_0_avalon_jtag_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_0_avalon_jtag_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(jtag_uart_0_avalon_jtag_slave_begins_xfer) = '1' then 
        jtag_uart_0_avalon_jtag_slave_reg_firsttransfer <= jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal <= jtag_uart_0_avalon_jtag_slave_begins_xfer;
  --~jtag_uart_0_avalon_jtag_slave_read_n assignment, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_read_n <= NOT ((internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave AND cpu_0_data_master_read));
  --~jtag_uart_0_avalon_jtag_slave_write_n assignment, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_write_n <= NOT ((internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave AND cpu_0_data_master_write));
  shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --jtag_uart_0_avalon_jtag_slave_address mux, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_address <= Vector_To_Std_Logic(A_SRL(shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")));
  --d1_jtag_uart_0_avalon_jtag_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_jtag_uart_0_avalon_jtag_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_jtag_uart_0_avalon_jtag_slave_end_xfer <= jtag_uart_0_avalon_jtag_slave_end_xfer;
    end if;

  end process;

  --jtag_uart_0_avalon_jtag_slave_waits_for_read in a cycle, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_waits_for_read <= jtag_uart_0_avalon_jtag_slave_in_a_read_cycle AND internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  --jtag_uart_0_avalon_jtag_slave_in_a_read_cycle assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_in_a_read_cycle <= internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= jtag_uart_0_avalon_jtag_slave_in_a_read_cycle;
  --jtag_uart_0_avalon_jtag_slave_waits_for_write in a cycle, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_waits_for_write <= jtag_uart_0_avalon_jtag_slave_in_a_write_cycle AND internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  --jtag_uart_0_avalon_jtag_slave_in_a_write_cycle assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_in_a_write_cycle <= internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= jtag_uart_0_avalon_jtag_slave_in_a_write_cycle;
  wait_for_jtag_uart_0_avalon_jtag_slave_counter <= std_logic'('0');
  --assign jtag_uart_0_avalon_jtag_slave_irq_from_sa = jtag_uart_0_avalon_jtag_slave_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_irq_from_sa <= jtag_uart_0_avalon_jtag_slave_irq;
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave <= internal_cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  --vhdl renameroo for output signals
  jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa <= internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
--synthesis translate_off
    --jtag_uart_0/avalon_jtag_slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity kanto_ctrl_avalon_slave_0_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal kanto_ctrl_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_kanto_ctrl_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0 : OUT STD_LOGIC;
                 signal d1_kanto_ctrl_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                 signal kanto_ctrl_avalon_slave_0_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal kanto_ctrl_avalon_slave_0_chipselect : OUT STD_LOGIC;
                 signal kanto_ctrl_avalon_slave_0_read : OUT STD_LOGIC;
                 signal kanto_ctrl_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal kanto_ctrl_avalon_slave_0_reset_n : OUT STD_LOGIC;
                 signal kanto_ctrl_avalon_slave_0_write : OUT STD_LOGIC;
                 signal kanto_ctrl_avalon_slave_0_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity kanto_ctrl_avalon_slave_0_arbitrator;


architecture europa of kanto_ctrl_avalon_slave_0_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_kanto_ctrl_avalon_slave_0 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_kanto_ctrl_avalon_slave_0 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0 :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_allgrants :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_allow_new_arb_cycle :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_any_bursting_master_saved_grant :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_any_continuerequest :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_arb_counter_enable :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_arb_share_counter :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal kanto_ctrl_avalon_slave_0_arb_share_counter_next_value :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal kanto_ctrl_avalon_slave_0_arb_share_set_values :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal kanto_ctrl_avalon_slave_0_beginbursttransfer_internal :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_begins_xfer :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_firsttransfer :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_grant_vector :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_in_a_read_cycle :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_in_a_write_cycle :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_master_qreq_vector :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_non_bursting_master_requests :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_reg_firsttransfer :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_slavearbiterlockenable :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_slavearbiterlockenable2 :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_unreg_firsttransfer :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_waits_for_read :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_kanto_ctrl_avalon_slave_0_from_cpu_0_data_master :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal wait_for_kanto_ctrl_avalon_slave_0_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT kanto_ctrl_avalon_slave_0_end_xfer;
    end if;

  end process;

  kanto_ctrl_avalon_slave_0_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0);
  --assign kanto_ctrl_avalon_slave_0_readdata_from_sa = kanto_ctrl_avalon_slave_0_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  kanto_ctrl_avalon_slave_0_readdata_from_sa <= kanto_ctrl_avalon_slave_0_readdata;
  internal_cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(20 DOWNTO 5) & std_logic_vector'("00000")) = std_logic_vector'("100000001001000000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --kanto_ctrl_avalon_slave_0_arb_share_counter set values, which is an e_mux
  kanto_ctrl_avalon_slave_0_arb_share_set_values <= std_logic_vector'("001");
  --kanto_ctrl_avalon_slave_0_non_bursting_master_requests mux, which is an e_mux
  kanto_ctrl_avalon_slave_0_non_bursting_master_requests <= internal_cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0;
  --kanto_ctrl_avalon_slave_0_any_bursting_master_saved_grant mux, which is an e_mux
  kanto_ctrl_avalon_slave_0_any_bursting_master_saved_grant <= std_logic'('0');
  --kanto_ctrl_avalon_slave_0_arb_share_counter_next_value assignment, which is an e_assign
  kanto_ctrl_avalon_slave_0_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(kanto_ctrl_avalon_slave_0_firsttransfer) = '1'), (((std_logic_vector'("000000000000000000000000000000") & (kanto_ctrl_avalon_slave_0_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(kanto_ctrl_avalon_slave_0_arb_share_counter)) = '1'), (((std_logic_vector'("000000000000000000000000000000") & (kanto_ctrl_avalon_slave_0_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 3);
  --kanto_ctrl_avalon_slave_0_allgrants all slave grants, which is an e_mux
  kanto_ctrl_avalon_slave_0_allgrants <= kanto_ctrl_avalon_slave_0_grant_vector;
  --kanto_ctrl_avalon_slave_0_end_xfer assignment, which is an e_assign
  kanto_ctrl_avalon_slave_0_end_xfer <= NOT ((kanto_ctrl_avalon_slave_0_waits_for_read OR kanto_ctrl_avalon_slave_0_waits_for_write));
  --end_xfer_arb_share_counter_term_kanto_ctrl_avalon_slave_0 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_kanto_ctrl_avalon_slave_0 <= kanto_ctrl_avalon_slave_0_end_xfer AND (((NOT kanto_ctrl_avalon_slave_0_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --kanto_ctrl_avalon_slave_0_arb_share_counter arbitration counter enable, which is an e_assign
  kanto_ctrl_avalon_slave_0_arb_counter_enable <= ((end_xfer_arb_share_counter_term_kanto_ctrl_avalon_slave_0 AND kanto_ctrl_avalon_slave_0_allgrants)) OR ((end_xfer_arb_share_counter_term_kanto_ctrl_avalon_slave_0 AND NOT kanto_ctrl_avalon_slave_0_non_bursting_master_requests));
  --kanto_ctrl_avalon_slave_0_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      kanto_ctrl_avalon_slave_0_arb_share_counter <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      if std_logic'(kanto_ctrl_avalon_slave_0_arb_counter_enable) = '1' then 
        kanto_ctrl_avalon_slave_0_arb_share_counter <= kanto_ctrl_avalon_slave_0_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --kanto_ctrl_avalon_slave_0_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      kanto_ctrl_avalon_slave_0_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((kanto_ctrl_avalon_slave_0_master_qreq_vector AND end_xfer_arb_share_counter_term_kanto_ctrl_avalon_slave_0)) OR ((end_xfer_arb_share_counter_term_kanto_ctrl_avalon_slave_0 AND NOT kanto_ctrl_avalon_slave_0_non_bursting_master_requests)))) = '1' then 
        kanto_ctrl_avalon_slave_0_slavearbiterlockenable <= or_reduce(kanto_ctrl_avalon_slave_0_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master kanto_ctrl/avalon_slave_0 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= kanto_ctrl_avalon_slave_0_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --kanto_ctrl_avalon_slave_0_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  kanto_ctrl_avalon_slave_0_slavearbiterlockenable2 <= or_reduce(kanto_ctrl_avalon_slave_0_arb_share_counter_next_value);
  --cpu_0/data_master kanto_ctrl/avalon_slave_0 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= kanto_ctrl_avalon_slave_0_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --kanto_ctrl_avalon_slave_0_any_continuerequest at least one master continues requesting, which is an e_assign
  kanto_ctrl_avalon_slave_0_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0 <= internal_cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0 AND NOT (((NOT cpu_0_data_master_waitrequest) AND cpu_0_data_master_write));
  --kanto_ctrl_avalon_slave_0_writedata mux, which is an e_mux
  kanto_ctrl_avalon_slave_0_writedata <= cpu_0_data_master_writedata;
  --master is always granted when requested
  internal_cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0 <= internal_cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0;
  --cpu_0/data_master saved-grant kanto_ctrl/avalon_slave_0, which is an e_assign
  cpu_0_data_master_saved_grant_kanto_ctrl_avalon_slave_0 <= internal_cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0;
  --allow new arb cycle for kanto_ctrl/avalon_slave_0, which is an e_assign
  kanto_ctrl_avalon_slave_0_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  kanto_ctrl_avalon_slave_0_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  kanto_ctrl_avalon_slave_0_master_qreq_vector <= std_logic'('1');
  --kanto_ctrl_avalon_slave_0_reset_n assignment, which is an e_assign
  kanto_ctrl_avalon_slave_0_reset_n <= reset_n;
  kanto_ctrl_avalon_slave_0_chipselect <= internal_cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0;
  --kanto_ctrl_avalon_slave_0_firsttransfer first transaction, which is an e_assign
  kanto_ctrl_avalon_slave_0_firsttransfer <= A_WE_StdLogic((std_logic'(kanto_ctrl_avalon_slave_0_begins_xfer) = '1'), kanto_ctrl_avalon_slave_0_unreg_firsttransfer, kanto_ctrl_avalon_slave_0_reg_firsttransfer);
  --kanto_ctrl_avalon_slave_0_unreg_firsttransfer first transaction, which is an e_assign
  kanto_ctrl_avalon_slave_0_unreg_firsttransfer <= NOT ((kanto_ctrl_avalon_slave_0_slavearbiterlockenable AND kanto_ctrl_avalon_slave_0_any_continuerequest));
  --kanto_ctrl_avalon_slave_0_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      kanto_ctrl_avalon_slave_0_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(kanto_ctrl_avalon_slave_0_begins_xfer) = '1' then 
        kanto_ctrl_avalon_slave_0_reg_firsttransfer <= kanto_ctrl_avalon_slave_0_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --kanto_ctrl_avalon_slave_0_beginbursttransfer_internal begin burst transfer, which is an e_assign
  kanto_ctrl_avalon_slave_0_beginbursttransfer_internal <= kanto_ctrl_avalon_slave_0_begins_xfer;
  --kanto_ctrl_avalon_slave_0_read assignment, which is an e_mux
  kanto_ctrl_avalon_slave_0_read <= internal_cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0 AND cpu_0_data_master_read;
  --kanto_ctrl_avalon_slave_0_write assignment, which is an e_mux
  kanto_ctrl_avalon_slave_0_write <= internal_cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0 AND cpu_0_data_master_write;
  shifted_address_to_kanto_ctrl_avalon_slave_0_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --kanto_ctrl_avalon_slave_0_address mux, which is an e_mux
  kanto_ctrl_avalon_slave_0_address <= A_EXT (A_SRL(shifted_address_to_kanto_ctrl_avalon_slave_0_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 3);
  --d1_kanto_ctrl_avalon_slave_0_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_kanto_ctrl_avalon_slave_0_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_kanto_ctrl_avalon_slave_0_end_xfer <= kanto_ctrl_avalon_slave_0_end_xfer;
    end if;

  end process;

  --kanto_ctrl_avalon_slave_0_waits_for_read in a cycle, which is an e_mux
  kanto_ctrl_avalon_slave_0_waits_for_read <= kanto_ctrl_avalon_slave_0_in_a_read_cycle AND kanto_ctrl_avalon_slave_0_begins_xfer;
  --kanto_ctrl_avalon_slave_0_in_a_read_cycle assignment, which is an e_assign
  kanto_ctrl_avalon_slave_0_in_a_read_cycle <= internal_cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0 AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= kanto_ctrl_avalon_slave_0_in_a_read_cycle;
  --kanto_ctrl_avalon_slave_0_waits_for_write in a cycle, which is an e_mux
  kanto_ctrl_avalon_slave_0_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(kanto_ctrl_avalon_slave_0_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --kanto_ctrl_avalon_slave_0_in_a_write_cycle assignment, which is an e_assign
  kanto_ctrl_avalon_slave_0_in_a_write_cycle <= internal_cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= kanto_ctrl_avalon_slave_0_in_a_write_cycle;
  wait_for_kanto_ctrl_avalon_slave_0_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0 <= internal_cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0 <= internal_cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0 <= internal_cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0;
--synthesis translate_off
    --kanto_ctrl/avalon_slave_0 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ps2_avalon_slave_0_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_0_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal ps2_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_0_data_master_granted_ps2_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_ps2_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_ps2_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_ps2_avalon_slave_0 : OUT STD_LOGIC;
                 signal d1_ps2_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                 signal ps2_avalon_slave_0_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal ps2_avalon_slave_0_chipselect : OUT STD_LOGIC;
                 signal ps2_avalon_slave_0_read : OUT STD_LOGIC;
                 signal ps2_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal ps2_avalon_slave_0_reset : OUT STD_LOGIC
              );
end entity ps2_avalon_slave_0_arbitrator;


architecture europa of ps2_avalon_slave_0_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_ps2_avalon_slave_0 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_ps2_avalon_slave_0 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_ps2_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_ps2_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_ps2_avalon_slave_0 :  STD_LOGIC;
                signal ps2_avalon_slave_0_allgrants :  STD_LOGIC;
                signal ps2_avalon_slave_0_allow_new_arb_cycle :  STD_LOGIC;
                signal ps2_avalon_slave_0_any_bursting_master_saved_grant :  STD_LOGIC;
                signal ps2_avalon_slave_0_any_continuerequest :  STD_LOGIC;
                signal ps2_avalon_slave_0_arb_counter_enable :  STD_LOGIC;
                signal ps2_avalon_slave_0_arb_share_counter :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal ps2_avalon_slave_0_arb_share_counter_next_value :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal ps2_avalon_slave_0_arb_share_set_values :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal ps2_avalon_slave_0_beginbursttransfer_internal :  STD_LOGIC;
                signal ps2_avalon_slave_0_begins_xfer :  STD_LOGIC;
                signal ps2_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal ps2_avalon_slave_0_firsttransfer :  STD_LOGIC;
                signal ps2_avalon_slave_0_grant_vector :  STD_LOGIC;
                signal ps2_avalon_slave_0_in_a_read_cycle :  STD_LOGIC;
                signal ps2_avalon_slave_0_in_a_write_cycle :  STD_LOGIC;
                signal ps2_avalon_slave_0_master_qreq_vector :  STD_LOGIC;
                signal ps2_avalon_slave_0_non_bursting_master_requests :  STD_LOGIC;
                signal ps2_avalon_slave_0_reg_firsttransfer :  STD_LOGIC;
                signal ps2_avalon_slave_0_slavearbiterlockenable :  STD_LOGIC;
                signal ps2_avalon_slave_0_slavearbiterlockenable2 :  STD_LOGIC;
                signal ps2_avalon_slave_0_unreg_firsttransfer :  STD_LOGIC;
                signal ps2_avalon_slave_0_waits_for_read :  STD_LOGIC;
                signal ps2_avalon_slave_0_waits_for_write :  STD_LOGIC;
                signal wait_for_ps2_avalon_slave_0_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT ps2_avalon_slave_0_end_xfer;
    end if;

  end process;

  ps2_avalon_slave_0_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_ps2_avalon_slave_0);
  --assign ps2_avalon_slave_0_readdata_from_sa = ps2_avalon_slave_0_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  ps2_avalon_slave_0_readdata_from_sa <= ps2_avalon_slave_0_readdata;
  internal_cpu_0_data_master_requests_ps2_avalon_slave_0 <= ((to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(20 DOWNTO 3) & std_logic_vector'("000")) = std_logic_vector'("000000000000000000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write)))) AND cpu_0_data_master_read;
  --ps2_avalon_slave_0_arb_share_counter set values, which is an e_mux
  ps2_avalon_slave_0_arb_share_set_values <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_ps2_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000100"), std_logic_vector'("00000000000000000000000000000001")), 3);
  --ps2_avalon_slave_0_non_bursting_master_requests mux, which is an e_mux
  ps2_avalon_slave_0_non_bursting_master_requests <= internal_cpu_0_data_master_requests_ps2_avalon_slave_0;
  --ps2_avalon_slave_0_any_bursting_master_saved_grant mux, which is an e_mux
  ps2_avalon_slave_0_any_bursting_master_saved_grant <= std_logic'('0');
  --ps2_avalon_slave_0_arb_share_counter_next_value assignment, which is an e_assign
  ps2_avalon_slave_0_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(ps2_avalon_slave_0_firsttransfer) = '1'), (((std_logic_vector'("000000000000000000000000000000") & (ps2_avalon_slave_0_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(ps2_avalon_slave_0_arb_share_counter)) = '1'), (((std_logic_vector'("000000000000000000000000000000") & (ps2_avalon_slave_0_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 3);
  --ps2_avalon_slave_0_allgrants all slave grants, which is an e_mux
  ps2_avalon_slave_0_allgrants <= ps2_avalon_slave_0_grant_vector;
  --ps2_avalon_slave_0_end_xfer assignment, which is an e_assign
  ps2_avalon_slave_0_end_xfer <= NOT ((ps2_avalon_slave_0_waits_for_read OR ps2_avalon_slave_0_waits_for_write));
  --end_xfer_arb_share_counter_term_ps2_avalon_slave_0 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_ps2_avalon_slave_0 <= ps2_avalon_slave_0_end_xfer AND (((NOT ps2_avalon_slave_0_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --ps2_avalon_slave_0_arb_share_counter arbitration counter enable, which is an e_assign
  ps2_avalon_slave_0_arb_counter_enable <= ((end_xfer_arb_share_counter_term_ps2_avalon_slave_0 AND ps2_avalon_slave_0_allgrants)) OR ((end_xfer_arb_share_counter_term_ps2_avalon_slave_0 AND NOT ps2_avalon_slave_0_non_bursting_master_requests));
  --ps2_avalon_slave_0_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ps2_avalon_slave_0_arb_share_counter <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      if std_logic'(ps2_avalon_slave_0_arb_counter_enable) = '1' then 
        ps2_avalon_slave_0_arb_share_counter <= ps2_avalon_slave_0_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --ps2_avalon_slave_0_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ps2_avalon_slave_0_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((ps2_avalon_slave_0_master_qreq_vector AND end_xfer_arb_share_counter_term_ps2_avalon_slave_0)) OR ((end_xfer_arb_share_counter_term_ps2_avalon_slave_0 AND NOT ps2_avalon_slave_0_non_bursting_master_requests)))) = '1' then 
        ps2_avalon_slave_0_slavearbiterlockenable <= or_reduce(ps2_avalon_slave_0_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master ps2/avalon_slave_0 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= ps2_avalon_slave_0_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --ps2_avalon_slave_0_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  ps2_avalon_slave_0_slavearbiterlockenable2 <= or_reduce(ps2_avalon_slave_0_arb_share_counter_next_value);
  --cpu_0/data_master ps2/avalon_slave_0 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= ps2_avalon_slave_0_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --ps2_avalon_slave_0_any_continuerequest at least one master continues requesting, which is an e_assign
  ps2_avalon_slave_0_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_ps2_avalon_slave_0 <= internal_cpu_0_data_master_requests_ps2_avalon_slave_0;
  --master is always granted when requested
  internal_cpu_0_data_master_granted_ps2_avalon_slave_0 <= internal_cpu_0_data_master_qualified_request_ps2_avalon_slave_0;
  --cpu_0/data_master saved-grant ps2/avalon_slave_0, which is an e_assign
  cpu_0_data_master_saved_grant_ps2_avalon_slave_0 <= internal_cpu_0_data_master_requests_ps2_avalon_slave_0;
  --allow new arb cycle for ps2/avalon_slave_0, which is an e_assign
  ps2_avalon_slave_0_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  ps2_avalon_slave_0_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  ps2_avalon_slave_0_master_qreq_vector <= std_logic'('1');
  --~ps2_avalon_slave_0_reset assignment, which is an e_assign
  ps2_avalon_slave_0_reset <= NOT reset_n;
  ps2_avalon_slave_0_chipselect <= internal_cpu_0_data_master_granted_ps2_avalon_slave_0;
  --ps2_avalon_slave_0_firsttransfer first transaction, which is an e_assign
  ps2_avalon_slave_0_firsttransfer <= A_WE_StdLogic((std_logic'(ps2_avalon_slave_0_begins_xfer) = '1'), ps2_avalon_slave_0_unreg_firsttransfer, ps2_avalon_slave_0_reg_firsttransfer);
  --ps2_avalon_slave_0_unreg_firsttransfer first transaction, which is an e_assign
  ps2_avalon_slave_0_unreg_firsttransfer <= NOT ((ps2_avalon_slave_0_slavearbiterlockenable AND ps2_avalon_slave_0_any_continuerequest));
  --ps2_avalon_slave_0_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ps2_avalon_slave_0_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(ps2_avalon_slave_0_begins_xfer) = '1' then 
        ps2_avalon_slave_0_reg_firsttransfer <= ps2_avalon_slave_0_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --ps2_avalon_slave_0_beginbursttransfer_internal begin burst transfer, which is an e_assign
  ps2_avalon_slave_0_beginbursttransfer_internal <= ps2_avalon_slave_0_begins_xfer;
  --ps2_avalon_slave_0_read assignment, which is an e_mux
  ps2_avalon_slave_0_read <= internal_cpu_0_data_master_granted_ps2_avalon_slave_0 AND cpu_0_data_master_read;
  --ps2_avalon_slave_0_address mux, which is an e_mux
  ps2_avalon_slave_0_address <= A_EXT (Std_Logic_Vector'(A_SRL(cpu_0_data_master_address_to_slave,std_logic_vector'("00000000000000000000000000000010")) & cpu_0_data_master_dbs_address(1 DOWNTO 0)), 3);
  --d1_ps2_avalon_slave_0_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_ps2_avalon_slave_0_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_ps2_avalon_slave_0_end_xfer <= ps2_avalon_slave_0_end_xfer;
    end if;

  end process;

  --ps2_avalon_slave_0_waits_for_read in a cycle, which is an e_mux
  ps2_avalon_slave_0_waits_for_read <= ps2_avalon_slave_0_in_a_read_cycle AND ps2_avalon_slave_0_begins_xfer;
  --ps2_avalon_slave_0_in_a_read_cycle assignment, which is an e_assign
  ps2_avalon_slave_0_in_a_read_cycle <= internal_cpu_0_data_master_granted_ps2_avalon_slave_0 AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= ps2_avalon_slave_0_in_a_read_cycle;
  --ps2_avalon_slave_0_waits_for_write in a cycle, which is an e_mux
  ps2_avalon_slave_0_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ps2_avalon_slave_0_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --ps2_avalon_slave_0_in_a_write_cycle assignment, which is an e_assign
  ps2_avalon_slave_0_in_a_write_cycle <= internal_cpu_0_data_master_granted_ps2_avalon_slave_0 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= ps2_avalon_slave_0_in_a_write_cycle;
  wait_for_ps2_avalon_slave_0_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_ps2_avalon_slave_0 <= internal_cpu_0_data_master_granted_ps2_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_ps2_avalon_slave_0 <= internal_cpu_0_data_master_qualified_request_ps2_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_ps2_avalon_slave_0 <= internal_cpu_0_data_master_requests_ps2_avalon_slave_0;
--synthesis translate_off
    --ps2/avalon_slave_0 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity sdbuf_avalon_slave_0_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_0_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sdbuf_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal cpu_0_data_master_granted_sdbuf_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_sdbuf_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sdbuf_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_sdbuf_avalon_slave_0 : OUT STD_LOGIC;
                 signal d1_sdbuf_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                 signal sdbuf_avalon_slave_0_address : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal sdbuf_avalon_slave_0_chipselect : OUT STD_LOGIC;
                 signal sdbuf_avalon_slave_0_read : OUT STD_LOGIC;
                 signal sdbuf_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sdbuf_avalon_slave_0_reset_n : OUT STD_LOGIC
              );
end entity sdbuf_avalon_slave_0_arbitrator;


architecture europa of sdbuf_avalon_slave_0_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_sdbuf_avalon_slave_0 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_sdbuf_avalon_slave_0 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_sdbuf_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_sdbuf_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_sdbuf_avalon_slave_0 :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_allgrants :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_allow_new_arb_cycle :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_any_bursting_master_saved_grant :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_any_continuerequest :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_arb_counter_enable :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_arb_share_counter :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal sdbuf_avalon_slave_0_arb_share_counter_next_value :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal sdbuf_avalon_slave_0_arb_share_set_values :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal sdbuf_avalon_slave_0_beginbursttransfer_internal :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_begins_xfer :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_firsttransfer :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_grant_vector :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_in_a_read_cycle :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_in_a_write_cycle :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_master_qreq_vector :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_non_bursting_master_requests :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_reg_firsttransfer :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_slavearbiterlockenable :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_slavearbiterlockenable2 :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_unreg_firsttransfer :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_waits_for_read :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_sdbuf_avalon_slave_0_from_cpu_0_data_master :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal wait_for_sdbuf_avalon_slave_0_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT sdbuf_avalon_slave_0_end_xfer;
    end if;

  end process;

  sdbuf_avalon_slave_0_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_sdbuf_avalon_slave_0);
  --assign sdbuf_avalon_slave_0_readdata_from_sa = sdbuf_avalon_slave_0_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  sdbuf_avalon_slave_0_readdata_from_sa <= sdbuf_avalon_slave_0_readdata;
  internal_cpu_0_data_master_requests_sdbuf_avalon_slave_0 <= ((to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(20 DOWNTO 9) & std_logic_vector'("000000000")) = std_logic_vector'("100000001000000000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write)))) AND cpu_0_data_master_read;
  --sdbuf_avalon_slave_0_arb_share_counter set values, which is an e_mux
  sdbuf_avalon_slave_0_arb_share_set_values <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_sdbuf_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000001")), 3);
  --sdbuf_avalon_slave_0_non_bursting_master_requests mux, which is an e_mux
  sdbuf_avalon_slave_0_non_bursting_master_requests <= internal_cpu_0_data_master_requests_sdbuf_avalon_slave_0;
  --sdbuf_avalon_slave_0_any_bursting_master_saved_grant mux, which is an e_mux
  sdbuf_avalon_slave_0_any_bursting_master_saved_grant <= std_logic'('0');
  --sdbuf_avalon_slave_0_arb_share_counter_next_value assignment, which is an e_assign
  sdbuf_avalon_slave_0_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(sdbuf_avalon_slave_0_firsttransfer) = '1'), (((std_logic_vector'("000000000000000000000000000000") & (sdbuf_avalon_slave_0_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(sdbuf_avalon_slave_0_arb_share_counter)) = '1'), (((std_logic_vector'("000000000000000000000000000000") & (sdbuf_avalon_slave_0_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 3);
  --sdbuf_avalon_slave_0_allgrants all slave grants, which is an e_mux
  sdbuf_avalon_slave_0_allgrants <= sdbuf_avalon_slave_0_grant_vector;
  --sdbuf_avalon_slave_0_end_xfer assignment, which is an e_assign
  sdbuf_avalon_slave_0_end_xfer <= NOT ((sdbuf_avalon_slave_0_waits_for_read OR sdbuf_avalon_slave_0_waits_for_write));
  --end_xfer_arb_share_counter_term_sdbuf_avalon_slave_0 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_sdbuf_avalon_slave_0 <= sdbuf_avalon_slave_0_end_xfer AND (((NOT sdbuf_avalon_slave_0_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --sdbuf_avalon_slave_0_arb_share_counter arbitration counter enable, which is an e_assign
  sdbuf_avalon_slave_0_arb_counter_enable <= ((end_xfer_arb_share_counter_term_sdbuf_avalon_slave_0 AND sdbuf_avalon_slave_0_allgrants)) OR ((end_xfer_arb_share_counter_term_sdbuf_avalon_slave_0 AND NOT sdbuf_avalon_slave_0_non_bursting_master_requests));
  --sdbuf_avalon_slave_0_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdbuf_avalon_slave_0_arb_share_counter <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      if std_logic'(sdbuf_avalon_slave_0_arb_counter_enable) = '1' then 
        sdbuf_avalon_slave_0_arb_share_counter <= sdbuf_avalon_slave_0_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --sdbuf_avalon_slave_0_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdbuf_avalon_slave_0_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((sdbuf_avalon_slave_0_master_qreq_vector AND end_xfer_arb_share_counter_term_sdbuf_avalon_slave_0)) OR ((end_xfer_arb_share_counter_term_sdbuf_avalon_slave_0 AND NOT sdbuf_avalon_slave_0_non_bursting_master_requests)))) = '1' then 
        sdbuf_avalon_slave_0_slavearbiterlockenable <= or_reduce(sdbuf_avalon_slave_0_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master sdbuf/avalon_slave_0 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= sdbuf_avalon_slave_0_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --sdbuf_avalon_slave_0_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  sdbuf_avalon_slave_0_slavearbiterlockenable2 <= or_reduce(sdbuf_avalon_slave_0_arb_share_counter_next_value);
  --cpu_0/data_master sdbuf/avalon_slave_0 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= sdbuf_avalon_slave_0_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --sdbuf_avalon_slave_0_any_continuerequest at least one master continues requesting, which is an e_assign
  sdbuf_avalon_slave_0_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_sdbuf_avalon_slave_0 <= internal_cpu_0_data_master_requests_sdbuf_avalon_slave_0;
  --master is always granted when requested
  internal_cpu_0_data_master_granted_sdbuf_avalon_slave_0 <= internal_cpu_0_data_master_qualified_request_sdbuf_avalon_slave_0;
  --cpu_0/data_master saved-grant sdbuf/avalon_slave_0, which is an e_assign
  cpu_0_data_master_saved_grant_sdbuf_avalon_slave_0 <= internal_cpu_0_data_master_requests_sdbuf_avalon_slave_0;
  --allow new arb cycle for sdbuf/avalon_slave_0, which is an e_assign
  sdbuf_avalon_slave_0_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  sdbuf_avalon_slave_0_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  sdbuf_avalon_slave_0_master_qreq_vector <= std_logic'('1');
  --sdbuf_avalon_slave_0_reset_n assignment, which is an e_assign
  sdbuf_avalon_slave_0_reset_n <= reset_n;
  sdbuf_avalon_slave_0_chipselect <= internal_cpu_0_data_master_granted_sdbuf_avalon_slave_0;
  --sdbuf_avalon_slave_0_firsttransfer first transaction, which is an e_assign
  sdbuf_avalon_slave_0_firsttransfer <= A_WE_StdLogic((std_logic'(sdbuf_avalon_slave_0_begins_xfer) = '1'), sdbuf_avalon_slave_0_unreg_firsttransfer, sdbuf_avalon_slave_0_reg_firsttransfer);
  --sdbuf_avalon_slave_0_unreg_firsttransfer first transaction, which is an e_assign
  sdbuf_avalon_slave_0_unreg_firsttransfer <= NOT ((sdbuf_avalon_slave_0_slavearbiterlockenable AND sdbuf_avalon_slave_0_any_continuerequest));
  --sdbuf_avalon_slave_0_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sdbuf_avalon_slave_0_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(sdbuf_avalon_slave_0_begins_xfer) = '1' then 
        sdbuf_avalon_slave_0_reg_firsttransfer <= sdbuf_avalon_slave_0_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --sdbuf_avalon_slave_0_beginbursttransfer_internal begin burst transfer, which is an e_assign
  sdbuf_avalon_slave_0_beginbursttransfer_internal <= sdbuf_avalon_slave_0_begins_xfer;
  --sdbuf_avalon_slave_0_read assignment, which is an e_mux
  sdbuf_avalon_slave_0_read <= internal_cpu_0_data_master_granted_sdbuf_avalon_slave_0 AND cpu_0_data_master_read;
  shifted_address_to_sdbuf_avalon_slave_0_from_cpu_0_data_master <= A_EXT (Std_Logic_Vector'(A_SRL(cpu_0_data_master_address_to_slave,std_logic_vector'("00000000000000000000000000000010")) & A_ToStdLogicVector(cpu_0_data_master_dbs_address(1)) & A_ToStdLogicVector(std_logic'('0'))), 21);
  --sdbuf_avalon_slave_0_address mux, which is an e_mux
  sdbuf_avalon_slave_0_address <= A_EXT (A_SRL(shifted_address_to_sdbuf_avalon_slave_0_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000001")), 8);
  --d1_sdbuf_avalon_slave_0_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_sdbuf_avalon_slave_0_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_sdbuf_avalon_slave_0_end_xfer <= sdbuf_avalon_slave_0_end_xfer;
    end if;

  end process;

  --sdbuf_avalon_slave_0_waits_for_read in a cycle, which is an e_mux
  sdbuf_avalon_slave_0_waits_for_read <= sdbuf_avalon_slave_0_in_a_read_cycle AND sdbuf_avalon_slave_0_begins_xfer;
  --sdbuf_avalon_slave_0_in_a_read_cycle assignment, which is an e_assign
  sdbuf_avalon_slave_0_in_a_read_cycle <= internal_cpu_0_data_master_granted_sdbuf_avalon_slave_0 AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= sdbuf_avalon_slave_0_in_a_read_cycle;
  --sdbuf_avalon_slave_0_waits_for_write in a cycle, which is an e_mux
  sdbuf_avalon_slave_0_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sdbuf_avalon_slave_0_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --sdbuf_avalon_slave_0_in_a_write_cycle assignment, which is an e_assign
  sdbuf_avalon_slave_0_in_a_write_cycle <= internal_cpu_0_data_master_granted_sdbuf_avalon_slave_0 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= sdbuf_avalon_slave_0_in_a_write_cycle;
  wait_for_sdbuf_avalon_slave_0_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_sdbuf_avalon_slave_0 <= internal_cpu_0_data_master_granted_sdbuf_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_sdbuf_avalon_slave_0 <= internal_cpu_0_data_master_qualified_request_sdbuf_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_sdbuf_avalon_slave_0 <= internal_cpu_0_data_master_requests_sdbuf_avalon_slave_0;
--synthesis translate_off
    --sdbuf/avalon_slave_0 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity sram_avalon_slave_0_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_0_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_data_master_dbs_write_16 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal cpu_0_data_master_no_byte_enables_and_last_term : IN STD_LOGIC;
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_0_instruction_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_instruction_master_read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sram_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal cpu_0_data_master_byteenable_sram_avalon_slave_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_0_data_master_granted_sram_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_sram_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_sram_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_sram_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_granted_sram_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_qualified_request_sram_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_read_data_valid_sram_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_0_instruction_master_requests_sram_avalon_slave_0 : OUT STD_LOGIC;
                 signal d1_sram_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                 signal sram_avalon_slave_0_address : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                 signal sram_avalon_slave_0_byteenable : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal sram_avalon_slave_0_chipselect : OUT STD_LOGIC;
                 signal sram_avalon_slave_0_read : OUT STD_LOGIC;
                 signal sram_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sram_avalon_slave_0_write : OUT STD_LOGIC;
                 signal sram_avalon_slave_0_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
              );
end entity sram_avalon_slave_0_arbitrator;


architecture europa of sram_avalon_slave_0_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_byteenable_sram_avalon_slave_0_segment_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_byteenable_sram_avalon_slave_0_segment_1 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_instruction_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_instruction_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_instruction_master_continuerequest :  STD_LOGIC;
                signal cpu_0_instruction_master_saved_grant_sram_avalon_slave_0 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_sram_avalon_slave_0 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_byteenable_sram_avalon_slave_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_cpu_0_data_master_granted_sram_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_sram_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_sram_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_granted_sram_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_qualified_request_sram_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_0_instruction_master_requests_sram_avalon_slave_0 :  STD_LOGIC;
                signal last_cycle_cpu_0_data_master_granted_slave_sram_avalon_slave_0 :  STD_LOGIC;
                signal last_cycle_cpu_0_instruction_master_granted_slave_sram_avalon_slave_0 :  STD_LOGIC;
                signal shifted_address_to_sram_avalon_slave_0_from_cpu_0_data_master :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal shifted_address_to_sram_avalon_slave_0_from_cpu_0_instruction_master :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal sram_avalon_slave_0_allgrants :  STD_LOGIC;
                signal sram_avalon_slave_0_allow_new_arb_cycle :  STD_LOGIC;
                signal sram_avalon_slave_0_any_bursting_master_saved_grant :  STD_LOGIC;
                signal sram_avalon_slave_0_any_continuerequest :  STD_LOGIC;
                signal sram_avalon_slave_0_arb_addend :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sram_avalon_slave_0_arb_counter_enable :  STD_LOGIC;
                signal sram_avalon_slave_0_arb_share_counter :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal sram_avalon_slave_0_arb_share_counter_next_value :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal sram_avalon_slave_0_arb_share_set_values :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal sram_avalon_slave_0_arb_winner :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sram_avalon_slave_0_arbitration_holdoff_internal :  STD_LOGIC;
                signal sram_avalon_slave_0_beginbursttransfer_internal :  STD_LOGIC;
                signal sram_avalon_slave_0_begins_xfer :  STD_LOGIC;
                signal sram_avalon_slave_0_chosen_master_double_vector :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal sram_avalon_slave_0_chosen_master_rot_left :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sram_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal sram_avalon_slave_0_firsttransfer :  STD_LOGIC;
                signal sram_avalon_slave_0_grant_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sram_avalon_slave_0_in_a_read_cycle :  STD_LOGIC;
                signal sram_avalon_slave_0_in_a_write_cycle :  STD_LOGIC;
                signal sram_avalon_slave_0_master_qreq_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sram_avalon_slave_0_non_bursting_master_requests :  STD_LOGIC;
                signal sram_avalon_slave_0_reg_firsttransfer :  STD_LOGIC;
                signal sram_avalon_slave_0_saved_chosen_master_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sram_avalon_slave_0_slavearbiterlockenable :  STD_LOGIC;
                signal sram_avalon_slave_0_slavearbiterlockenable2 :  STD_LOGIC;
                signal sram_avalon_slave_0_unreg_firsttransfer :  STD_LOGIC;
                signal sram_avalon_slave_0_waits_for_read :  STD_LOGIC;
                signal sram_avalon_slave_0_waits_for_write :  STD_LOGIC;
                signal wait_for_sram_avalon_slave_0_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT sram_avalon_slave_0_end_xfer;
    end if;

  end process;

  sram_avalon_slave_0_begins_xfer <= NOT d1_reasons_to_wait AND ((internal_cpu_0_data_master_qualified_request_sram_avalon_slave_0 OR internal_cpu_0_instruction_master_qualified_request_sram_avalon_slave_0));
  --assign sram_avalon_slave_0_readdata_from_sa = sram_avalon_slave_0_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  sram_avalon_slave_0_readdata_from_sa <= sram_avalon_slave_0_readdata;
  internal_cpu_0_data_master_requests_sram_avalon_slave_0 <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(20 DOWNTO 19) & std_logic_vector'("0000000000000000000")) = std_logic_vector'("010000000000000000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --sram_avalon_slave_0_arb_share_counter set values, which is an e_mux
  sram_avalon_slave_0_arb_share_set_values <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_sram_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((internal_cpu_0_instruction_master_granted_sram_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_sram_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((internal_cpu_0_instruction_master_granted_sram_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000001"))))), 3);
  --sram_avalon_slave_0_non_bursting_master_requests mux, which is an e_mux
  sram_avalon_slave_0_non_bursting_master_requests <= ((internal_cpu_0_data_master_requests_sram_avalon_slave_0 OR internal_cpu_0_instruction_master_requests_sram_avalon_slave_0) OR internal_cpu_0_data_master_requests_sram_avalon_slave_0) OR internal_cpu_0_instruction_master_requests_sram_avalon_slave_0;
  --sram_avalon_slave_0_any_bursting_master_saved_grant mux, which is an e_mux
  sram_avalon_slave_0_any_bursting_master_saved_grant <= std_logic'('0');
  --sram_avalon_slave_0_arb_share_counter_next_value assignment, which is an e_assign
  sram_avalon_slave_0_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(sram_avalon_slave_0_firsttransfer) = '1'), (((std_logic_vector'("000000000000000000000000000000") & (sram_avalon_slave_0_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(sram_avalon_slave_0_arb_share_counter)) = '1'), (((std_logic_vector'("000000000000000000000000000000") & (sram_avalon_slave_0_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 3);
  --sram_avalon_slave_0_allgrants all slave grants, which is an e_mux
  sram_avalon_slave_0_allgrants <= (((or_reduce(sram_avalon_slave_0_grant_vector)) OR (or_reduce(sram_avalon_slave_0_grant_vector))) OR (or_reduce(sram_avalon_slave_0_grant_vector))) OR (or_reduce(sram_avalon_slave_0_grant_vector));
  --sram_avalon_slave_0_end_xfer assignment, which is an e_assign
  sram_avalon_slave_0_end_xfer <= NOT ((sram_avalon_slave_0_waits_for_read OR sram_avalon_slave_0_waits_for_write));
  --end_xfer_arb_share_counter_term_sram_avalon_slave_0 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_sram_avalon_slave_0 <= sram_avalon_slave_0_end_xfer AND (((NOT sram_avalon_slave_0_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --sram_avalon_slave_0_arb_share_counter arbitration counter enable, which is an e_assign
  sram_avalon_slave_0_arb_counter_enable <= ((end_xfer_arb_share_counter_term_sram_avalon_slave_0 AND sram_avalon_slave_0_allgrants)) OR ((end_xfer_arb_share_counter_term_sram_avalon_slave_0 AND NOT sram_avalon_slave_0_non_bursting_master_requests));
  --sram_avalon_slave_0_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sram_avalon_slave_0_arb_share_counter <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      if std_logic'(sram_avalon_slave_0_arb_counter_enable) = '1' then 
        sram_avalon_slave_0_arb_share_counter <= sram_avalon_slave_0_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --sram_avalon_slave_0_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sram_avalon_slave_0_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((or_reduce(sram_avalon_slave_0_master_qreq_vector) AND end_xfer_arb_share_counter_term_sram_avalon_slave_0)) OR ((end_xfer_arb_share_counter_term_sram_avalon_slave_0 AND NOT sram_avalon_slave_0_non_bursting_master_requests)))) = '1' then 
        sram_avalon_slave_0_slavearbiterlockenable <= or_reduce(sram_avalon_slave_0_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master sram/avalon_slave_0 arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= sram_avalon_slave_0_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --sram_avalon_slave_0_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  sram_avalon_slave_0_slavearbiterlockenable2 <= or_reduce(sram_avalon_slave_0_arb_share_counter_next_value);
  --cpu_0/data_master sram/avalon_slave_0 arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= sram_avalon_slave_0_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --cpu_0/instruction_master sram/avalon_slave_0 arbiterlock, which is an e_assign
  cpu_0_instruction_master_arbiterlock <= sram_avalon_slave_0_slavearbiterlockenable AND cpu_0_instruction_master_continuerequest;
  --cpu_0/instruction_master sram/avalon_slave_0 arbiterlock2, which is an e_assign
  cpu_0_instruction_master_arbiterlock2 <= sram_avalon_slave_0_slavearbiterlockenable2 AND cpu_0_instruction_master_continuerequest;
  --cpu_0/instruction_master granted sram/avalon_slave_0 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_0_instruction_master_granted_slave_sram_avalon_slave_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_0_instruction_master_granted_slave_sram_avalon_slave_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_0_instruction_master_saved_grant_sram_avalon_slave_0) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((sram_avalon_slave_0_arbitration_holdoff_internal OR NOT internal_cpu_0_instruction_master_requests_sram_avalon_slave_0))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_0_instruction_master_granted_slave_sram_avalon_slave_0))))));
    end if;

  end process;

  --cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  cpu_0_instruction_master_continuerequest <= last_cycle_cpu_0_instruction_master_granted_slave_sram_avalon_slave_0 AND internal_cpu_0_instruction_master_requests_sram_avalon_slave_0;
  --sram_avalon_slave_0_any_continuerequest at least one master continues requesting, which is an e_mux
  sram_avalon_slave_0_any_continuerequest <= cpu_0_instruction_master_continuerequest OR cpu_0_data_master_continuerequest;
  internal_cpu_0_data_master_qualified_request_sram_avalon_slave_0 <= internal_cpu_0_data_master_requests_sram_avalon_slave_0 AND NOT (((((((NOT cpu_0_data_master_waitrequest OR cpu_0_data_master_no_byte_enables_and_last_term) OR NOT(or_reduce(internal_cpu_0_data_master_byteenable_sram_avalon_slave_0)))) AND cpu_0_data_master_write)) OR cpu_0_instruction_master_arbiterlock));
  --sram_avalon_slave_0_writedata mux, which is an e_mux
  sram_avalon_slave_0_writedata <= cpu_0_data_master_dbs_write_16;
  internal_cpu_0_instruction_master_requests_sram_avalon_slave_0 <= ((to_std_logic(((Std_Logic_Vector'(cpu_0_instruction_master_address_to_slave(20 DOWNTO 19) & std_logic_vector'("0000000000000000000")) = std_logic_vector'("010000000000000000000")))) AND (cpu_0_instruction_master_read))) AND cpu_0_instruction_master_read;
  --cpu_0/data_master granted sram/avalon_slave_0 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_0_data_master_granted_slave_sram_avalon_slave_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_0_data_master_granted_slave_sram_avalon_slave_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_0_data_master_saved_grant_sram_avalon_slave_0) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((sram_avalon_slave_0_arbitration_holdoff_internal OR NOT internal_cpu_0_data_master_requests_sram_avalon_slave_0))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_0_data_master_granted_slave_sram_avalon_slave_0))))));
    end if;

  end process;

  --cpu_0_data_master_continuerequest continued request, which is an e_mux
  cpu_0_data_master_continuerequest <= last_cycle_cpu_0_data_master_granted_slave_sram_avalon_slave_0 AND internal_cpu_0_data_master_requests_sram_avalon_slave_0;
  internal_cpu_0_instruction_master_qualified_request_sram_avalon_slave_0 <= internal_cpu_0_instruction_master_requests_sram_avalon_slave_0 AND NOT (cpu_0_data_master_arbiterlock);
  --allow new arb cycle for sram/avalon_slave_0, which is an e_assign
  sram_avalon_slave_0_allow_new_arb_cycle <= NOT cpu_0_data_master_arbiterlock AND NOT cpu_0_instruction_master_arbiterlock;
  --cpu_0/instruction_master assignment into master qualified-requests vector for sram/avalon_slave_0, which is an e_assign
  sram_avalon_slave_0_master_qreq_vector(0) <= internal_cpu_0_instruction_master_qualified_request_sram_avalon_slave_0;
  --cpu_0/instruction_master grant sram/avalon_slave_0, which is an e_assign
  internal_cpu_0_instruction_master_granted_sram_avalon_slave_0 <= sram_avalon_slave_0_grant_vector(0);
  --cpu_0/instruction_master saved-grant sram/avalon_slave_0, which is an e_assign
  cpu_0_instruction_master_saved_grant_sram_avalon_slave_0 <= sram_avalon_slave_0_arb_winner(0) AND internal_cpu_0_instruction_master_requests_sram_avalon_slave_0;
  --cpu_0/data_master assignment into master qualified-requests vector for sram/avalon_slave_0, which is an e_assign
  sram_avalon_slave_0_master_qreq_vector(1) <= internal_cpu_0_data_master_qualified_request_sram_avalon_slave_0;
  --cpu_0/data_master grant sram/avalon_slave_0, which is an e_assign
  internal_cpu_0_data_master_granted_sram_avalon_slave_0 <= sram_avalon_slave_0_grant_vector(1);
  --cpu_0/data_master saved-grant sram/avalon_slave_0, which is an e_assign
  cpu_0_data_master_saved_grant_sram_avalon_slave_0 <= sram_avalon_slave_0_arb_winner(1) AND internal_cpu_0_data_master_requests_sram_avalon_slave_0;
  --sram/avalon_slave_0 chosen-master double-vector, which is an e_assign
  sram_avalon_slave_0_chosen_master_double_vector <= A_EXT (((std_logic_vector'("0") & ((sram_avalon_slave_0_master_qreq_vector & sram_avalon_slave_0_master_qreq_vector))) AND (((std_logic_vector'("0") & (Std_Logic_Vector'(NOT sram_avalon_slave_0_master_qreq_vector & NOT sram_avalon_slave_0_master_qreq_vector))) + (std_logic_vector'("000") & (sram_avalon_slave_0_arb_addend))))), 4);
  --stable onehot encoding of arb winner
  sram_avalon_slave_0_arb_winner <= A_WE_StdLogicVector((std_logic'(((sram_avalon_slave_0_allow_new_arb_cycle AND or_reduce(sram_avalon_slave_0_grant_vector)))) = '1'), sram_avalon_slave_0_grant_vector, sram_avalon_slave_0_saved_chosen_master_vector);
  --saved sram_avalon_slave_0_grant_vector, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sram_avalon_slave_0_saved_chosen_master_vector <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(sram_avalon_slave_0_allow_new_arb_cycle) = '1' then 
        sram_avalon_slave_0_saved_chosen_master_vector <= A_WE_StdLogicVector((std_logic'(or_reduce(sram_avalon_slave_0_grant_vector)) = '1'), sram_avalon_slave_0_grant_vector, sram_avalon_slave_0_saved_chosen_master_vector);
      end if;
    end if;

  end process;

  --onehot encoding of chosen master
  sram_avalon_slave_0_grant_vector <= Std_Logic_Vector'(A_ToStdLogicVector(((sram_avalon_slave_0_chosen_master_double_vector(1) OR sram_avalon_slave_0_chosen_master_double_vector(3)))) & A_ToStdLogicVector(((sram_avalon_slave_0_chosen_master_double_vector(0) OR sram_avalon_slave_0_chosen_master_double_vector(2)))));
  --sram/avalon_slave_0 chosen master rotated left, which is an e_assign
  sram_avalon_slave_0_chosen_master_rot_left <= A_EXT (A_WE_StdLogicVector((((A_SLL(sram_avalon_slave_0_arb_winner,std_logic_vector'("00000000000000000000000000000001")))) /= std_logic_vector'("00")), (std_logic_vector'("000000000000000000000000000000") & ((A_SLL(sram_avalon_slave_0_arb_winner,std_logic_vector'("00000000000000000000000000000001"))))), std_logic_vector'("00000000000000000000000000000001")), 2);
  --sram/avalon_slave_0's addend for next-master-grant
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sram_avalon_slave_0_arb_addend <= std_logic_vector'("01");
    elsif clk'event and clk = '1' then
      if std_logic'(or_reduce(sram_avalon_slave_0_grant_vector)) = '1' then 
        sram_avalon_slave_0_arb_addend <= A_WE_StdLogicVector((std_logic'(sram_avalon_slave_0_end_xfer) = '1'), sram_avalon_slave_0_chosen_master_rot_left, sram_avalon_slave_0_grant_vector);
      end if;
    end if;

  end process;

  sram_avalon_slave_0_chipselect <= internal_cpu_0_data_master_granted_sram_avalon_slave_0 OR internal_cpu_0_instruction_master_granted_sram_avalon_slave_0;
  --sram_avalon_slave_0_firsttransfer first transaction, which is an e_assign
  sram_avalon_slave_0_firsttransfer <= A_WE_StdLogic((std_logic'(sram_avalon_slave_0_begins_xfer) = '1'), sram_avalon_slave_0_unreg_firsttransfer, sram_avalon_slave_0_reg_firsttransfer);
  --sram_avalon_slave_0_unreg_firsttransfer first transaction, which is an e_assign
  sram_avalon_slave_0_unreg_firsttransfer <= NOT ((sram_avalon_slave_0_slavearbiterlockenable AND sram_avalon_slave_0_any_continuerequest));
  --sram_avalon_slave_0_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sram_avalon_slave_0_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(sram_avalon_slave_0_begins_xfer) = '1' then 
        sram_avalon_slave_0_reg_firsttransfer <= sram_avalon_slave_0_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --sram_avalon_slave_0_beginbursttransfer_internal begin burst transfer, which is an e_assign
  sram_avalon_slave_0_beginbursttransfer_internal <= sram_avalon_slave_0_begins_xfer;
  --sram_avalon_slave_0_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  sram_avalon_slave_0_arbitration_holdoff_internal <= sram_avalon_slave_0_begins_xfer AND sram_avalon_slave_0_firsttransfer;
  --sram_avalon_slave_0_read assignment, which is an e_mux
  sram_avalon_slave_0_read <= ((internal_cpu_0_data_master_granted_sram_avalon_slave_0 AND cpu_0_data_master_read)) OR ((internal_cpu_0_instruction_master_granted_sram_avalon_slave_0 AND cpu_0_instruction_master_read));
  --sram_avalon_slave_0_write assignment, which is an e_mux
  sram_avalon_slave_0_write <= internal_cpu_0_data_master_granted_sram_avalon_slave_0 AND cpu_0_data_master_write;
  shifted_address_to_sram_avalon_slave_0_from_cpu_0_data_master <= A_EXT (Std_Logic_Vector'(A_SRL(cpu_0_data_master_address_to_slave,std_logic_vector'("00000000000000000000000000000010")) & A_ToStdLogicVector(cpu_0_data_master_dbs_address(1)) & A_ToStdLogicVector(std_logic'('0'))), 21);
  --sram_avalon_slave_0_address mux, which is an e_mux
  sram_avalon_slave_0_address <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_sram_avalon_slave_0)) = '1'), (A_SRL(shifted_address_to_sram_avalon_slave_0_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000001"))), (A_SRL(shifted_address_to_sram_avalon_slave_0_from_cpu_0_instruction_master,std_logic_vector'("00000000000000000000000000000001")))), 18);
  shifted_address_to_sram_avalon_slave_0_from_cpu_0_instruction_master <= A_EXT (Std_Logic_Vector'(A_SRL(cpu_0_instruction_master_address_to_slave,std_logic_vector'("00000000000000000000000000000010")) & A_ToStdLogicVector(cpu_0_instruction_master_dbs_address(1)) & A_ToStdLogicVector(std_logic'('0'))), 21);
  --d1_sram_avalon_slave_0_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_sram_avalon_slave_0_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_sram_avalon_slave_0_end_xfer <= sram_avalon_slave_0_end_xfer;
    end if;

  end process;

  --sram_avalon_slave_0_waits_for_read in a cycle, which is an e_mux
  sram_avalon_slave_0_waits_for_read <= sram_avalon_slave_0_in_a_read_cycle AND sram_avalon_slave_0_begins_xfer;
  --sram_avalon_slave_0_in_a_read_cycle assignment, which is an e_assign
  sram_avalon_slave_0_in_a_read_cycle <= ((internal_cpu_0_data_master_granted_sram_avalon_slave_0 AND cpu_0_data_master_read)) OR ((internal_cpu_0_instruction_master_granted_sram_avalon_slave_0 AND cpu_0_instruction_master_read));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= sram_avalon_slave_0_in_a_read_cycle;
  --sram_avalon_slave_0_waits_for_write in a cycle, which is an e_mux
  sram_avalon_slave_0_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sram_avalon_slave_0_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --sram_avalon_slave_0_in_a_write_cycle assignment, which is an e_assign
  sram_avalon_slave_0_in_a_write_cycle <= internal_cpu_0_data_master_granted_sram_avalon_slave_0 AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= sram_avalon_slave_0_in_a_write_cycle;
  wait_for_sram_avalon_slave_0_counter <= std_logic'('0');
  --sram_avalon_slave_0_byteenable byte enable port mux, which is an e_mux
  sram_avalon_slave_0_byteenable <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_0_data_master_granted_sram_avalon_slave_0)) = '1'), (std_logic_vector'("000000000000000000000000000000") & (internal_cpu_0_data_master_byteenable_sram_avalon_slave_0)), -SIGNED(std_logic_vector'("00000000000000000000000000000001"))), 2);
  (cpu_0_data_master_byteenable_sram_avalon_slave_0_segment_1(1), cpu_0_data_master_byteenable_sram_avalon_slave_0_segment_1(0), cpu_0_data_master_byteenable_sram_avalon_slave_0_segment_0(1), cpu_0_data_master_byteenable_sram_avalon_slave_0_segment_0(0)) <= cpu_0_data_master_byteenable;
  internal_cpu_0_data_master_byteenable_sram_avalon_slave_0 <= A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_dbs_address(1)))) = std_logic_vector'("00000000000000000000000000000000"))), cpu_0_data_master_byteenable_sram_avalon_slave_0_segment_0, cpu_0_data_master_byteenable_sram_avalon_slave_0_segment_1);
  --vhdl renameroo for output signals
  cpu_0_data_master_byteenable_sram_avalon_slave_0 <= internal_cpu_0_data_master_byteenable_sram_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_sram_avalon_slave_0 <= internal_cpu_0_data_master_granted_sram_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_sram_avalon_slave_0 <= internal_cpu_0_data_master_qualified_request_sram_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_sram_avalon_slave_0 <= internal_cpu_0_data_master_requests_sram_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_granted_sram_avalon_slave_0 <= internal_cpu_0_instruction_master_granted_sram_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_qualified_request_sram_avalon_slave_0 <= internal_cpu_0_instruction_master_qualified_request_sram_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_0_instruction_master_requests_sram_avalon_slave_0 <= internal_cpu_0_instruction_master_requests_sram_avalon_slave_0;
--synthesis translate_off
    --sram/avalon_slave_0 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line4 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_0_data_master_granted_sram_avalon_slave_0))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_0_instruction_master_granted_sram_avalon_slave_0))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line4, now);
          write(write_line4, string'(": "));
          write(write_line4, string'("> 1 of grant signals are active simultaneously"));
          write(output, write_line4.all);
          deallocate (write_line4);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --saved_grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line5 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_0_data_master_saved_grant_sram_avalon_slave_0))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_0_instruction_master_saved_grant_sram_avalon_slave_0))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line5, now);
          write(write_line5, string'(": "));
          write(write_line5, string'("> 1 of saved_grant signals are active simultaneously"));
          write(output, write_line5.all);
          deallocate (write_line5);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity vga_vga_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_0_data_master_read : IN STD_LOGIC;
                 signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_0_data_master_write : IN STD_LOGIC;
                 signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal vga_vga_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal cpu_0_data_master_granted_vga_vga : OUT STD_LOGIC;
                 signal cpu_0_data_master_qualified_request_vga_vga : OUT STD_LOGIC;
                 signal cpu_0_data_master_read_data_valid_vga_vga : OUT STD_LOGIC;
                 signal cpu_0_data_master_requests_vga_vga : OUT STD_LOGIC;
                 signal d1_vga_vga_end_xfer : OUT STD_LOGIC;
                 signal vga_vga_address : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
                 signal vga_vga_chipselect : OUT STD_LOGIC;
                 signal vga_vga_read : OUT STD_LOGIC;
                 signal vga_vga_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal vga_vga_reset : OUT STD_LOGIC;
                 signal vga_vga_write : OUT STD_LOGIC;
                 signal vga_vga_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity vga_vga_arbitrator;


architecture europa of vga_vga_arbitrator is
                signal cpu_0_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_0_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_0_data_master_continuerequest :  STD_LOGIC;
                signal cpu_0_data_master_saved_grant_vga_vga :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_vga_vga :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_0_data_master_granted_vga_vga :  STD_LOGIC;
                signal internal_cpu_0_data_master_qualified_request_vga_vga :  STD_LOGIC;
                signal internal_cpu_0_data_master_requests_vga_vga :  STD_LOGIC;
                signal shifted_address_to_vga_vga_from_cpu_0_data_master :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal vga_vga_allgrants :  STD_LOGIC;
                signal vga_vga_allow_new_arb_cycle :  STD_LOGIC;
                signal vga_vga_any_bursting_master_saved_grant :  STD_LOGIC;
                signal vga_vga_any_continuerequest :  STD_LOGIC;
                signal vga_vga_arb_counter_enable :  STD_LOGIC;
                signal vga_vga_arb_share_counter :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal vga_vga_arb_share_counter_next_value :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal vga_vga_arb_share_set_values :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal vga_vga_beginbursttransfer_internal :  STD_LOGIC;
                signal vga_vga_begins_xfer :  STD_LOGIC;
                signal vga_vga_end_xfer :  STD_LOGIC;
                signal vga_vga_firsttransfer :  STD_LOGIC;
                signal vga_vga_grant_vector :  STD_LOGIC;
                signal vga_vga_in_a_read_cycle :  STD_LOGIC;
                signal vga_vga_in_a_write_cycle :  STD_LOGIC;
                signal vga_vga_master_qreq_vector :  STD_LOGIC;
                signal vga_vga_non_bursting_master_requests :  STD_LOGIC;
                signal vga_vga_reg_firsttransfer :  STD_LOGIC;
                signal vga_vga_slavearbiterlockenable :  STD_LOGIC;
                signal vga_vga_slavearbiterlockenable2 :  STD_LOGIC;
                signal vga_vga_unreg_firsttransfer :  STD_LOGIC;
                signal vga_vga_waits_for_read :  STD_LOGIC;
                signal vga_vga_waits_for_write :  STD_LOGIC;
                signal wait_for_vga_vga_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT vga_vga_end_xfer;
    end if;

  end process;

  vga_vga_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_0_data_master_qualified_request_vga_vga);
  --assign vga_vga_readdata_from_sa = vga_vga_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  vga_vga_readdata_from_sa <= vga_vga_readdata;
  internal_cpu_0_data_master_requests_vga_vga <= to_std_logic(((Std_Logic_Vector'(cpu_0_data_master_address_to_slave(20 DOWNTO 13) & std_logic_vector'("0000000000000")) = std_logic_vector'("000000010000000000000")))) AND ((cpu_0_data_master_read OR cpu_0_data_master_write));
  --vga_vga_arb_share_counter set values, which is an e_mux
  vga_vga_arb_share_set_values <= std_logic_vector'("001");
  --vga_vga_non_bursting_master_requests mux, which is an e_mux
  vga_vga_non_bursting_master_requests <= internal_cpu_0_data_master_requests_vga_vga;
  --vga_vga_any_bursting_master_saved_grant mux, which is an e_mux
  vga_vga_any_bursting_master_saved_grant <= std_logic'('0');
  --vga_vga_arb_share_counter_next_value assignment, which is an e_assign
  vga_vga_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(vga_vga_firsttransfer) = '1'), (((std_logic_vector'("000000000000000000000000000000") & (vga_vga_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(vga_vga_arb_share_counter)) = '1'), (((std_logic_vector'("000000000000000000000000000000") & (vga_vga_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 3);
  --vga_vga_allgrants all slave grants, which is an e_mux
  vga_vga_allgrants <= vga_vga_grant_vector;
  --vga_vga_end_xfer assignment, which is an e_assign
  vga_vga_end_xfer <= NOT ((vga_vga_waits_for_read OR vga_vga_waits_for_write));
  --end_xfer_arb_share_counter_term_vga_vga arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_vga_vga <= vga_vga_end_xfer AND (((NOT vga_vga_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --vga_vga_arb_share_counter arbitration counter enable, which is an e_assign
  vga_vga_arb_counter_enable <= ((end_xfer_arb_share_counter_term_vga_vga AND vga_vga_allgrants)) OR ((end_xfer_arb_share_counter_term_vga_vga AND NOT vga_vga_non_bursting_master_requests));
  --vga_vga_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      vga_vga_arb_share_counter <= std_logic_vector'("000");
    elsif clk'event and clk = '1' then
      if std_logic'(vga_vga_arb_counter_enable) = '1' then 
        vga_vga_arb_share_counter <= vga_vga_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --vga_vga_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      vga_vga_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((vga_vga_master_qreq_vector AND end_xfer_arb_share_counter_term_vga_vga)) OR ((end_xfer_arb_share_counter_term_vga_vga AND NOT vga_vga_non_bursting_master_requests)))) = '1' then 
        vga_vga_slavearbiterlockenable <= or_reduce(vga_vga_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu_0/data_master vga/vga arbiterlock, which is an e_assign
  cpu_0_data_master_arbiterlock <= vga_vga_slavearbiterlockenable AND cpu_0_data_master_continuerequest;
  --vga_vga_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  vga_vga_slavearbiterlockenable2 <= or_reduce(vga_vga_arb_share_counter_next_value);
  --cpu_0/data_master vga/vga arbiterlock2, which is an e_assign
  cpu_0_data_master_arbiterlock2 <= vga_vga_slavearbiterlockenable2 AND cpu_0_data_master_continuerequest;
  --vga_vga_any_continuerequest at least one master continues requesting, which is an e_assign
  vga_vga_any_continuerequest <= std_logic'('1');
  --cpu_0_data_master_continuerequest continued request, which is an e_assign
  cpu_0_data_master_continuerequest <= std_logic'('1');
  internal_cpu_0_data_master_qualified_request_vga_vga <= internal_cpu_0_data_master_requests_vga_vga AND NOT (((NOT cpu_0_data_master_waitrequest) AND cpu_0_data_master_write));
  --vga_vga_writedata mux, which is an e_mux
  vga_vga_writedata <= cpu_0_data_master_writedata;
  --master is always granted when requested
  internal_cpu_0_data_master_granted_vga_vga <= internal_cpu_0_data_master_qualified_request_vga_vga;
  --cpu_0/data_master saved-grant vga/vga, which is an e_assign
  cpu_0_data_master_saved_grant_vga_vga <= internal_cpu_0_data_master_requests_vga_vga;
  --allow new arb cycle for vga/vga, which is an e_assign
  vga_vga_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  vga_vga_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  vga_vga_master_qreq_vector <= std_logic'('1');
  --~vga_vga_reset assignment, which is an e_assign
  vga_vga_reset <= NOT reset_n;
  vga_vga_chipselect <= internal_cpu_0_data_master_granted_vga_vga;
  --vga_vga_firsttransfer first transaction, which is an e_assign
  vga_vga_firsttransfer <= A_WE_StdLogic((std_logic'(vga_vga_begins_xfer) = '1'), vga_vga_unreg_firsttransfer, vga_vga_reg_firsttransfer);
  --vga_vga_unreg_firsttransfer first transaction, which is an e_assign
  vga_vga_unreg_firsttransfer <= NOT ((vga_vga_slavearbiterlockenable AND vga_vga_any_continuerequest));
  --vga_vga_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      vga_vga_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(vga_vga_begins_xfer) = '1' then 
        vga_vga_reg_firsttransfer <= vga_vga_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --vga_vga_beginbursttransfer_internal begin burst transfer, which is an e_assign
  vga_vga_beginbursttransfer_internal <= vga_vga_begins_xfer;
  --vga_vga_read assignment, which is an e_mux
  vga_vga_read <= internal_cpu_0_data_master_granted_vga_vga AND cpu_0_data_master_read;
  --vga_vga_write assignment, which is an e_mux
  vga_vga_write <= internal_cpu_0_data_master_granted_vga_vga AND cpu_0_data_master_write;
  shifted_address_to_vga_vga_from_cpu_0_data_master <= cpu_0_data_master_address_to_slave;
  --vga_vga_address mux, which is an e_mux
  vga_vga_address <= A_EXT (A_SRL(shifted_address_to_vga_vga_from_cpu_0_data_master,std_logic_vector'("00000000000000000000000000000010")), 11);
  --d1_vga_vga_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_vga_vga_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_vga_vga_end_xfer <= vga_vga_end_xfer;
    end if;

  end process;

  --vga_vga_waits_for_read in a cycle, which is an e_mux
  vga_vga_waits_for_read <= vga_vga_in_a_read_cycle AND vga_vga_begins_xfer;
  --vga_vga_in_a_read_cycle assignment, which is an e_assign
  vga_vga_in_a_read_cycle <= internal_cpu_0_data_master_granted_vga_vga AND cpu_0_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= vga_vga_in_a_read_cycle;
  --vga_vga_waits_for_write in a cycle, which is an e_mux
  vga_vga_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(vga_vga_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --vga_vga_in_a_write_cycle assignment, which is an e_assign
  vga_vga_in_a_write_cycle <= internal_cpu_0_data_master_granted_vga_vga AND cpu_0_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= vga_vga_in_a_write_cycle;
  wait_for_vga_vga_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_0_data_master_granted_vga_vga <= internal_cpu_0_data_master_granted_vga_vga;
  --vhdl renameroo for output signals
  cpu_0_data_master_qualified_request_vga_vga <= internal_cpu_0_data_master_qualified_request_vga_vga;
  --vhdl renameroo for output signals
  cpu_0_data_master_requests_vga_vga <= internal_cpu_0_data_master_requests_vga_vga;
--synthesis translate_off
    --vga/vga enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity nios_system_reset_clk_0_domain_synch_module is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC
              );
end entity nios_system_reset_clk_0_domain_synch_module;


architecture europa of nios_system_reset_clk_0_domain_synch_module is
                signal data_in_d1 :  STD_LOGIC;
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of data_in_d1 : signal is "{-from ""*""} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of data_out : signal is "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101";

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      data_in_d1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      data_in_d1 <= data_in;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      data_out <= std_logic'('0');
    elsif clk'event and clk = '1' then
      data_out <= data_in_d1;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity nios_system is 
        port (
              -- 1) global signals:
                 signal clk_0 : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- the_kanto_ctrl
                 signal audio_track_from_the_kanto_ctrl : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal keys_to_the_kanto_ctrl : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal nios_addr_from_the_kanto_ctrl : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal nios_done_to_the_kanto_ctrl : IN STD_LOGIC;
                 signal nios_play_from_the_kanto_ctrl : OUT STD_LOGIC;
                 signal nios_readblock_from_the_kanto_ctrl : OUT STD_LOGIC;
                 signal sd_blockaddr_to_the_kanto_ctrl : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_ps2
                 signal PS2_Clk_to_the_ps2 : IN STD_LOGIC;
                 signal PS2_Data_to_the_ps2 : IN STD_LOGIC;

              -- the_sdbuf
                 signal sdbuf_addr_from_the_sdbuf : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal sdbuf_data_to_the_sdbuf : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sdbuf_rden_from_the_sdbuf : OUT STD_LOGIC;

              -- the_sram
                 signal SRAM_ADDR_from_the_sram : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                 signal SRAM_CE_N_from_the_sram : OUT STD_LOGIC;
                 signal SRAM_DQ_to_and_from_the_sram : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal SRAM_LB_N_from_the_sram : OUT STD_LOGIC;
                 signal SRAM_OE_N_from_the_sram : OUT STD_LOGIC;
                 signal SRAM_UB_N_from_the_sram : OUT STD_LOGIC;
                 signal SRAM_WE_N_from_the_sram : OUT STD_LOGIC;

              -- the_vga
                 signal display_pixel_on_from_the_vga : OUT STD_LOGIC;
                 signal display_x_to_the_vga : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
                 signal display_y_to_the_vga : IN STD_LOGIC_VECTOR (6 DOWNTO 0)
              );
end entity nios_system;


architecture europa of nios_system is
component cpu_0_jtag_debug_module_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_0_data_master_debugaccess : IN STD_LOGIC;
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_0_instruction_master_read : IN STD_LOGIC;
                    signal cpu_0_jtag_debug_module_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_jtag_debug_module_resetrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_granted_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_requests_cpu_0_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_address : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal cpu_0_jtag_debug_module_begintransfer : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_0_jtag_debug_module_chipselect : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_debugaccess : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_jtag_debug_module_reset_n : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_resetrequest_from_sa : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_write : OUT STD_LOGIC;
                    signal cpu_0_jtag_debug_module_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_cpu_0_jtag_debug_module_end_xfer : OUT STD_LOGIC
                 );
end component cpu_0_jtag_debug_module_arbitrator;

component cpu_0_data_master_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_0_data_master_byteenable_sram_avalon_slave_0 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_data_master_granted_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_ps2_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_sdbuf_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_sram_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_data_master_granted_vga_vga : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_ps2_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_sdbuf_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_sram_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_vga_vga : IN STD_LOGIC;
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_kanto_ctrl_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_ps2_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdbuf_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sram_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_vga_vga : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_ps2_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_sdbuf_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_sram_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_data_master_requests_vga_vga : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_cpu_0_jtag_debug_module_end_xfer : IN STD_LOGIC;
                    signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer : IN STD_LOGIC;
                    signal d1_kanto_ctrl_avalon_slave_0_end_xfer : IN STD_LOGIC;
                    signal d1_ps2_avalon_slave_0_end_xfer : IN STD_LOGIC;
                    signal d1_sdbuf_avalon_slave_0_end_xfer : IN STD_LOGIC;
                    signal d1_sram_avalon_slave_0_end_xfer : IN STD_LOGIC;
                    signal d1_vga_vga_end_xfer : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_irq_from_sa : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal kanto_ctrl_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal ps2_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal sdbuf_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sram_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal vga_vga_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal cpu_0_data_master_address_to_slave : OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_0_data_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_data_master_dbs_write_16 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal cpu_0_data_master_irq : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_data_master_no_byte_enables_and_last_term : OUT STD_LOGIC;
                    signal cpu_0_data_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_data_master_waitrequest : OUT STD_LOGIC
                 );
end component cpu_0_data_master_arbitrator;

component cpu_0_instruction_master_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_instruction_master_address : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_0_instruction_master_granted_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_instruction_master_granted_sram_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_instruction_master_qualified_request_sram_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_instruction_master_read : IN STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_sram_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_instruction_master_requests_cpu_0_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_0_instruction_master_requests_sram_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_0_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_cpu_0_jtag_debug_module_end_xfer : IN STD_LOGIC;
                    signal d1_sram_avalon_slave_0_end_xfer : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sram_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal cpu_0_instruction_master_address_to_slave : OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_0_instruction_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_instruction_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_0_instruction_master_waitrequest : OUT STD_LOGIC
                 );
end component cpu_0_instruction_master_arbitrator;

component cpu_0 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal d_irq : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d_waitrequest : IN STD_LOGIC;
                    signal i_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal i_waitrequest : IN STD_LOGIC;
                    signal jtag_debug_module_address : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal jtag_debug_module_begintransfer : IN STD_LOGIC;
                    signal jtag_debug_module_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal jtag_debug_module_debugaccess : IN STD_LOGIC;
                    signal jtag_debug_module_select : IN STD_LOGIC;
                    signal jtag_debug_module_write : IN STD_LOGIC;
                    signal jtag_debug_module_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal d_address : OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal d_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal d_read : OUT STD_LOGIC;
                    signal d_write : OUT STD_LOGIC;
                    signal d_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal i_address : OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal i_read : OUT STD_LOGIC;
                    signal jtag_debug_module_debugaccess_to_roms : OUT STD_LOGIC;
                    signal jtag_debug_module_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_debug_module_resetrequest : OUT STD_LOGIC
                 );
end component cpu_0;

component jtag_uart_0_avalon_jtag_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_0_avalon_jtag_slave_dataavailable : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_irq : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_0_avalon_jtag_slave_readyfordata : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                    signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_address : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_chipselect : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_irq_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_read_n : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_reset_n : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_write_n : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component jtag_uart_0_avalon_jtag_slave_arbitrator;

component jtag_uart_0 is 
           port (
                 -- inputs:
                    signal av_address : IN STD_LOGIC;
                    signal av_chipselect : IN STD_LOGIC;
                    signal av_read_n : IN STD_LOGIC;
                    signal av_write_n : IN STD_LOGIC;
                    signal av_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal rst_n : IN STD_LOGIC;

                 -- outputs:
                    signal av_irq : OUT STD_LOGIC;
                    signal av_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal av_waitrequest : OUT STD_LOGIC;
                    signal dataavailable : OUT STD_LOGIC;
                    signal readyfordata : OUT STD_LOGIC
                 );
end component jtag_uart_0;

component kanto_ctrl_avalon_slave_0_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal kanto_ctrl_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_kanto_ctrl_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0 : OUT STD_LOGIC;
                    signal d1_kanto_ctrl_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                    signal kanto_ctrl_avalon_slave_0_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal kanto_ctrl_avalon_slave_0_chipselect : OUT STD_LOGIC;
                    signal kanto_ctrl_avalon_slave_0_read : OUT STD_LOGIC;
                    signal kanto_ctrl_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal kanto_ctrl_avalon_slave_0_reset_n : OUT STD_LOGIC;
                    signal kanto_ctrl_avalon_slave_0_write : OUT STD_LOGIC;
                    signal kanto_ctrl_avalon_slave_0_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component kanto_ctrl_avalon_slave_0_arbitrator;

component kanto_ctrl is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal keys : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal nios_done : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sd_blockaddr : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal audio_track : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal nios_addr : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal nios_play : OUT STD_LOGIC;
                    signal nios_readblock : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component kanto_ctrl;

component ps2_avalon_slave_0_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_0_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal ps2_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_0_data_master_granted_ps2_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_ps2_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_ps2_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_ps2_avalon_slave_0 : OUT STD_LOGIC;
                    signal d1_ps2_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                    signal ps2_avalon_slave_0_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal ps2_avalon_slave_0_chipselect : OUT STD_LOGIC;
                    signal ps2_avalon_slave_0_read : OUT STD_LOGIC;
                    signal ps2_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal ps2_avalon_slave_0_reset : OUT STD_LOGIC
                 );
end component ps2_avalon_slave_0_arbitrator;

component ps2 is 
           port (
                 -- inputs:
                    signal PS2_Clk : IN STD_LOGIC;
                    signal PS2_Data : IN STD_LOGIC;
                    signal avs_s1_address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal avs_s1_chipselect : IN STD_LOGIC;
                    signal avs_s1_clk : IN STD_LOGIC;
                    signal avs_s1_read : IN STD_LOGIC;
                    signal avs_s1_reset : IN STD_LOGIC;

                 -- outputs:
                    signal avs_s1_readdata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
                 );
end component ps2;

component sdbuf_avalon_slave_0_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_0_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sdbuf_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal cpu_0_data_master_granted_sdbuf_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_sdbuf_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sdbuf_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_sdbuf_avalon_slave_0 : OUT STD_LOGIC;
                    signal d1_sdbuf_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                    signal sdbuf_avalon_slave_0_address : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal sdbuf_avalon_slave_0_chipselect : OUT STD_LOGIC;
                    signal sdbuf_avalon_slave_0_read : OUT STD_LOGIC;
                    signal sdbuf_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sdbuf_avalon_slave_0_reset_n : OUT STD_LOGIC
                 );
end component sdbuf_avalon_slave_0_arbitrator;

component sdbuf is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sdbuf_data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sdbuf_addr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal sdbuf_rden : OUT STD_LOGIC
                 );
end component sdbuf;

component sram_avalon_slave_0_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_0_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_0_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_data_master_dbs_write_16 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal cpu_0_data_master_no_byte_enables_and_last_term : IN STD_LOGIC;
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_0_instruction_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_instruction_master_read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sram_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal cpu_0_data_master_byteenable_sram_avalon_slave_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_0_data_master_granted_sram_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_sram_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_sram_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_sram_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_granted_sram_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_qualified_request_sram_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_read_data_valid_sram_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_0_instruction_master_requests_sram_avalon_slave_0 : OUT STD_LOGIC;
                    signal d1_sram_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                    signal sram_avalon_slave_0_address : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal sram_avalon_slave_0_byteenable : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal sram_avalon_slave_0_chipselect : OUT STD_LOGIC;
                    signal sram_avalon_slave_0_read : OUT STD_LOGIC;
                    signal sram_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sram_avalon_slave_0_write : OUT STD_LOGIC;
                    signal sram_avalon_slave_0_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component sram_avalon_slave_0_arbitrator;

component sram is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal byteenable : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal SRAM_ADDR : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal SRAM_CE_N : OUT STD_LOGIC;
                    signal SRAM_DQ : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal SRAM_LB_N : OUT STD_LOGIC;
                    signal SRAM_OE_N : OUT STD_LOGIC;
                    signal SRAM_UB_N : OUT STD_LOGIC;
                    signal SRAM_WE_N : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component sram;

component vga_vga_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_0_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_0_data_master_read : IN STD_LOGIC;
                    signal cpu_0_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_0_data_master_write : IN STD_LOGIC;
                    signal cpu_0_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal vga_vga_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal cpu_0_data_master_granted_vga_vga : OUT STD_LOGIC;
                    signal cpu_0_data_master_qualified_request_vga_vga : OUT STD_LOGIC;
                    signal cpu_0_data_master_read_data_valid_vga_vga : OUT STD_LOGIC;
                    signal cpu_0_data_master_requests_vga_vga : OUT STD_LOGIC;
                    signal d1_vga_vga_end_xfer : OUT STD_LOGIC;
                    signal vga_vga_address : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
                    signal vga_vga_chipselect : OUT STD_LOGIC;
                    signal vga_vga_read : OUT STD_LOGIC;
                    signal vga_vga_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal vga_vga_reset : OUT STD_LOGIC;
                    signal vga_vga_write : OUT STD_LOGIC;
                    signal vga_vga_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component vga_vga_arbitrator;

component vga is 
           port (
                 -- inputs:
                    signal display_x : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
                    signal display_y : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
                    signal vga_address : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
                    signal vga_chipselect : IN STD_LOGIC;
                    signal vga_clk : IN STD_LOGIC;
                    signal vga_read : IN STD_LOGIC;
                    signal vga_reset : IN STD_LOGIC;
                    signal vga_write : IN STD_LOGIC;
                    signal vga_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal display_pixel_on : OUT STD_LOGIC;
                    signal vga_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component vga;

component nios_system_reset_clk_0_domain_synch_module is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC
                 );
end component nios_system_reset_clk_0_domain_synch_module;

                signal clk_0_reset_n :  STD_LOGIC;
                signal cpu_0_data_master_address :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal cpu_0_data_master_address_to_slave :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal cpu_0_data_master_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_0_data_master_byteenable_sram_avalon_slave_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_data_master_dbs_write_16 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal cpu_0_data_master_debugaccess :  STD_LOGIC;
                signal cpu_0_data_master_granted_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_data_master_granted_ps2_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_data_master_granted_sdbuf_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_data_master_granted_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_data_master_granted_vga_vga :  STD_LOGIC;
                signal cpu_0_data_master_irq :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_data_master_no_byte_enables_and_last_term :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_ps2_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_sdbuf_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_data_master_qualified_request_vga_vga :  STD_LOGIC;
                signal cpu_0_data_master_read :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_kanto_ctrl_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_ps2_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_sdbuf_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_data_master_read_data_valid_vga_vga :  STD_LOGIC;
                signal cpu_0_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_data_master_requests_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_data_master_requests_ps2_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_data_master_requests_sdbuf_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_data_master_requests_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_data_master_requests_vga_vga :  STD_LOGIC;
                signal cpu_0_data_master_waitrequest :  STD_LOGIC;
                signal cpu_0_data_master_write :  STD_LOGIC;
                signal cpu_0_data_master_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_instruction_master_address :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal cpu_0_instruction_master_address_to_slave :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal cpu_0_instruction_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_0_instruction_master_granted_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_instruction_master_granted_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_instruction_master_qualified_request_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_instruction_master_read :  STD_LOGIC;
                signal cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_instruction_master_read_data_valid_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_instruction_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_instruction_master_requests_cpu_0_jtag_debug_module :  STD_LOGIC;
                signal cpu_0_instruction_master_requests_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_0_instruction_master_waitrequest :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_address :  STD_LOGIC_VECTOR (8 DOWNTO 0);
                signal cpu_0_jtag_debug_module_begintransfer :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_0_jtag_debug_module_chipselect :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_debugaccess :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_jtag_debug_module_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_0_jtag_debug_module_reset_n :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_resetrequest :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_resetrequest_from_sa :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_write :  STD_LOGIC;
                signal cpu_0_jtag_debug_module_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal d1_cpu_0_jtag_debug_module_end_xfer :  STD_LOGIC;
                signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer :  STD_LOGIC;
                signal d1_kanto_ctrl_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal d1_ps2_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal d1_sdbuf_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal d1_sram_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal d1_vga_vga_end_xfer :  STD_LOGIC;
                signal internal_SRAM_ADDR_from_the_sram :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal internal_SRAM_CE_N_from_the_sram :  STD_LOGIC;
                signal internal_SRAM_LB_N_from_the_sram :  STD_LOGIC;
                signal internal_SRAM_OE_N_from_the_sram :  STD_LOGIC;
                signal internal_SRAM_UB_N_from_the_sram :  STD_LOGIC;
                signal internal_SRAM_WE_N_from_the_sram :  STD_LOGIC;
                signal internal_audio_track_from_the_kanto_ctrl :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal internal_display_pixel_on_from_the_vga :  STD_LOGIC;
                signal internal_nios_addr_from_the_kanto_ctrl :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_nios_play_from_the_kanto_ctrl :  STD_LOGIC;
                signal internal_nios_readblock_from_the_kanto_ctrl :  STD_LOGIC;
                signal internal_sdbuf_addr_from_the_sdbuf :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal internal_sdbuf_rden_from_the_sdbuf :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_address :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_chipselect :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_dataavailable :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_irq :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_irq_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_read_n :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_readyfordata :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_reset_n :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_waitrequest :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_write_n :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal kanto_ctrl_avalon_slave_0_address :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal kanto_ctrl_avalon_slave_0_chipselect :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_read :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal kanto_ctrl_avalon_slave_0_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal kanto_ctrl_avalon_slave_0_reset_n :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_write :  STD_LOGIC;
                signal kanto_ctrl_avalon_slave_0_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal module_input :  STD_LOGIC;
                signal ps2_avalon_slave_0_address :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal ps2_avalon_slave_0_chipselect :  STD_LOGIC;
                signal ps2_avalon_slave_0_read :  STD_LOGIC;
                signal ps2_avalon_slave_0_readdata :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal ps2_avalon_slave_0_readdata_from_sa :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal ps2_avalon_slave_0_reset :  STD_LOGIC;
                signal reset_n_sources :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_address :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal sdbuf_avalon_slave_0_chipselect :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_read :  STD_LOGIC;
                signal sdbuf_avalon_slave_0_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sdbuf_avalon_slave_0_readdata_from_sa :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sdbuf_avalon_slave_0_reset_n :  STD_LOGIC;
                signal sram_avalon_slave_0_address :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal sram_avalon_slave_0_byteenable :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sram_avalon_slave_0_chipselect :  STD_LOGIC;
                signal sram_avalon_slave_0_read :  STD_LOGIC;
                signal sram_avalon_slave_0_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sram_avalon_slave_0_readdata_from_sa :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sram_avalon_slave_0_write :  STD_LOGIC;
                signal sram_avalon_slave_0_writedata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal vga_vga_address :  STD_LOGIC_VECTOR (10 DOWNTO 0);
                signal vga_vga_chipselect :  STD_LOGIC;
                signal vga_vga_read :  STD_LOGIC;
                signal vga_vga_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal vga_vga_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal vga_vga_reset :  STD_LOGIC;
                signal vga_vga_write :  STD_LOGIC;
                signal vga_vga_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

  --the_cpu_0_jtag_debug_module, which is an e_instance
  the_cpu_0_jtag_debug_module : cpu_0_jtag_debug_module_arbitrator
    port map(
      cpu_0_data_master_granted_cpu_0_jtag_debug_module => cpu_0_data_master_granted_cpu_0_jtag_debug_module,
      cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module => cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module,
      cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module => cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module,
      cpu_0_data_master_requests_cpu_0_jtag_debug_module => cpu_0_data_master_requests_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_granted_cpu_0_jtag_debug_module => cpu_0_instruction_master_granted_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module => cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module => cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_requests_cpu_0_jtag_debug_module => cpu_0_instruction_master_requests_cpu_0_jtag_debug_module,
      cpu_0_jtag_debug_module_address => cpu_0_jtag_debug_module_address,
      cpu_0_jtag_debug_module_begintransfer => cpu_0_jtag_debug_module_begintransfer,
      cpu_0_jtag_debug_module_byteenable => cpu_0_jtag_debug_module_byteenable,
      cpu_0_jtag_debug_module_chipselect => cpu_0_jtag_debug_module_chipselect,
      cpu_0_jtag_debug_module_debugaccess => cpu_0_jtag_debug_module_debugaccess,
      cpu_0_jtag_debug_module_readdata_from_sa => cpu_0_jtag_debug_module_readdata_from_sa,
      cpu_0_jtag_debug_module_reset_n => cpu_0_jtag_debug_module_reset_n,
      cpu_0_jtag_debug_module_resetrequest_from_sa => cpu_0_jtag_debug_module_resetrequest_from_sa,
      cpu_0_jtag_debug_module_write => cpu_0_jtag_debug_module_write,
      cpu_0_jtag_debug_module_writedata => cpu_0_jtag_debug_module_writedata,
      d1_cpu_0_jtag_debug_module_end_xfer => d1_cpu_0_jtag_debug_module_end_xfer,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_byteenable => cpu_0_data_master_byteenable,
      cpu_0_data_master_debugaccess => cpu_0_data_master_debugaccess,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      cpu_0_instruction_master_address_to_slave => cpu_0_instruction_master_address_to_slave,
      cpu_0_instruction_master_read => cpu_0_instruction_master_read,
      cpu_0_jtag_debug_module_readdata => cpu_0_jtag_debug_module_readdata,
      cpu_0_jtag_debug_module_resetrequest => cpu_0_jtag_debug_module_resetrequest,
      reset_n => clk_0_reset_n
    );


  --the_cpu_0_data_master, which is an e_instance
  the_cpu_0_data_master : cpu_0_data_master_arbitrator
    port map(
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_dbs_address => cpu_0_data_master_dbs_address,
      cpu_0_data_master_dbs_write_16 => cpu_0_data_master_dbs_write_16,
      cpu_0_data_master_irq => cpu_0_data_master_irq,
      cpu_0_data_master_no_byte_enables_and_last_term => cpu_0_data_master_no_byte_enables_and_last_term,
      cpu_0_data_master_readdata => cpu_0_data_master_readdata,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      clk => clk_0,
      cpu_0_data_master_address => cpu_0_data_master_address,
      cpu_0_data_master_byteenable_sram_avalon_slave_0 => cpu_0_data_master_byteenable_sram_avalon_slave_0,
      cpu_0_data_master_granted_cpu_0_jtag_debug_module => cpu_0_data_master_granted_cpu_0_jtag_debug_module,
      cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0 => cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0,
      cpu_0_data_master_granted_ps2_avalon_slave_0 => cpu_0_data_master_granted_ps2_avalon_slave_0,
      cpu_0_data_master_granted_sdbuf_avalon_slave_0 => cpu_0_data_master_granted_sdbuf_avalon_slave_0,
      cpu_0_data_master_granted_sram_avalon_slave_0 => cpu_0_data_master_granted_sram_avalon_slave_0,
      cpu_0_data_master_granted_vga_vga => cpu_0_data_master_granted_vga_vga,
      cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module => cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module,
      cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0 => cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0,
      cpu_0_data_master_qualified_request_ps2_avalon_slave_0 => cpu_0_data_master_qualified_request_ps2_avalon_slave_0,
      cpu_0_data_master_qualified_request_sdbuf_avalon_slave_0 => cpu_0_data_master_qualified_request_sdbuf_avalon_slave_0,
      cpu_0_data_master_qualified_request_sram_avalon_slave_0 => cpu_0_data_master_qualified_request_sram_avalon_slave_0,
      cpu_0_data_master_qualified_request_vga_vga => cpu_0_data_master_qualified_request_vga_vga,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module => cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module,
      cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_read_data_valid_kanto_ctrl_avalon_slave_0 => cpu_0_data_master_read_data_valid_kanto_ctrl_avalon_slave_0,
      cpu_0_data_master_read_data_valid_ps2_avalon_slave_0 => cpu_0_data_master_read_data_valid_ps2_avalon_slave_0,
      cpu_0_data_master_read_data_valid_sdbuf_avalon_slave_0 => cpu_0_data_master_read_data_valid_sdbuf_avalon_slave_0,
      cpu_0_data_master_read_data_valid_sram_avalon_slave_0 => cpu_0_data_master_read_data_valid_sram_avalon_slave_0,
      cpu_0_data_master_read_data_valid_vga_vga => cpu_0_data_master_read_data_valid_vga_vga,
      cpu_0_data_master_requests_cpu_0_jtag_debug_module => cpu_0_data_master_requests_cpu_0_jtag_debug_module,
      cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0 => cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0,
      cpu_0_data_master_requests_ps2_avalon_slave_0 => cpu_0_data_master_requests_ps2_avalon_slave_0,
      cpu_0_data_master_requests_sdbuf_avalon_slave_0 => cpu_0_data_master_requests_sdbuf_avalon_slave_0,
      cpu_0_data_master_requests_sram_avalon_slave_0 => cpu_0_data_master_requests_sram_avalon_slave_0,
      cpu_0_data_master_requests_vga_vga => cpu_0_data_master_requests_vga_vga,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      cpu_0_jtag_debug_module_readdata_from_sa => cpu_0_jtag_debug_module_readdata_from_sa,
      d1_cpu_0_jtag_debug_module_end_xfer => d1_cpu_0_jtag_debug_module_end_xfer,
      d1_jtag_uart_0_avalon_jtag_slave_end_xfer => d1_jtag_uart_0_avalon_jtag_slave_end_xfer,
      d1_kanto_ctrl_avalon_slave_0_end_xfer => d1_kanto_ctrl_avalon_slave_0_end_xfer,
      d1_ps2_avalon_slave_0_end_xfer => d1_ps2_avalon_slave_0_end_xfer,
      d1_sdbuf_avalon_slave_0_end_xfer => d1_sdbuf_avalon_slave_0_end_xfer,
      d1_sram_avalon_slave_0_end_xfer => d1_sram_avalon_slave_0_end_xfer,
      d1_vga_vga_end_xfer => d1_vga_vga_end_xfer,
      jtag_uart_0_avalon_jtag_slave_irq_from_sa => jtag_uart_0_avalon_jtag_slave_irq_from_sa,
      jtag_uart_0_avalon_jtag_slave_readdata_from_sa => jtag_uart_0_avalon_jtag_slave_readdata_from_sa,
      jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa => jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa,
      kanto_ctrl_avalon_slave_0_readdata_from_sa => kanto_ctrl_avalon_slave_0_readdata_from_sa,
      ps2_avalon_slave_0_readdata_from_sa => ps2_avalon_slave_0_readdata_from_sa,
      reset_n => clk_0_reset_n,
      sdbuf_avalon_slave_0_readdata_from_sa => sdbuf_avalon_slave_0_readdata_from_sa,
      sram_avalon_slave_0_readdata_from_sa => sram_avalon_slave_0_readdata_from_sa,
      vga_vga_readdata_from_sa => vga_vga_readdata_from_sa
    );


  --the_cpu_0_instruction_master, which is an e_instance
  the_cpu_0_instruction_master : cpu_0_instruction_master_arbitrator
    port map(
      cpu_0_instruction_master_address_to_slave => cpu_0_instruction_master_address_to_slave,
      cpu_0_instruction_master_dbs_address => cpu_0_instruction_master_dbs_address,
      cpu_0_instruction_master_readdata => cpu_0_instruction_master_readdata,
      cpu_0_instruction_master_waitrequest => cpu_0_instruction_master_waitrequest,
      clk => clk_0,
      cpu_0_instruction_master_address => cpu_0_instruction_master_address,
      cpu_0_instruction_master_granted_cpu_0_jtag_debug_module => cpu_0_instruction_master_granted_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_granted_sram_avalon_slave_0 => cpu_0_instruction_master_granted_sram_avalon_slave_0,
      cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module => cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_qualified_request_sram_avalon_slave_0 => cpu_0_instruction_master_qualified_request_sram_avalon_slave_0,
      cpu_0_instruction_master_read => cpu_0_instruction_master_read,
      cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module => cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_read_data_valid_sram_avalon_slave_0 => cpu_0_instruction_master_read_data_valid_sram_avalon_slave_0,
      cpu_0_instruction_master_requests_cpu_0_jtag_debug_module => cpu_0_instruction_master_requests_cpu_0_jtag_debug_module,
      cpu_0_instruction_master_requests_sram_avalon_slave_0 => cpu_0_instruction_master_requests_sram_avalon_slave_0,
      cpu_0_jtag_debug_module_readdata_from_sa => cpu_0_jtag_debug_module_readdata_from_sa,
      d1_cpu_0_jtag_debug_module_end_xfer => d1_cpu_0_jtag_debug_module_end_xfer,
      d1_sram_avalon_slave_0_end_xfer => d1_sram_avalon_slave_0_end_xfer,
      reset_n => clk_0_reset_n,
      sram_avalon_slave_0_readdata_from_sa => sram_avalon_slave_0_readdata_from_sa
    );


  --the_cpu_0, which is an e_ptf_instance
  the_cpu_0 : cpu_0
    port map(
      d_address => cpu_0_data_master_address,
      d_byteenable => cpu_0_data_master_byteenable,
      d_read => cpu_0_data_master_read,
      d_write => cpu_0_data_master_write,
      d_writedata => cpu_0_data_master_writedata,
      i_address => cpu_0_instruction_master_address,
      i_read => cpu_0_instruction_master_read,
      jtag_debug_module_debugaccess_to_roms => cpu_0_data_master_debugaccess,
      jtag_debug_module_readdata => cpu_0_jtag_debug_module_readdata,
      jtag_debug_module_resetrequest => cpu_0_jtag_debug_module_resetrequest,
      clk => clk_0,
      d_irq => cpu_0_data_master_irq,
      d_readdata => cpu_0_data_master_readdata,
      d_waitrequest => cpu_0_data_master_waitrequest,
      i_readdata => cpu_0_instruction_master_readdata,
      i_waitrequest => cpu_0_instruction_master_waitrequest,
      jtag_debug_module_address => cpu_0_jtag_debug_module_address,
      jtag_debug_module_begintransfer => cpu_0_jtag_debug_module_begintransfer,
      jtag_debug_module_byteenable => cpu_0_jtag_debug_module_byteenable,
      jtag_debug_module_debugaccess => cpu_0_jtag_debug_module_debugaccess,
      jtag_debug_module_select => cpu_0_jtag_debug_module_chipselect,
      jtag_debug_module_write => cpu_0_jtag_debug_module_write,
      jtag_debug_module_writedata => cpu_0_jtag_debug_module_writedata,
      reset_n => cpu_0_jtag_debug_module_reset_n
    );


  --the_jtag_uart_0_avalon_jtag_slave, which is an e_instance
  the_jtag_uart_0_avalon_jtag_slave : jtag_uart_0_avalon_jtag_slave_arbitrator
    port map(
      cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave,
      cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave => cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave,
      d1_jtag_uart_0_avalon_jtag_slave_end_xfer => d1_jtag_uart_0_avalon_jtag_slave_end_xfer,
      jtag_uart_0_avalon_jtag_slave_address => jtag_uart_0_avalon_jtag_slave_address,
      jtag_uart_0_avalon_jtag_slave_chipselect => jtag_uart_0_avalon_jtag_slave_chipselect,
      jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa => jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa,
      jtag_uart_0_avalon_jtag_slave_irq_from_sa => jtag_uart_0_avalon_jtag_slave_irq_from_sa,
      jtag_uart_0_avalon_jtag_slave_read_n => jtag_uart_0_avalon_jtag_slave_read_n,
      jtag_uart_0_avalon_jtag_slave_readdata_from_sa => jtag_uart_0_avalon_jtag_slave_readdata_from_sa,
      jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa => jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa,
      jtag_uart_0_avalon_jtag_slave_reset_n => jtag_uart_0_avalon_jtag_slave_reset_n,
      jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa => jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa,
      jtag_uart_0_avalon_jtag_slave_write_n => jtag_uart_0_avalon_jtag_slave_write_n,
      jtag_uart_0_avalon_jtag_slave_writedata => jtag_uart_0_avalon_jtag_slave_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      jtag_uart_0_avalon_jtag_slave_dataavailable => jtag_uart_0_avalon_jtag_slave_dataavailable,
      jtag_uart_0_avalon_jtag_slave_irq => jtag_uart_0_avalon_jtag_slave_irq,
      jtag_uart_0_avalon_jtag_slave_readdata => jtag_uart_0_avalon_jtag_slave_readdata,
      jtag_uart_0_avalon_jtag_slave_readyfordata => jtag_uart_0_avalon_jtag_slave_readyfordata,
      jtag_uart_0_avalon_jtag_slave_waitrequest => jtag_uart_0_avalon_jtag_slave_waitrequest,
      reset_n => clk_0_reset_n
    );


  --the_jtag_uart_0, which is an e_ptf_instance
  the_jtag_uart_0 : jtag_uart_0
    port map(
      av_irq => jtag_uart_0_avalon_jtag_slave_irq,
      av_readdata => jtag_uart_0_avalon_jtag_slave_readdata,
      av_waitrequest => jtag_uart_0_avalon_jtag_slave_waitrequest,
      dataavailable => jtag_uart_0_avalon_jtag_slave_dataavailable,
      readyfordata => jtag_uart_0_avalon_jtag_slave_readyfordata,
      av_address => jtag_uart_0_avalon_jtag_slave_address,
      av_chipselect => jtag_uart_0_avalon_jtag_slave_chipselect,
      av_read_n => jtag_uart_0_avalon_jtag_slave_read_n,
      av_write_n => jtag_uart_0_avalon_jtag_slave_write_n,
      av_writedata => jtag_uart_0_avalon_jtag_slave_writedata,
      clk => clk_0,
      rst_n => jtag_uart_0_avalon_jtag_slave_reset_n
    );


  --the_kanto_ctrl_avalon_slave_0, which is an e_instance
  the_kanto_ctrl_avalon_slave_0 : kanto_ctrl_avalon_slave_0_arbitrator
    port map(
      cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0 => cpu_0_data_master_granted_kanto_ctrl_avalon_slave_0,
      cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0 => cpu_0_data_master_qualified_request_kanto_ctrl_avalon_slave_0,
      cpu_0_data_master_read_data_valid_kanto_ctrl_avalon_slave_0 => cpu_0_data_master_read_data_valid_kanto_ctrl_avalon_slave_0,
      cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0 => cpu_0_data_master_requests_kanto_ctrl_avalon_slave_0,
      d1_kanto_ctrl_avalon_slave_0_end_xfer => d1_kanto_ctrl_avalon_slave_0_end_xfer,
      kanto_ctrl_avalon_slave_0_address => kanto_ctrl_avalon_slave_0_address,
      kanto_ctrl_avalon_slave_0_chipselect => kanto_ctrl_avalon_slave_0_chipselect,
      kanto_ctrl_avalon_slave_0_read => kanto_ctrl_avalon_slave_0_read,
      kanto_ctrl_avalon_slave_0_readdata_from_sa => kanto_ctrl_avalon_slave_0_readdata_from_sa,
      kanto_ctrl_avalon_slave_0_reset_n => kanto_ctrl_avalon_slave_0_reset_n,
      kanto_ctrl_avalon_slave_0_write => kanto_ctrl_avalon_slave_0_write,
      kanto_ctrl_avalon_slave_0_writedata => kanto_ctrl_avalon_slave_0_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      kanto_ctrl_avalon_slave_0_readdata => kanto_ctrl_avalon_slave_0_readdata,
      reset_n => clk_0_reset_n
    );


  --the_kanto_ctrl, which is an e_ptf_instance
  the_kanto_ctrl : kanto_ctrl
    port map(
      audio_track => internal_audio_track_from_the_kanto_ctrl,
      nios_addr => internal_nios_addr_from_the_kanto_ctrl,
      nios_play => internal_nios_play_from_the_kanto_ctrl,
      nios_readblock => internal_nios_readblock_from_the_kanto_ctrl,
      readdata => kanto_ctrl_avalon_slave_0_readdata,
      address => kanto_ctrl_avalon_slave_0_address,
      chipselect => kanto_ctrl_avalon_slave_0_chipselect,
      clk => clk_0,
      keys => keys_to_the_kanto_ctrl,
      nios_done => nios_done_to_the_kanto_ctrl,
      read => kanto_ctrl_avalon_slave_0_read,
      reset_n => kanto_ctrl_avalon_slave_0_reset_n,
      sd_blockaddr => sd_blockaddr_to_the_kanto_ctrl,
      write => kanto_ctrl_avalon_slave_0_write,
      writedata => kanto_ctrl_avalon_slave_0_writedata
    );


  --the_ps2_avalon_slave_0, which is an e_instance
  the_ps2_avalon_slave_0 : ps2_avalon_slave_0_arbitrator
    port map(
      cpu_0_data_master_granted_ps2_avalon_slave_0 => cpu_0_data_master_granted_ps2_avalon_slave_0,
      cpu_0_data_master_qualified_request_ps2_avalon_slave_0 => cpu_0_data_master_qualified_request_ps2_avalon_slave_0,
      cpu_0_data_master_read_data_valid_ps2_avalon_slave_0 => cpu_0_data_master_read_data_valid_ps2_avalon_slave_0,
      cpu_0_data_master_requests_ps2_avalon_slave_0 => cpu_0_data_master_requests_ps2_avalon_slave_0,
      d1_ps2_avalon_slave_0_end_xfer => d1_ps2_avalon_slave_0_end_xfer,
      ps2_avalon_slave_0_address => ps2_avalon_slave_0_address,
      ps2_avalon_slave_0_chipselect => ps2_avalon_slave_0_chipselect,
      ps2_avalon_slave_0_read => ps2_avalon_slave_0_read,
      ps2_avalon_slave_0_readdata_from_sa => ps2_avalon_slave_0_readdata_from_sa,
      ps2_avalon_slave_0_reset => ps2_avalon_slave_0_reset,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_dbs_address => cpu_0_data_master_dbs_address,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_write => cpu_0_data_master_write,
      ps2_avalon_slave_0_readdata => ps2_avalon_slave_0_readdata,
      reset_n => clk_0_reset_n
    );


  --the_ps2, which is an e_ptf_instance
  the_ps2 : ps2
    port map(
      avs_s1_readdata => ps2_avalon_slave_0_readdata,
      PS2_Clk => PS2_Clk_to_the_ps2,
      PS2_Data => PS2_Data_to_the_ps2,
      avs_s1_address => ps2_avalon_slave_0_address,
      avs_s1_chipselect => ps2_avalon_slave_0_chipselect,
      avs_s1_clk => clk_0,
      avs_s1_read => ps2_avalon_slave_0_read,
      avs_s1_reset => ps2_avalon_slave_0_reset
    );


  --the_sdbuf_avalon_slave_0, which is an e_instance
  the_sdbuf_avalon_slave_0 : sdbuf_avalon_slave_0_arbitrator
    port map(
      cpu_0_data_master_granted_sdbuf_avalon_slave_0 => cpu_0_data_master_granted_sdbuf_avalon_slave_0,
      cpu_0_data_master_qualified_request_sdbuf_avalon_slave_0 => cpu_0_data_master_qualified_request_sdbuf_avalon_slave_0,
      cpu_0_data_master_read_data_valid_sdbuf_avalon_slave_0 => cpu_0_data_master_read_data_valid_sdbuf_avalon_slave_0,
      cpu_0_data_master_requests_sdbuf_avalon_slave_0 => cpu_0_data_master_requests_sdbuf_avalon_slave_0,
      d1_sdbuf_avalon_slave_0_end_xfer => d1_sdbuf_avalon_slave_0_end_xfer,
      sdbuf_avalon_slave_0_address => sdbuf_avalon_slave_0_address,
      sdbuf_avalon_slave_0_chipselect => sdbuf_avalon_slave_0_chipselect,
      sdbuf_avalon_slave_0_read => sdbuf_avalon_slave_0_read,
      sdbuf_avalon_slave_0_readdata_from_sa => sdbuf_avalon_slave_0_readdata_from_sa,
      sdbuf_avalon_slave_0_reset_n => sdbuf_avalon_slave_0_reset_n,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_dbs_address => cpu_0_data_master_dbs_address,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_write => cpu_0_data_master_write,
      reset_n => clk_0_reset_n,
      sdbuf_avalon_slave_0_readdata => sdbuf_avalon_slave_0_readdata
    );


  --the_sdbuf, which is an e_ptf_instance
  the_sdbuf : sdbuf
    port map(
      readdata => sdbuf_avalon_slave_0_readdata,
      sdbuf_addr => internal_sdbuf_addr_from_the_sdbuf,
      sdbuf_rden => internal_sdbuf_rden_from_the_sdbuf,
      address => sdbuf_avalon_slave_0_address,
      chipselect => sdbuf_avalon_slave_0_chipselect,
      clk => clk_0,
      read => sdbuf_avalon_slave_0_read,
      reset_n => sdbuf_avalon_slave_0_reset_n,
      sdbuf_data => sdbuf_data_to_the_sdbuf
    );


  --the_sram_avalon_slave_0, which is an e_instance
  the_sram_avalon_slave_0 : sram_avalon_slave_0_arbitrator
    port map(
      cpu_0_data_master_byteenable_sram_avalon_slave_0 => cpu_0_data_master_byteenable_sram_avalon_slave_0,
      cpu_0_data_master_granted_sram_avalon_slave_0 => cpu_0_data_master_granted_sram_avalon_slave_0,
      cpu_0_data_master_qualified_request_sram_avalon_slave_0 => cpu_0_data_master_qualified_request_sram_avalon_slave_0,
      cpu_0_data_master_read_data_valid_sram_avalon_slave_0 => cpu_0_data_master_read_data_valid_sram_avalon_slave_0,
      cpu_0_data_master_requests_sram_avalon_slave_0 => cpu_0_data_master_requests_sram_avalon_slave_0,
      cpu_0_instruction_master_granted_sram_avalon_slave_0 => cpu_0_instruction_master_granted_sram_avalon_slave_0,
      cpu_0_instruction_master_qualified_request_sram_avalon_slave_0 => cpu_0_instruction_master_qualified_request_sram_avalon_slave_0,
      cpu_0_instruction_master_read_data_valid_sram_avalon_slave_0 => cpu_0_instruction_master_read_data_valid_sram_avalon_slave_0,
      cpu_0_instruction_master_requests_sram_avalon_slave_0 => cpu_0_instruction_master_requests_sram_avalon_slave_0,
      d1_sram_avalon_slave_0_end_xfer => d1_sram_avalon_slave_0_end_xfer,
      sram_avalon_slave_0_address => sram_avalon_slave_0_address,
      sram_avalon_slave_0_byteenable => sram_avalon_slave_0_byteenable,
      sram_avalon_slave_0_chipselect => sram_avalon_slave_0_chipselect,
      sram_avalon_slave_0_read => sram_avalon_slave_0_read,
      sram_avalon_slave_0_readdata_from_sa => sram_avalon_slave_0_readdata_from_sa,
      sram_avalon_slave_0_write => sram_avalon_slave_0_write,
      sram_avalon_slave_0_writedata => sram_avalon_slave_0_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_byteenable => cpu_0_data_master_byteenable,
      cpu_0_data_master_dbs_address => cpu_0_data_master_dbs_address,
      cpu_0_data_master_dbs_write_16 => cpu_0_data_master_dbs_write_16,
      cpu_0_data_master_no_byte_enables_and_last_term => cpu_0_data_master_no_byte_enables_and_last_term,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_instruction_master_address_to_slave => cpu_0_instruction_master_address_to_slave,
      cpu_0_instruction_master_dbs_address => cpu_0_instruction_master_dbs_address,
      cpu_0_instruction_master_read => cpu_0_instruction_master_read,
      reset_n => clk_0_reset_n,
      sram_avalon_slave_0_readdata => sram_avalon_slave_0_readdata
    );


  --the_sram, which is an e_ptf_instance
  the_sram : sram
    port map(
      SRAM_ADDR => internal_SRAM_ADDR_from_the_sram,
      SRAM_CE_N => internal_SRAM_CE_N_from_the_sram,
      SRAM_DQ => SRAM_DQ_to_and_from_the_sram,
      SRAM_LB_N => internal_SRAM_LB_N_from_the_sram,
      SRAM_OE_N => internal_SRAM_OE_N_from_the_sram,
      SRAM_UB_N => internal_SRAM_UB_N_from_the_sram,
      SRAM_WE_N => internal_SRAM_WE_N_from_the_sram,
      readdata => sram_avalon_slave_0_readdata,
      address => sram_avalon_slave_0_address,
      byteenable => sram_avalon_slave_0_byteenable,
      chipselect => sram_avalon_slave_0_chipselect,
      read => sram_avalon_slave_0_read,
      write => sram_avalon_slave_0_write,
      writedata => sram_avalon_slave_0_writedata
    );


  --the_vga_vga, which is an e_instance
  the_vga_vga : vga_vga_arbitrator
    port map(
      cpu_0_data_master_granted_vga_vga => cpu_0_data_master_granted_vga_vga,
      cpu_0_data_master_qualified_request_vga_vga => cpu_0_data_master_qualified_request_vga_vga,
      cpu_0_data_master_read_data_valid_vga_vga => cpu_0_data_master_read_data_valid_vga_vga,
      cpu_0_data_master_requests_vga_vga => cpu_0_data_master_requests_vga_vga,
      d1_vga_vga_end_xfer => d1_vga_vga_end_xfer,
      vga_vga_address => vga_vga_address,
      vga_vga_chipselect => vga_vga_chipselect,
      vga_vga_read => vga_vga_read,
      vga_vga_readdata_from_sa => vga_vga_readdata_from_sa,
      vga_vga_reset => vga_vga_reset,
      vga_vga_write => vga_vga_write,
      vga_vga_writedata => vga_vga_writedata,
      clk => clk_0,
      cpu_0_data_master_address_to_slave => cpu_0_data_master_address_to_slave,
      cpu_0_data_master_read => cpu_0_data_master_read,
      cpu_0_data_master_waitrequest => cpu_0_data_master_waitrequest,
      cpu_0_data_master_write => cpu_0_data_master_write,
      cpu_0_data_master_writedata => cpu_0_data_master_writedata,
      reset_n => clk_0_reset_n,
      vga_vga_readdata => vga_vga_readdata
    );


  --the_vga, which is an e_ptf_instance
  the_vga : vga
    port map(
      display_pixel_on => internal_display_pixel_on_from_the_vga,
      vga_readdata => vga_vga_readdata,
      display_x => display_x_to_the_vga,
      display_y => display_y_to_the_vga,
      vga_address => vga_vga_address,
      vga_chipselect => vga_vga_chipselect,
      vga_clk => clk_0,
      vga_read => vga_vga_read,
      vga_reset => vga_vga_reset,
      vga_write => vga_vga_write,
      vga_writedata => vga_vga_writedata
    );


  --reset is asserted asynchronously and deasserted synchronously
  nios_system_reset_clk_0_domain_synch : nios_system_reset_clk_0_domain_synch_module
    port map(
      data_out => clk_0_reset_n,
      clk => clk_0,
      data_in => module_input,
      reset_n => reset_n_sources
    );

  module_input <= std_logic'('1');

  --reset sources mux, which is an e_mux
  reset_n_sources <= Vector_To_Std_Logic(NOT (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT reset_n))) OR std_logic_vector'("00000000000000000000000000000000")) OR (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_jtag_debug_module_resetrequest_from_sa)))) OR (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_0_jtag_debug_module_resetrequest_from_sa))))));
  --vhdl renameroo for output signals
  SRAM_ADDR_from_the_sram <= internal_SRAM_ADDR_from_the_sram;
  --vhdl renameroo for output signals
  SRAM_CE_N_from_the_sram <= internal_SRAM_CE_N_from_the_sram;
  --vhdl renameroo for output signals
  SRAM_LB_N_from_the_sram <= internal_SRAM_LB_N_from_the_sram;
  --vhdl renameroo for output signals
  SRAM_OE_N_from_the_sram <= internal_SRAM_OE_N_from_the_sram;
  --vhdl renameroo for output signals
  SRAM_UB_N_from_the_sram <= internal_SRAM_UB_N_from_the_sram;
  --vhdl renameroo for output signals
  SRAM_WE_N_from_the_sram <= internal_SRAM_WE_N_from_the_sram;
  --vhdl renameroo for output signals
  audio_track_from_the_kanto_ctrl <= internal_audio_track_from_the_kanto_ctrl;
  --vhdl renameroo for output signals
  display_pixel_on_from_the_vga <= internal_display_pixel_on_from_the_vga;
  --vhdl renameroo for output signals
  nios_addr_from_the_kanto_ctrl <= internal_nios_addr_from_the_kanto_ctrl;
  --vhdl renameroo for output signals
  nios_play_from_the_kanto_ctrl <= internal_nios_play_from_the_kanto_ctrl;
  --vhdl renameroo for output signals
  nios_readblock_from_the_kanto_ctrl <= internal_nios_readblock_from_the_kanto_ctrl;
  --vhdl renameroo for output signals
  sdbuf_addr_from_the_sdbuf <= internal_sdbuf_addr_from_the_sdbuf;
  --vhdl renameroo for output signals
  sdbuf_rden_from_the_sdbuf <= internal_sdbuf_rden_from_the_sdbuf;

end europa;


--synthesis translate_off

library altera;
use altera.altera_europa_support_lib.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add your libraries here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>

entity test_bench is 
end entity test_bench;


architecture europa of test_bench is
component nios_system is 
           port (
                 -- 1) global signals:
                    signal clk_0 : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- the_kanto_ctrl
                    signal audio_track_from_the_kanto_ctrl : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal keys_to_the_kanto_ctrl : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal nios_addr_from_the_kanto_ctrl : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal nios_done_to_the_kanto_ctrl : IN STD_LOGIC;
                    signal nios_play_from_the_kanto_ctrl : OUT STD_LOGIC;
                    signal nios_readblock_from_the_kanto_ctrl : OUT STD_LOGIC;
                    signal sd_blockaddr_to_the_kanto_ctrl : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_ps2
                    signal PS2_Clk_to_the_ps2 : IN STD_LOGIC;
                    signal PS2_Data_to_the_ps2 : IN STD_LOGIC;

                 -- the_sdbuf
                    signal sdbuf_addr_from_the_sdbuf : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal sdbuf_data_to_the_sdbuf : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sdbuf_rden_from_the_sdbuf : OUT STD_LOGIC;

                 -- the_sram
                    signal SRAM_ADDR_from_the_sram : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal SRAM_CE_N_from_the_sram : OUT STD_LOGIC;
                    signal SRAM_DQ_to_and_from_the_sram : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal SRAM_LB_N_from_the_sram : OUT STD_LOGIC;
                    signal SRAM_OE_N_from_the_sram : OUT STD_LOGIC;
                    signal SRAM_UB_N_from_the_sram : OUT STD_LOGIC;
                    signal SRAM_WE_N_from_the_sram : OUT STD_LOGIC;

                 -- the_vga
                    signal display_pixel_on_from_the_vga : OUT STD_LOGIC;
                    signal display_x_to_the_vga : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
                    signal display_y_to_the_vga : IN STD_LOGIC_VECTOR (6 DOWNTO 0)
                 );
end component nios_system;

                signal PS2_Clk_to_the_ps2 :  STD_LOGIC;
                signal PS2_Data_to_the_ps2 :  STD_LOGIC;
                signal SRAM_ADDR_from_the_sram :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal SRAM_CE_N_from_the_sram :  STD_LOGIC;
                signal SRAM_DQ_to_and_from_the_sram :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal SRAM_LB_N_from_the_sram :  STD_LOGIC;
                signal SRAM_OE_N_from_the_sram :  STD_LOGIC;
                signal SRAM_UB_N_from_the_sram :  STD_LOGIC;
                signal SRAM_WE_N_from_the_sram :  STD_LOGIC;
                signal audio_track_from_the_kanto_ctrl :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal clk :  STD_LOGIC;
                signal clk_0 :  STD_LOGIC;
                signal display_pixel_on_from_the_vga :  STD_LOGIC;
                signal display_x_to_the_vga :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal display_y_to_the_vga :  STD_LOGIC_VECTOR (6 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa :  STD_LOGIC;
                signal keys_to_the_kanto_ctrl :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal nios_addr_from_the_kanto_ctrl :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal nios_done_to_the_kanto_ctrl :  STD_LOGIC;
                signal nios_play_from_the_kanto_ctrl :  STD_LOGIC;
                signal nios_readblock_from_the_kanto_ctrl :  STD_LOGIC;
                signal reset_n :  STD_LOGIC;
                signal sd_blockaddr_to_the_kanto_ctrl :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal sdbuf_addr_from_the_sdbuf :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal sdbuf_data_to_the_sdbuf :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sdbuf_rden_from_the_sdbuf :  STD_LOGIC;


-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add your component and signal declaration here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>


begin

  --Set us up the Dut
  DUT : nios_system
    port map(
      SRAM_ADDR_from_the_sram => SRAM_ADDR_from_the_sram,
      SRAM_CE_N_from_the_sram => SRAM_CE_N_from_the_sram,
      SRAM_DQ_to_and_from_the_sram => SRAM_DQ_to_and_from_the_sram,
      SRAM_LB_N_from_the_sram => SRAM_LB_N_from_the_sram,
      SRAM_OE_N_from_the_sram => SRAM_OE_N_from_the_sram,
      SRAM_UB_N_from_the_sram => SRAM_UB_N_from_the_sram,
      SRAM_WE_N_from_the_sram => SRAM_WE_N_from_the_sram,
      audio_track_from_the_kanto_ctrl => audio_track_from_the_kanto_ctrl,
      display_pixel_on_from_the_vga => display_pixel_on_from_the_vga,
      nios_addr_from_the_kanto_ctrl => nios_addr_from_the_kanto_ctrl,
      nios_play_from_the_kanto_ctrl => nios_play_from_the_kanto_ctrl,
      nios_readblock_from_the_kanto_ctrl => nios_readblock_from_the_kanto_ctrl,
      sdbuf_addr_from_the_sdbuf => sdbuf_addr_from_the_sdbuf,
      sdbuf_rden_from_the_sdbuf => sdbuf_rden_from_the_sdbuf,
      PS2_Clk_to_the_ps2 => PS2_Clk_to_the_ps2,
      PS2_Data_to_the_ps2 => PS2_Data_to_the_ps2,
      clk_0 => clk_0,
      display_x_to_the_vga => display_x_to_the_vga,
      display_y_to_the_vga => display_y_to_the_vga,
      keys_to_the_kanto_ctrl => keys_to_the_kanto_ctrl,
      nios_done_to_the_kanto_ctrl => nios_done_to_the_kanto_ctrl,
      reset_n => reset_n,
      sd_blockaddr_to_the_kanto_ctrl => sd_blockaddr_to_the_kanto_ctrl,
      sdbuf_data_to_the_sdbuf => sdbuf_data_to_the_sdbuf
    );


  process
  begin
    clk_0 <= '0';
    loop
       wait for 10 ns;
       clk_0 <= not clk_0;
    end loop;
  end process;
  PROCESS
    BEGIN
       reset_n <= '0';
       wait for 200 ns;
       reset_n <= '1'; 
    WAIT;
  END PROCESS;


-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add additional architecture here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>


end europa;



--synthesis translate_on
