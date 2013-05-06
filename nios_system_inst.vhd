  --Example instantiation for system 'nios_system'
  nios_system_inst : nios_system
    port map(
      SRAM_ADDR_from_the_sram => SRAM_ADDR_from_the_sram,
      SRAM_CE_N_from_the_sram => SRAM_CE_N_from_the_sram,
      SRAM_DQ_to_and_from_the_sram => SRAM_DQ_to_and_from_the_sram,
      SRAM_LB_N_from_the_sram => SRAM_LB_N_from_the_sram,
      SRAM_OE_N_from_the_sram => SRAM_OE_N_from_the_sram,
      SRAM_UB_N_from_the_sram => SRAM_UB_N_from_the_sram,
      SRAM_WE_N_from_the_sram => SRAM_WE_N_from_the_sram,
      nios_addr_from_the_kanto_ctrl => nios_addr_from_the_kanto_ctrl,
      nios_play_from_the_kanto_ctrl => nios_play_from_the_kanto_ctrl,
      nios_readblock_from_the_kanto_ctrl => nios_readblock_from_the_kanto_ctrl,
      nios_stop_from_the_kanto_ctrl => nios_stop_from_the_kanto_ctrl,
      clk_0 => clk_0,
      nios_done_to_the_kanto_ctrl => nios_done_to_the_kanto_ctrl,
      reset_n => reset_n,
      sd_blockaddr_to_the_kanto_ctrl => sd_blockaddr_to_the_kanto_ctrl
    );


