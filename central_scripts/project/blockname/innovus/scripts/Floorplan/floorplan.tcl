set current_stage floorplan
set work_dir [pwd]
source ../config.tcl
set_db init_lef_files $lef_file_list
set_db init_netlist_files $synthesis_netlist
set_db init_mmmc_files $mmmc_file
set_db init_power_nets VDD
set_db init_ground_nets VSS
read_mmmc "$mmmc_file"
read_physical -lef "$lef_file_list"
read_netlist "$synthesis_netlist" -top "$design"
init_design

##define SOCV variable (true|false)##
if {$SOCV_MODE != ""} {set_db timing_analysis_socv $SOCV_MODE}
## read switching_activity_file ##
if {$switching_activity_file != ""} {source $switching_activity_file}
##scan_def##
if {$scan_def != ""} {read_def $scan_def}
## read partion def##
if {$fp_partition_def != ""} {read_def $fp_partition_def} elseif { $aspect_ratio!="" && $utilization !="" } {create_floorplan -core_density_size $aspect_ratio $utilization $left $bottom $right $top } else { create_floorplan -site core -core_size $fp_x $fp_y $io_boundary $io_boundary $io_boundary $io_boundary }

### core_row creation ###
set_db floorplan_default_tech_site [get_db current_design .core_site.name]

## tracks creation ##
add_tracks

#powergrid
connect_global_net VSS -type pgpin -pin_base_name VSS
connect_global_net VDD -type pgpin -pin_base_name VDD



#### PIN Placement ####
set_db assign_pins_edit_in_batch true 
edit_pin -pin [get_db current_design .ports.name] -layer {M4 M6} -side top -spread_direction clockwise -snap track -pattern fill_track -spacing 1 -start {10 86.400} -end {86.904 86.400} -fix_overlap
legalize_pins
check_pin_assignment -out_file $report_dir/${current_step}.checkPin.rpt

source power.tcl

### Physical cells insertion ##
source $physical_cells

## to check propagated clock ##
#get_propagated_clock -clock [get_clocks]
#set_sense [get_clocks] -stop_propagation
report_clocks

#output 

write_def -floorplan $output_dir/${current_step}.def
write_def -floorplan $output_dir/${current_step}.v -netlist

check_legacy_design -floorplan -no_html -out_file $report_dir/$current_step.checkdesign.rpt
check_place  $report_dir/$current_step.report_utilization.rpt

write_db $data_dir/fp.enc
write_floorplan_script -sections pins $output_dir/$design.pin.tcl
## Time Reports
time_design -expanded_views -pre_place -report_dir $report_dir

report_timing -max_paths 1000000 -max_slack 0.0 -output_format gtd -late > setup.rpt
report_timing -max_paths 1000000 -max_slack 0.0 -output_format gtd -early > hold.rpt
set fpp [open instt w];puts $fpp "{";foreach i [get_db insts] {if {[get_db $i .base_cell.is_inverter]} {puts $fpp "\"[get_db $i .name]\":\"inverter\","} elseif {[get_db $i .base_cell.is_buffer]} {puts $fpp "\"[get_db $i .name]\":\"buffer\","} elseif {[get_db $i .base_cell.is_combinational]} {puts $fpp "\"[get_db $i .name]\":\"combinational\","} elseif {[get_db $i .base_cell.is_sequential]} {puts $fpp "\"[get_db $i .name]\":\"sequential\","}};foreach i [get_db current_design .nets] {try {set name [get_db $i .name];set length [expr [string map {" " "+"} [get_db $i .wires.length]]];puts $fpp "\"$name\":$length,"} on error {msg} {puts $fpp "\"$name\":0,"}};puts $fpp "}";close $fpp;
python3.9 ../../customscripts/machinetiming.py setup.rpt  $csv_dir/setuptiming
python3.9 ../../customscripts/machinetiming.py hold.rpt  $csv_dir/holdtiming


## Checks
check_timing -verbose >> $report_dir/$current_step.check_timing.rpt
## Reports
report_constraint -all_violators > $report_dir/$current_step.report_constaints.rpt
report_power > $report_dir/$current_step.report_power.rpt
report_area -out_file $report_dir/$current_step.report_power.rpt


rm -rf hold.rpt  instt setup.rpt
###*** to generate csv 
source ../../customscripts/generate_csv.tcl

###***  SnapShot
gui_write_flow_gifs -dir $snap_dir -prefix floor_plan
rm -rf hold.rpt  instt setup.rpt

exit
