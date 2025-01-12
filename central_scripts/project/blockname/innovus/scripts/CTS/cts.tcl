set current_stage cts
set work_dir [pwd]
source ../config.tcl
read_db $place_db 
set_interactive_constraint_modes func
#######SOCV_ENABLING################
set_db timing_analysis_aocv true
if {$AOCV_MODE != ""} {
set_db timing_extract_model_aocv_mode $AOCV_MODE
}
###Clock tree spec and NDR rules
#

create_route_rule -name $route_rule1 -spacing $rr1_spacing -width $rr1_width
create_route_rule -name $route_rule2  -width $rr2_width

create_route_type -name TOP -route_rule $route_rule1 -top_preferred_layer $rr1_top_layer -bottom_preferred_layer $rr1_bottom_layer -shield_net VSS -preferred_routing_layer_effort high
create_route_type -name TRUNK -route_rule $route_rule1 -top_preferred_layer $rr1_top_layer -bottom_preferred_layer $rr1_bottom_layer -shield_net VSS  -preferred_routing_layer_effort high
create_route_type -name LEAF -route_rule $route_rule2 -top_preferred_layer $rr2_top_layer -bottom_preferred_layer $rr2_bottom_layer  -preferred_routing_layer_effort high


set_db clock_trees .cts_route_type_top TOP
set_db clock_trees .cts_route_type_trunk TRUNK
set_db clock_trees .cts_route_type_leaf LEAF

create_clock_tree_spec -out_file ../outputs/CTS/cts_tree_spec.tcl
source ../outputs/CTS/cts_tree_spec.tcl

set_db cts_target_max_transition_time $max_transition
set_db cts_target_max_capacitance $max_capacitance
set_db opt_max_length $max_length
set_db cts_max_fanout $max_fanout
set_db cts_update_clock_latency false
set_db cts_fix_clock_sinks true
set_db cts_detailed_cell_warnings true

##########USEFUL_SKEW######################
if {$CTS_USEFULL_SKEW == "true"} {
        set_db opt_useful_skew true
        set_db opt_useful_skew_ccopt extreme
}
if {$CTS_USEFULL_SKEW != "true" } {
        set_db opt_useful_skew false
        set_db opt_useful_skew_ccopt none
}
#######CTS_POWER_OPTIMIZATION#############

if {$CTS_POWER_EFFORT != ""} {
set_db opt_power_effort $CTS_POWER_EFFORT
}
set_db opt_leakage_to_dynamic_ratio $leakage_to_dynamic_ratio 
############CLOCK_TREE####################
set_db cts_spec_config_create_clock_tree_source_groups true
set_db clock_trees .cts_buffer_cells $CTS_BUFFERS
set_db clock_trees .cts_inverter_cells $CTS_INVERTERS
set_db clock_trees .cts_clock_gating_cells $CTS_CLOCK_GATING_CELLS
#set_dont_touch $ckg_list false
#set HVT_CELL [dbget head.lib.cells.name *CLK*HVT*]
#set_dont_use $HVT_CELL
##############H_TREE_CLOCK_BUILDING################

create_flexible_htree -name htree -source clk_i -trunk_cell {$trunk_cell} -final_cell {$final_cell} -sink_grid {$sink_grid} -sink_grid_sink_area {$sink_area} -sink_grid_box {$sink_grid_box} -sink_instance_prefix TAP -adjust_sink_grid_for_aspect_ratio true -mode drv -image_directory ../reports/CTS/htree_debug

# MANUALLY TRANSLATE (WARN-2): Command 'set_ccopt_property' is obsolete in common UI and is removed. Please refer to 'get_common_ui_map get_ccopt_property' and 'get_ccopt_property_common_ui_map <legacy_property_name>'for further information.
#set_ccopt_property balance_mode full
set_db cts_balance_mode full
synthesize_flexible_htrees -use_estimated_routes
route_flexible_htrees
# MANUALLY TRANSLATE (WARN-2): Command 'set_ccopt_property' is obsolete in common UI and is removed. Please refer to 'get_common_ui_map get_ccopt_property' and 'get_ccopt_property_common_ui_map <legacy_property_name>'for further information.
# set_ccopt_property extract_balance_multi_source_clocks true
set_db cts_spec_config_create_clock_tree_source_groups true

#set_ccopt_property clustering_source_group_max_cloned_fraction 0.5
set_db cts_clustering_source_group_max_cloned_fraction $max_cloned_fraction

set_dont_touch $ckg_list false
# MANUALLY TRANSLATE (WARN-2): Command 'set_ccopt_property' is obsolete in common UI and is removed. Please refer to 'get_common_ui_map get_ccopt_property' and 'get_ccopt_property_common_ui_map <legacy_property_name>'for further information.
# set_ccopt_property clone_clock_gates true
set_db cts_clone_clock_logic true

set_db opt_fix_hold_allow_setup_tns_degradation false
set_db opt_hold_target_slack $hold_target_slack ; set_db opt_setup_target_slack $setup_target_slack

##########CTS_OPTIMIZATIONS#############
ccopt_design -report_dir ../reports/timingreports
opt_power -post_cts
#########PRIORITIZE_ROUTING_OF_CLK_NETS#######
set_db route_design_with_si_driven true
#########Antenna_Fix#################
check_process_antenna -out_file ../reports/CTS/cts_reports/verify_antenna.rpt
set_db route_design_detail_fix_antenna true
#setNanoRouteMode -routeAntennaCellName ANTENNABWP16P90 
#setNanoRouteMode -routeInsertAntennaDiode true -routeAddAntennaInstPrefix ANTENNA
check_process_antenna -out_file ../reports/CTS/cts_reports/verify_antenna.rpt

#######To_Keep_Registers_FIXED########
set flopName [all_registers -flops]
# MANUALLY TRANSLATE (WARN-2): Command 'selectInst' is obsolete in common UI and is removed. 
# selectInst $flopName
select_obj  $flopName

# MANUALLY TRANSLATE (WARN-2): Command 'dbset' is obsolete in common UI and is removed. 
# dbset selected.pstatus fixed
set_db selected .place_status fixed

########PG_CONNECTIVITY##############
connect_global_net VDD -type pg_pin -pin_base_name VDD -override -verbose
connect_global_net VSS -type pg_pin -pin_base_name VSS -override -verbose
#output 
set outputs $work_dir/../outputs/CTS/cts_outputs
set current_step cts
set report_dir $work_dir/../reports/CTS/cts_timing_reports
set reports_dir $work_dir/../reports/CTS/cts_reports
write_def $outputs/${current_step}.v -netlist
write_db $work_dir/../data/CTS/cts_database/cts.enc
write_netlist $outputs/${current_step}.v
## Time Reports
time_design -expanded_views -post_cts -report_dir $report_dir
time_design -expanded_views -post_cts -hold -report_dir $report_dir
check_drc -limit $limit -out_file $reports_dir/$current_step_drc.rpt
check_place > $reports_dir/$current_step.check.rpt
report_timing -late -max_paths $max_paths -nworst $nworst -max_slack $max_slack > $reports_dir/$current_step.report_timing.rpt
report_timing -early -max_paths $max_paths -nworst $nworst -max_slack $max_slack > $reports_dir/$current_step.report_timing.hold.rpt
check_timing -verbose >> $reports_dir/$current_step.check_timing.rpt
check_design -type cts -out_file $reports_dir/$current_step.check_design.rpt
report_congestion -hotSpot -overflow > $reports_dir/${current_step}_report_congestion.rpt
report_clock_timing -type summary > $reports_dir/${current_step}_clock_timing.rpt
report_constraint -all_violators > $reports_dir/$current_step.report_constraints.rpt
report_power -out_file $reports_dir/$current_step.report_power.rpt
# MANUALLY TRANSLATE : Command 'report_area' has no common UI definition and is removed, contact Cadence for support. 
report_area > $reports_dir/$current_step.report_area.rpt
report_summary -out_dir $reports_dir/design_summary
gui_write_flow_gifs -dir ../SnapShorts/CTS/cts -prefix cts



#hold optimization
set_interactive_constraint_modes func
set_propagated_clock [all_clocks ]
set_db opt_hold_cells $HOLD_CELLS
opt_design -post_cts -hold -report_dir ../reports/timingreports

#output 
set outputs $work_dir/../outputs/CTS/cts_opt_outputs
set current_step cts_opt
set reports_dir $work_dir/../reports/CTS/cts_opt_reports
set report_dir $work_dir/../reports/CTS/cts_opt_timing_reports
write_def $outputs/${current_step}.def
#defOut $outputs/${current_step}.v -netlist
write_db $work_dir/../data/CTS/cts_database/cts_hold.enc
write_netlist $outputs/${current_step}.v
## Time Reports
check_floorplan -report_density > $report_dir/$current_step.cts_utilization.rpt
report_clock_timing -type skew > $report_dir/$current_step.report_clock_skew.rpt
report_clock_trees -out_file  ../reports/CTS/clock_trees.rpt
time_design -expanded_views -post_cts -report_dir $report_dir
time_design -expanded_views -post_cts -hold -report_dir $report_dir
check_drc -limit $limit -out_file $reports_dir/$current_step_drc.rpt
check_place > $reports_dir/$current_step.check.rpt
check_design -type cts -out_file $reports_dir/$current_step.check_design.rpt
report_timing -late -max_paths $max_paths -nworst $nworst -max_slack $max_slack > $reports_dir/$current_step.report_timing.rpt
report_timing -early -max_paths $max_paths -nworst $nworst -max_slack $max_slack > $reports_dir/$current_step.report_timing.hold.rpt
check_timing -verbose >> $reports_dir/$current_step.check_timing.rpt
report_congestion -hotSpot -overflow > $reports_dir/${current_step}_report_congestion.rpt
report_clock_timing -type summary > $reports_dir/${current_step}_clock_timing.rpt
report_constraint -all_violators > $reports_dir/$current_step.report_constraints.rpt
report_power -out_file $reports_dir/$current_step.report_power.rpt
# MANUALLY TRANSLATE : Command 'report_area' has no common UI definition and is removed, contact Cadence for support. 
report_area > $reports_dir/$current_step.report_area.rpt
report_summary -out_dir $reports_dir/design_summary
#source $work_dir/../reports_procs.tcl
# MANUALLY TRANSLATE : File '../customscripts/qor_script.tcl' does not exist.
source ../customscripts/qor_script.tcl
# MANUALLY TRANSLATE : File '../customscripts/report_script.tcl' does not exist.
source ../customscripts/report_script.tcl
# MANUALLY TRANSLATE : File '../customscripts/reports_qor_cts.tcl' does not exist.
source ../customscripts/reports_qor_cts.tcl
gui_write_flow_gifs -dir ../SnapShorts/CTS/cts_hold -prefix opt_cts 
#exit
