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
      display_clk_to_the_vga => display_clk_to_the_vga,
      display_x_to_the_vga => display_x_to_the_vga,
      display_y_to_the_vga => display_y_to_the_vga,
      keys_to_the_kanto_ctrl => keys_to_the_kanto_ctrl,
      nios_done_to_the_kanto_ctrl => nios_done_to_the_kanto_ctrl,
      reset_n => reset_n,
      sd_blockaddr_to_the_kanto_ctrl => sd_blockaddr_to_the_kanto_ctrl,
      sdbuf_data_to_the_sdbuf => sdbuf_data_to_the_sdbuf
    );


