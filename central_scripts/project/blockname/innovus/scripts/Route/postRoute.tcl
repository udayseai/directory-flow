set_multi_cpu_usage -local_cpu 16 
set_interactive_constraint_modes {func}

delete_filler
opt_design -post_route -setup -hold -report_dir $report_dir/route_opt/timingReports/
add_fillers -base_cells $FILLER_CELLS -prefix  FILL_ -fill_gap -create_rows false -honor_preroute_as_obs true

write_def $output_dir/${current_step}_opt.def
#defOut $outputs_opt/${current_step_opt}.v -netlist
write_db $data_dir/route_opt.enc
write_netlist $output_dir/${current_step}_opt.v
## Time Reports
time_design -expanded_views -post_route -report_dir $report_dir/route_opt
time_design -expanded_views -post_route -hold -report_dir $report_dir/route_opt
check_place > $report_dir/${current_step}_opt.check.rpt
check_design -type route -out_file $report_dir/route_opt/${current_step}.check_design.rpt
#report_timing -late -max_paths 10000 -nworst 100 -max_slack 0.0 > $report_dir/route_opt/$current_step_opt.report_timing.setup.rpt
#report_timing -early -max_paths 10000 -nworst 100 -max_slack 0.0 > $report_dir/route_opt/$current_step_opt.report_timing.hold.rpt

report_timing -late -max_paths 10000 -nworst 100 -max_slack 0.0 -fields {hpin cell net fanout load  delay arrival }  -split_delay -nets > $report_dir/route_opt/$current_step.report_timing.rpt
report_timing -early -max_paths 10000 -nworst 100 -max_slack 0.0 -fields {hpin cell net fanout load  delay arrival }  -split_delay -nets > $report_dir/route_opt/$current_step.report_timing.hold.rpt



check_timing -verbose >> $report_dir/route_opt/${current_step}.check_timing.rpt
report_congestion -hotSpot -overflow > $report_dir/route_opt/${current_step}_report_congestion.rpt
report_constraint -all_violators > $report_dir/route_opt/$current_step.report_constaints.rpt
report_power > $report_dir/route_opt/$current_step.report_power.rpt
# MANUALLY TRANSLATE (ERROR-1): Command 'report_area' has no common UI definition and is removed, contact Cadence for support. 
# report_area -out_file $report_dir/route_opt/$current_step_opt.report_area.rpt
check_drc -limit 1000000 -out_file $report_dir/route_opt/drc.rpt
report_summary -out_dir $report_dir/route_opt/design_summary
extract_rc
write_parasitics -spef_file $output_dir/rcworst_CCworst.spef.gz -rc_corner rcworst_CCworst
write_parasitics -spef_file $output_dir/rcbest.spef.gz -rc_corner rcbest

#source $work_dir/../customscripts/reports_procs.tcl
#source $work_dir/../customscripts/qor_script.tcl
#source $work_dir/../customscripts/report_script.tcl
#source $work_dir/../customscripts/reports_qor.tcl

###***  SnapShot
gui_write_flow_gifs -dir $snap_dirs -prefix Route_opt
source ../../customscripts/generate_csv.tcl

exit
