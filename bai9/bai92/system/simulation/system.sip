set_global_assignment -entity "system" -library "lib_system" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "system" -library "lib_system" -name IP_TOOL_VERSION "13.0sp1"
set_global_assignment -entity "system" -library "lib_system" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_system" -name SPD_FILE [file join $::quartus(sip_path) "../../system.spd"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "../../system.qsys"]

set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "system.v"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_irq_mapper.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_arbitrator.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_rsp_xbar_mux_001.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_rsp_xbar_mux.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_rsp_xbar_demux_003.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_rsp_xbar_demux.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_cmd_xbar_mux.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_cmd_xbar_demux_001.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_cmd_xbar_demux.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_controller.v"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_synchronizer.v"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_controller.sdc"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_id_router_003.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_id_router.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_addr_router_001.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_addr_router.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_avalon_sc_fifo.v"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_slave_agent.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_burst_uncompressor.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_master_agent.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_slave_translator.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_merlin_master_translator.sv"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/Memory.v"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_jtag_uart_0.v"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_onchip_memory2_0.hex"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_onchip_memory2_0.v"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_nios2_qsys_0.sdc"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_nios2_qsys_0.v"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_nios2_qsys_0_jtag_debug_module_sysclk.v"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_nios2_qsys_0_jtag_debug_module_tck.v"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_nios2_qsys_0_jtag_debug_module_wrapper.v"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_nios2_qsys_0_nios2_waves.do"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_nios2_qsys_0_ociram_default_contents.dat"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_nios2_qsys_0_ociram_default_contents.hex"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_nios2_qsys_0_ociram_default_contents.mif"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_nios2_qsys_0_oci_test_bench.v"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_nios2_qsys_0_rf_ram_a.dat"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_nios2_qsys_0_rf_ram_a.hex"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_nios2_qsys_0_rf_ram_a.mif"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_nios2_qsys_0_rf_ram_b.dat"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_nios2_qsys_0_rf_ram_b.hex"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_nios2_qsys_0_rf_ram_b.mif"]
set_global_assignment -library "lib_system" -name MISC_FILE [file join $::quartus(sip_path) "submodules/system_nios2_qsys_0_test_bench.v"]
