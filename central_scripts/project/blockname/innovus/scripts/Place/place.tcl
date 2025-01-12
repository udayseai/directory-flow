set current_stage place
set work_dir [pwd]
source ../config.tcl
read_db $fp_db 
source ../../inputs/path_group.tcl
set_interactive_constraint_modes func

## adding uncertainity to the place stage values given in config 
uncertainty $current_stage

# Setting max density 
if {$maxDensity != ""} {
    set_db opt_max_density $maxDensity
}
# Enabling DRV fixing
if {$fix_cap != "" && $fix_tran != "" && $fix_fanout_load != ""} {
    set_db opt_drv_fix_max_cap $fix_cap ; set_db opt_drv_fix_max_tran $fix_tran ; set_db opt_fix_fanout_load $fix_fanout_load
}

# Setting early clock flow 
if {$earlyClockFlow  != ""} {
    set_db design_early_clock_flow $earlyClockFlow 
}


 # Setting global timing effort 
if {$timing_effort != ""} {
    set_db place_global_timing_effort $timing_effort
}
# Setting IR drop aware effort with condition
if {$irdrop_effort != ""} {
    set_db place_detail_irdrop_aware_effort $irdrop_effort
}

# Setting  congestion effort 
if {$congestion_effort != " "} {
set_db place_global_cong_effort $congestion_effort 
}
# setting magnet  placement
#if {$sram_list != ""} {
#    place_connected -attractor "$sram_list" -sequential direct_connected
#}
connect_global_net VDD -type tie_hi
connect_global_net VSS -type tie_lo

# Setting Tie Hi/Lo
if {$max_fanout != "" && $max_distance != "" && $tie_cells != ""} {
    set_db add_tieoffs_max_fanout $max_fanout ; set_db add_tieoffs_max_distance $max_distance ; set_db add_tieoffs_cells $tie_cells
}
place_opt_design -report_dir $report_dir/Place_opt_reports
# Adding TieLo 
if {$keep_existing != "" && $prefix_tielo != "" && $cell_tielo != "" && $create_hier_port != ""} {
    add_tieoffs -keep_existing $keep_existing -prefix $prefix_tielo -lib_cell $cell_tielo -create_hport $create_hier_port
}

# Adding TieHi 
if {$keep_existing != "" && $prefix_tiehi != "" && $cell_tiehi != "" && $create_hier_port != ""} {
    add_tieoffs -keep_existing $keep_existing -prefix $prefix_tiehi -lib_cell $cell_tiehi -create_hport $create_hier_port
}

check_tieoffs -out_file $report_dir/$design.tie.rpt

set_db opt_fix_drv true 
write_def $output_dir/${current_step}.def
write_db $data_dir/place.enc
write_netlist $output_dir/${current_step}.v

report_timing -max_paths 1000000 -max_slack 0.0 -output_format gtd -late > setup.rpt
report_timing -max_paths 1000000 -max_slack 0.0 -output_format gtd -early > hold.rpt
set fpp [open instt w];puts $fpp "{";foreach i [get_db insts] {if {[get_db $i .base_cell.is_inverter]} {puts $fpp "\"[get_db $i .name]\":\"inverter\","} elseif {[get_db $i .base_cell.is_buffer]} {puts $fpp "\"[get_db $i .name]\":\"buffer\","} elseif {[get_db $i .base_cell.is_combinational]} {puts $fpp "\"[get_db $i .name]\":\"combinational\","} elseif {[get_db $i .base_cell.is_sequential]} {puts $fpp "\"[get_db $i .name]\":\"sequential\","}};foreach i [get_db current_design .nets] {try {set name [get_db $i .name];set length [expr [string map {" " "+"} [get_db $i .wires.length]]];puts $fpp "\"$name\":$length,"} on error {msg} {puts $fpp "\"$name\":0,"}};puts $fpp "}";close $fpp;
python3.9 ../../customscripts/machinetiming.py setup.rpt  $csv_dir/setuptiming
python3.9 ../../customscripts/machinetiming.py hold.rpt  $csv_dir/holdtiming

## Checks
check_timing -verbose >> $report_dir/$current_step.check_timing.rpt
check_design -type place -out_file $report_dir/$current_step.check_design.rpt
check_place > $report_dir/$current_step.check.rpt
## Reports
report_constraint -all_violators > $report_dir/$current_step.report_constaints.rpt
report_power -out_file $report_dir/$current_step.report_power.rpt
report_area > $report_dir/$current_step.report_area.rpt
report_congestion -overflow -hotSpot > $report_dir/$current_step.report_congestion.rpt
report_summary -out_dir $report_dir/design_summary

###*** to generate csv 
source ../../customscripts/generate_csv.tcl

###snapshots
gui_write_flow_gifs -dir $snap_dir -prefix place

rm -rf hold.rpt  instt setup.rpt
exit

