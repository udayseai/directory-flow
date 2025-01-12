set_multi_cpu_usage -local_cpu 16 
set_interactive_constraint_modes {func}

delete_filler
opt_design -post_route -setup -hold -report_dir $report_dir/route_opt_timingReports
add_fillers -base_cells $FILLER_CELLS -prefix  FILL_ -fill_gap -create_rows false -honor_preroute_as_obs true

write_def $output_dir/${current_step}_opt.def
#defOut $output_dir/${current_step_opt}.v -netlist
write_db $data_dir/route_opt.enc
write_netlist $output_dir/${current_step}_opt.v
## Time Reports
time_design -expanded_views -post_route -report_dir $report_dir/route_opt
time_design -expanded_views -post_route -hold -report_dir $report_dir/route_opt
check_place > $report_dir/${current_step}_opt.check.rpt
check_design -type route -out_file $report_dir/${current_step}_opt.check_design.rpt

report_timing -max_paths 1000000 -max_slack 0.0 -output_format gtd -late > setup.rpt
report_timing -max_paths 1000000 -max_slack 0.0 -output_format gtd -early > hold.rpt
set fpp [open instt w];puts $fpp "{";foreach i [get_db insts] {if {[get_db $i .base_cell.is_inverter]} {puts $fpp "\"[get_db $i .name]\":\"inverter\","} elseif {[get_db $i .base_cell.is_buffer]} {puts $fpp "\"[get_db $i .name]\":\"buffer\","} elseif {[get_db $i .base_cell.is_combinational]} {puts $fpp "\"[get_db $i .name]\":\"combinational\","} elseif {[get_db $i .base_cell.is_sequential]} {puts $fpp "\"[get_db $i .name]\":\"sequential\","}};foreach i [get_db current_design .nets] {try {set name [get_db $i .name];set length [expr [string map {" " "+"} [get_db $i .wires.length]]];puts $fpp "\"$name\":$length,"} on error {msg} {puts $fpp "\"$name\":0,"}};puts $fpp "}";close $fpp;
python3.9 ../../customscripts/machinetiming.py setup.rpt  $csv_dir/setuptiming_opt
python3.9 ../../customscripts/machinetiming.py hold.rpt  $csv_dir/holdtiming_opt


check_timing -verbose >> $report_dir/${current_step}_opt.check_timing.rpt
report_congestion -hotSpot -overflow > $report_dir/${current_step}_opt_report_congestion.rpt
report_constraint -all_violators > $report_dir/route_opt/${current_step}_opt_report_constaints.rpt
report_power > $report_dir/${current_step}_opt_report_power.rpt
check_drc -limit 1000000 -out_file $report_dir/${current_step}_opt_drc.rpt
report_summary -out_dir $report_dir/${current_step}_opt_design_summary
extract_rc
write_parasitics -spef_file $output_dir/rcworst_CCworst.spef.gz -rc_corner rcworst_CCworst
write_parasitics -spef_file $output_dir/rcbest.spef.gz -rc_corner rcbest


###***  SnapShot
gui_write_flow_gifs -dir $snap_dirs -prefix Route_opt
source ../../customscripts/generate_csv.tcl

exit
