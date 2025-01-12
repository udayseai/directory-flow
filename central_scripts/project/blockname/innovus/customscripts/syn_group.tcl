#set all_regs [get_db insts -if .is_sequential]
reset_path_group -all
#  Reset all options set on all path groups.
#  resetPathGroupOptions (CUI : reset_path_group_options)
#
#  # Create collection for each category
set inp   [all_inputs -no_clocks]
set outp  [all_outputs]
set mems  [all_registers -macros ]
set icgs  [filter_collection [all_registers] "is_integrated_clock_gating_cell == true"]
set regs  [remove_from_collection [all_registers -edge_triggered] $icgs]
set allregs  [all_registers]
#  # Create IO Path Groups
group_path   -name In2Reg       -from  $inp -to $allregs
group_path   -name Reg2Out      -from $allregs -to $outp
group_path   -name In2Out       -from $inp   -to $outp
#
#  #Create REG Path Groups
group_path   -name Reg2Reg      -from $regs -to $regs
#  group_path   -name Reg2Mem      -from $regs -to $mems
#  group_path   -name Mem2Reg      -from $mems -to $regs
group_path   -name Reg2ClkGate  -from $allregs -to $icgs
#
#foreach group {Reg2Reg Reg2ClkGate} {
#set_path_group_options $group -effort_level high
#}
#
#set_path_group_options Reg2Out -slack_adjustment 5 -effort_level low
#set_path_group_options In2Reg -slack_adjustment 5 -effort_level low
#
#
#############################
#set all_regs  [all_registers]
#set icgs  [filter_collection [all_registers] "is_integrated_clock_gating_cell == true"]
#set regs  [remove_from_collection [all_registers -edge_triggered] $icgs]
#define_cost_group -name Reg2Reg
#path_group -from $regs -to $regs -group Reg2Reg -name Reg2Reg
#define_cost_group -name In2Reg
#path_group -from [all_inputs -no_clocks] -to $all_regs -group In2Reg -name In2Reg
#define_cost_group -name Reg2Out
#path_group -from $all_regs -to [all_outputs] -group Reg2Out -name Reg2Out
#define_cost_group -name In2Out
#path_group -from [all_inputs -no_clocks] -to [all_outputs] -group In2Out -name In2Out
#define_cost_group -name Reg2ClkGate
#path_group -from $all_regs -to $icgs -group Reg2ClkGate -name Reg2ClkGate

####
#group_path -from [all_registers] -to [all_registers] -name REG2REG 
#group_path -from [all_inputs -no_clocks] -to [all_registers] -name IN2REG
#group_path -from [all_registers] -to [all_outputs] -name REG2OUT
#group_path -from [all_inputs -no_clocks] -to [all_outputs] -name IN2OUT
#group_path -from [all_registers] -to cs_registers_i_mcountinhibit_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to cs_registers_i_mcountinhibit_q_reg[*]/E -name group_test -weight 2.0
#group_path -from [all_registers] -to cs_registers_i_mcycle_counter_i_counter_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to cs_registers_i_minstret_counter_i_counter_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to cs_registers_i_u_dcsr_csr_rdata_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to cs_registers_i_u_depc_csr_rdata_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to cs_registers_i_u_dscratch0_csr_rdata_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to cs_registers_i_u_dscratch1_csr_rdata_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to cs_registers_i_u_mcause_csr_rdata_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to cs_registers_i_u_mepc_csr_rdata_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to cs_registers_i_u_mie_csr_rdata_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to cs_registers_i_u_mscratch_csr_rdata_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to cs_registers_i_u_mscratch_csr_rdata_q_reg[*]/E -name group_test -weight 2.0
#group_path -from [all_registers] -to cs_registers_i_u_mstatus_csr_rdata_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to cs_registers_i_u_mstatus_csr_rdata_q_reg[*]/E -name group_test -weight 2.0
#group_path -from [all_registers] -to cs_registers_i_u_mtval_csr_rdata_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to cs_registers_i_u_mtvec_csr_rdata_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to ex_block_i_gen_multdiv_fast.multdiv_i_div_by_zero_q_reg/D -name group_test -weight 2.0
#group_path -from [all_registers] -to ex_block_i_gen_multdiv_fast.multdiv_i_div_counter_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to ex_block_i_gen_multdiv_fast.multdiv_i_md_state_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to ex_block_i_gen_multdiv_fast.multdiv_i_op_numerator_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to ex_block_i_gen_multdiv_fast.multdiv_i_op_quotient_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to gen_regfile_ff.register_file_i_rf_reg_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to gen_regfile_ff.register_file_i_rf_reg_q_reg[*]/E -name group_test -weight 2.0
#group_path -from [all_registers] -to gen_regfile_ff.register_file_i_rf_reg_q_reg[*]/SE -name group_test -weight 2.0
#group_path -from [all_registers] -to gen_regfile_ff.register_file_i_rf_reg_q_reg[*]/SI -name group_test -weight 2.0
#group_path -from [all_registers] -to id_stage_i_controller_i_ctrl_fsm_cs_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to id_stage_i_controller_i_exc_req_q_reg/D -name group_test -weight 2.0
#group_path -from [all_registers] -to id_stage_i_controller_i_illegal_insn_q_reg/D -name group_test -weight 2.0
#group_path -from [all_registers] -to id_stage_i_g_branch_set_flop.branch_set_q_reg/D -name group_test -weight 2.0
#group_path -from [all_registers] -to id_stage_i_id_fsm_q_reg/D -name group_test -weight 2.0
#group_path -from [all_registers] -to id_stage_i_imd_val_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_gen_prefetch_buffer.prefetch_buffer_i_branch_discard_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_gen_prefetch_buffer.prefetch_buffer_i_fetch_addr_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_gen_prefetch_buffer.prefetch_buffer_i_fetch_addr_q_reg[*]/DB -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_gen_prefetch_buffer.prefetch_buffer_i_fetch_addr_q_reg[*]/E -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_gen_prefetch_buffer.prefetch_buffer_i_fetch_addr_q_reg[*]/SA -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_gen_prefetch_buffer.prefetch_buffer_i_fifo_i_err_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_gen_prefetch_buffer.prefetch_buffer_i_fifo_i_instr_addr_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_gen_prefetch_buffer.prefetch_buffer_i_fifo_i_instr_addr_q_reg[*]/E -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_gen_prefetch_buffer.prefetch_buffer_i_fifo_i_rdata_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_gen_prefetch_buffer.prefetch_buffer_i_fifo_i_valid_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_gen_prefetch_buffer.prefetch_buffer_i_rdata_outstanding_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_gen_prefetch_buffer.prefetch_buffer_i_stored_addr_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_gen_prefetch_buffer.prefetch_buffer_i_valid_req_q_reg/D -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_illegal_c_insn_id_o_reg/D -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_instr_fetch_err_o_reg/E -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_instr_fetch_err_plus2_o_reg/E -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_instr_is_compressed_id_o_reg/D -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_instr_rdata_alu_id_o_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_instr_rdata_alu_id_o_reg[*]/SN -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_instr_rdata_c_id_o_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_instr_rdata_c_id_o_reg[*]/E -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_instr_rdata_id_o_reg[*]/D -name group_test2 -weight 2.0
#group_path -from [all_registers] -to if_stage_i_instr_rdata_id_o_reg[*]/SN -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_instr_valid_id_q_reg/D -name group_test -weight 2.0
#group_path -from [all_registers] -to if_stage_i_pc_id_o_reg[*]/E -name group_test -weight 2.0
#group_path -from [all_registers] -to load_store_unit_i_addr_last_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to load_store_unit_i_addr_last_q_reg[*]/SE -name group_test -weight 2.0
#group_path -from [all_registers] -to load_store_unit_i_addr_last_q_reg[*]/SI -name group_test -weight 2.0
#group_path -from [all_registers] -to load_store_unit_i_data_sign_ext_q_reg/SE -name group_test -weight 2.0
#group_path -from [all_registers] -to load_store_unit_i_data_type_q_reg[*]/SE -name group_test -weight 2.0
#group_path -from [all_registers] -to load_store_unit_i_data_we_q_reg/SE -name group_test -weight 2.0
#group_path -from [all_registers] -to load_store_unit_i_handle_misaligned_q_reg/D -name group_test -weight 2.0
#group_path -from [all_registers] -to load_store_unit_i_ls_fsm_cs_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to load_store_unit_i_rdata_offset_q_reg[*]/D -name group_test -weight 2.0
#group_path -from [all_registers] -to load_store_unit_i_rdata_offset_q_reg[*]/SE -name group_test -weight 2.0
