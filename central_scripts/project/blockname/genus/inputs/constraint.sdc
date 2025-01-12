set clk_name  core_clock
set clk_port_name clk_i
set_units -time ns

#setLibraryUnit -time 1ns
set clk_period 1.5
set clk_io_pct 0.5
#set max_tran 0.1


set clk_port [get_ports $clk_port_name]
#set_max_transition $max_tran [current_design]
create_clock -name $clk_name -period $clk_period $clk_port

set_clock_uncertainty -setup [expr $clk_period * 0.2] [get_clocks core_clock ] 
set_clock_uncertainty -hold [expr $clk_period * 0.1] [get_clocks core_clock]


set inputs_no_clocks [all_inputs -no_clocks]

set_input_delay  [expr $clk_period * $clk_io_pct] -clock $clk_name $inputs_no_clocks
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs]


#set_ccopt_property insertion_delay 0.150 -pin if_stage_i_gen_prefetch_buffer.prefetch_buffer_i_fifo_i_rdata_q_reg[1]/CP

