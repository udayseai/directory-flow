 #  Reset all existing path groups, including basic path groups
 reset_path_group -all
 #  Reset all options set on all path groups.
 reset_path_group_options 

 # Create collection for each category
 set inp   [all_inputs -no_clocks]
 set outp  [all_outputs]
 #set mems  [all_registers -macros ]
 set icgs  [filter_collection [all_registers] "is_integrated_clock_gating_cell == true"]
 set regs  [remove_from_collection [all_registers -edge_triggered] $icgs]
 set allregs  [all_registers]
 # Create IO Path Groups
 group_path   -name In2Reg       -from  $inp -to $allregs
 group_path   -name Reg2Out      -from $allregs -to $outp
 group_path   -name In2Out       -from $inp   -to $outp

 #Create REG Path Groups
 group_path   -name Reg2Reg      -from $regs -to $regs
 #group_path   -name Reg2Mem      -from $regs -to $mems
 #group_path   -name Mem2Reg      -from $mems -to $regs
 group_path   -name Reg2ClkGate  -from $allregs -to $icgs

 set_path_group_options Reg2Out -slack_adjustment 5 -effort_level low
 set_path_group_options In2Reg -slack_adjustment 5 -effort_level low

 foreach group {Reg2Reg Reg2ClkGate} {
 set_path_group_options $group -effort_level high
 }
