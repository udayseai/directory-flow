# Reset all existing path groups, including basic path groups
set_interactive_constraint_modes [get_db analysis_views .constraint_mode.name]
reset_path_group -all
set inp   [all_inputs -no_clocks]
set outp  [all_outputs]
set mems  [all_registers -macros ]
set icgs  [filter_collection [all_registers] "is_integrated_clock_gating_cell == true"]
set regs  [remove_from_collection [all_registers -edge_triggered] $icgs]
set allregs  [all_registers]
# Create IO Path Groups
group_path  -name In2Reg   -from  $inp -to $allregs  -weight 1.0  -exception_name In2Reg
group_path  -name Reg2Out  -from $allregs -to $outp  -weight 1.0  -exception_name Reg2Out
group_path  -name In2Out   -from $inp   -to $outp   -weight 1.0   -exception_name In2Out

#Create REG Path Groups
group_path   -name Reg2Reg      -from $regs -to $regs -weight 3.0  -exception_name Reg2Reg
if [llength $icgs] {
group_path   -name Reg2ClkGate  -from $allregs -to $icgs -weight 1.0  -exception_name Reg2ClkGate
}
if [llength $mems] {
group_path   -name Reg2Mem      -from $regs -to $mems -weight 1.0
group_path   -name Mem2Reg      -from $mems -to $regs -weight 1.0
}

 
