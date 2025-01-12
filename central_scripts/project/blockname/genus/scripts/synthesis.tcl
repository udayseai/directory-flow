
set current_stage synthesis
source ../config.tcl -quiet
set_db init_lib_search_path $lib_search_path
set_db init_hdl_search_path $hdl_search_path
set_db library $library_list
read_hdl -sv $hdl_file_list
set_db lp_insert_clock_gating $clock_gating_insertion
set_db syn_global_effort $congestion_effort
set_db congestion_effort $congestion_effort
set_db use_multibit_cells $multi_bit_cells_merging

if {$dont_use_cells != ""} {set_dont_use $dont_use_cells true}
if {$dont_touch_cells != ""} {set_dont_touch $dont_touch_cells true}

## Provide either cap_table_file or the qrc_tech_file
#set_db / .cap_table_file <file> 
if {$qrc_tech_file != ""} {read_qrc $qrc_tech_file}


##elaboration stage

elaborate $design
time_info Elaboration
check_design -unresolved
read_sdc $sdc
uncertainty $current_stage

puts "The number of exceptions is [llength [vfind "design:$design" -exception *]]"

# To eliminate high drive strength buffer cells

set a [get_db lib_cells .base_cell -if {.is_buffer == true } ]
set matching_cells {}
if { $buffer_cell_pattern != ""} {
foreach i $a {
    if {[regexp $buffer_cell_pattern $i match cell_name]} {
        lappend matching_cells $cell_name	
    }
}
set_dont_use $matching_cells
}

## generic stage

syn_generic
time_info GENERIC
write_snapshot -outdir $report_dir -tag generic
report_summary -directory $report_dir

#to extract the csv files:
source $work_dir/../../customscripts/genus_individual.tcl
stage_individual generic

## to merge multibit cells if present in the design
if { [llength [get_db insts -if {.lib_cells.bit_width > 1} ]] > 0 } {  merge_to_multibit_cells -logical $design  }

## mapping stage
syn_map
time_info MAPPED
write_snapshot -outdir $report_dir -tag map
report_summary -directory $report_dir
stage_individual map

## lec between rtl and fv_map
write_do_lec -golden_design rtl -revised_design fv_map -tmp_dir LEC -hierarchical_reference -log_file $logs_dir/rtl2fv.log > rtl_to_fv_map.do
lec -xl -nogui -dofile rtl_to_fv_map.do

if { $path_group != ""} {
source $path_group 
}

#optimazation stage
syn_opt
write_snapshot -outdir $report_dir -tag syn_opt
report_summary -directory $report_dir
time_info OPT

#lec between fv_map and final netlist
write_hdl > $design.v
write_do_lec -golden_design fv_map -revised_design $design.v -tmp_dir LEC -hierarchical_reference -log_file $logs_dir/fv2netlist.log > fv_map_to_netlist.do
lec -xl -nogui -dofile fv_map_to_netlist.do

##inncremental optimazation stage

#set_db syn_opt_effort low
#syn_opt -incremental
#write_snapshot -outdir $report_dir -tag syn_opt_low_incr 
#report_summary -directory $report_dir
#time_info INCREMENTAL_POST_SCAN_CHAINS

stage_individual opt

write_hdl > $output_dir/$design.v
write_script > $report_dir/$design.flow.tcl
report_clock_gating > $report_dir/$design.clockgating.rpt
report_power  > $report_dir/$design.power.rpt
report_gates -power > $report_dir/$design.gates_power.rpt
check_timing_intent > $report_dir/$design.timing_intent.rpt
write_snapshot -outdir $report_dir -tag final
report_summary -directory $report_dir
write_sdc >  $output_dir/$design.sdc
report_clocks > $report_dir/clocks.rpt

write_db -script $data_dir/$design.tcl -to_file $data_dir/$design.db 
time_info FINAL

set fpp [open instt w];puts $fpp "{";foreach i [get_db insts] {if {[get_db $i .base_cell.is_inverter]} {puts $fpp "\"[get_db $i .name]\":\"inverter\","} elseif {[get_db $i .base_cell.is_buffer]} {puts $fpp "\"[get_db $i .name]\":\"buffer\","} elseif {[get_db $i .base_cell.is_combinational]} {puts $fpp "\"[get_db $i .name]\":\"combinational\","} elseif {[get_db $i .base_cell.is_sequential]} {puts $fpp "\"[get_db $i .name]\":\"sequential\","}};puts $fpp "}";close $fpp;
report_timing -output_format gtd -max_paths 100000 -max_slack 0.0 > machine.rpt
python3.9 ../../customscripts/machinetiming.py machine.rpt  $csv_dir/timing


##for generation of csv file
final_individual synthesis
gui_sv_load [get_db current_design]
gui_snapshot_sv $snap_dir/schematic -overwrite
rm machine.rpt instt $design.v
exit


