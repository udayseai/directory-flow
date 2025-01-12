set current_stage route
set work_dir [pwd]
set Stage "Route"
source route_config.tcl
read_db $cts_db

set_db route_design_with_si_driven true
set_db route_design_with_timing_driven true
set_db route_design_antenna_diode_insertion true
set_db route_design_antenna_cell_name $ANTENNA_DIODE_CELL
set_db timing_enable_simultaneous_setup_hold_mode false

set_db add_fillers_cells $FILLER_CELLS
set_db add_fillers_with_drc false
set_db add_fillers_no_single_site_gap false
#########Redundant_via_Insertion_space_creation########
set_db route_design_detail_use_multi_cut_via_effort low
set_db route_design_reserve_space_for_multi_cut true
### Need to add commands to add filler if any ECO/Spare cells FILL addition required
add_fillers -base_cells $DCAP_FILLER_CELLS -prefix  DCAP_ -fill_gap -create_rows false -honor_preroute_as_obs true
#add_fillers -base_cells $DCAP_FILLER_CELLS -prefix DCAP_ -fill_gap -create_rows false -honor_preroute_as_obs true
#add_fillers -base_cells $FILLER_CELLS -prefix FILL_ -fill_gap -create_rows false -honor_preroute_as_obs true
add_fillers -base_cells $FILLER_CELLS -prefix  FILL_ -fill_gap -create_rows false -honor_preroute_as_obs true

route_design
#########Reduant_Via_Insertion####################
set_db route_design_detail_post_route_swap_via true
set_db route_design_with_timing_driven false
route_design -via_opt
########PG_CONNECTIVITY##############
#globalNetConnect VDD -type pgpin -pin VDD -override -verbose
#globalNetConnect VSS -type pgpin -pin VSS -override -verbose

#output 

write_def $output_dir/${current_step}.def
#defOut $output_dir/${current_step}.v -netlist
write_db $data_dir/route.enc
write_netlist $output_dir/${current_step}.v
## Time Reports
set_db timing_analysis_type ocv ; set_db timing_analysis_cppr both
time_design -expanded_views -post_route -report_dir $report_dir
time_design -expanded_views -post_route -hold -report_dir $report_dir
check_place > $report_dir/$current_step.check.rpt
check_design -type route -out_file $report_dir/$current_step.check_design.rpt
#report_timing -late -max_paths 10000 -nworst 100 -max_slack 0.0 > $report_dir/$current_step.report_timing.setup.rpt
#report_timing -early -max_paths 10000 -nworst 100 -max_slack 0.0 > $report_dir/$current_step.report_timing.hold.rpt

report_timing -late -max_paths 10000 -nworst 100 -max_slack 0.0 -fields {hpin cell net fanout load  delay arrival }  -split_delay -nets > $report_dir/$current_step.report_timing.setup.rpt
report_timing -early -max_paths 10000 -nworst 100 -max_slack 0.0 -fields {hpin cell net fanout load  delay arrival }  -split_delay -nets > $report_dir/$current_step.report_timing.hold.rpt

check_timing -verbose >> $report_dir/$current_step.check_timing.rpt
report_congestion -hotSpot -overflow > $report_dir/${current_step}_report_congestion.rpt
report_constraint -all_violators > $report_dir/$current_step.report_constaints.rpt
report_power > $report_dir/$current_step.report_power.rpt
report_area -out_file $report_dir/$current_step.report_area.rpt

###***  SnapShot
gui_write_flow_gifs -dir $snap_dir -prefix Route



source ./postRoute.tcl
