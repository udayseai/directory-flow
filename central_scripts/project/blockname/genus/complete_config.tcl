


##################################################################
# DESIGN RELATED CONFIG VARIABLES

## for  synthesis
set design "ibex_core"
set lib_search_path "../../../../../INPUT_LIB"
set hdl_search_path "../../../../../RTL/"
set library_list "NangateOpenCellLibrary_typical.lib fakeram45_256x16.lib fakeram45_256x64.lib "
set sdc "$work_dir/../../inputs/constraint_1.2.sdc"
set lef_file_list "../../../../../INPUT_LIB/PRTF_Innovus_N16_9M_2Xa1Xd3Xe2Z_UTRDL_9T_PODE.17_1a.tlef ../../../../../INPUT_LIB/tcbn16ffcllbwp16p90.lef"
set mmmc_file "../../inputs/create_mmmc.tcl"

## for floorplan and ...
set synthesis_netlist "../../../../../SYNTH/uday/run1/outputs/Synthesis_1/ibex_core.v"






######################################################################
#UNCERTAINITY RELATED CONFIG VARIABLES:
#uncertainity_related config
 
proc uncertainty {current_stage} {
set clk_name core_clock

# uncertainity table pattern : stage { setup_uncertainity hold_uncertainity }
set uncertainties { synthesis {0.9 0.2} place {0.15 0.15} cts {0.1 0.1} route {0.05 0.05} }
# Check if the stage is valid
if {[dict exists $uncertainties $current_stage]} {
    set values [dict get $uncertainties $current_stage]
    set setup_uncertainty [lindex $values 0]
    set hold_uncertainty [lindex $values 1]

    catch {
        set_clock_uncertainty -setup $setup_uncertainty [get_clocks $clk_name]
        set_clock_uncertainty -hold $hold_uncertainty [get_clocks $clk_name]
        puts "Clock uncertainty successfully applied for stage: $current_stage"
    } errMsg

    if {[info exists errMsg]} {
        puts "Error: $errMsg"
    }
} else {
    puts "Error: Invalid stage: $cuurent_stage. This script is only for the Synthesis, Place, CTS, or Route stages."
}
}
 


##################################################################
#STAGE RELATED CONFIG VARIABLES:
switch  $current_stage {

	synthesis {
		set work_dir [pwd]
		set Stage "Synthesis"
		set hdl_file_list "[glob -d $hdl_search_path *.v *.sv]"
		#congestion_effort to be set to "low" or "medium" or "high" or "auto"
		set congestion_effort "high"
		#variable to control synthesis mode (set to "flat" or "heirarchial"):
		set mode "flat"
		set path_group "../../inputs/path_group.tcl"
		set dont_use_cells ""
		set dont_touch_cells ""
		set qrc_tech_file ""

		#insertion of clock_gating cells (true or false)
		set clock_gating_insertion true
		#multibit cells  merging (true or false)
		set multi_bit_cells_merging true
		## to avoid high drive strength buffer cells in synthesis pattern example : set buffer_cell_pattern {base_cell:(.+_X([1-9][0-9]))}
		set buffer_cell_pattern {}

		## don't change any variables here :
		set paths [pwd]
		set path_components [split $paths "/"]
		set level [lindex $path_components end]

		set output_dir $work_dir/../../outputs/$level
		set report_dir $work_dir/../../reports/$level
		set csv_dir $work_dir/../../reports/$level/csv/ 
		set snap_dir   $work_dir/../../snapshots/$level
		set data_dir $work_dir/../../data/$level
		set logs_dir  $work_dir/../../logs/$level
	}

	floorplan {
		set work_dir [pwd]
		set physical_cells "../../customscripts/phy_cell.tcl"
		#specify this aspect_ratio and utilization (or) core_boundaries (or) fp_partition_def
		#aspect ratio and utilization
		set aspect_ratio 1.0
		set utilization 0.6
		set left 6
		set bottom 6
		set right 6
		set top 6

		#core io boundaries
		#set fp_x 86.904
		#set fp_y 86.400
		#set io_boundary 4.05
		set fp_partition_def ""
		set scan_def ""
		set maximum_routing_metal_layer ""
		set switching_activity_file ""
		set SOCV_MODE "true"
		set current_step $design.fp
		#rw -> ring width
		#rs -> ring spacing
		#ro -> ring offset
		#mw -> metal width
		#ms -> metal spacing
		#sts -> set to set distance
		##### Ring creation 
		set rw 1.08
		set rs 0.36
		set ro 0.72
		set sts 8


		### Stripes creation
		set mw9 1.44
		set ms9 0.7
		 

		set mw8 1.44
		set ms8 0.7

		set mw7 1.2
		set ms7 0.42

		set mw6 1.2
		set ms6 0.42

		set mw5 1.2
		set ms5 0.42

		set mw2 0.8
		set ms2 0.8
		set diebox [get_db designs .core_bbox]

		## don't change any variables here :
		set paths [pwd]
		set path_components [split $paths "/"]
		set level [lindex $path_components end]

		set output_dir $work_dir/../../outputs/$level
		set report_dir $work_dir/../../reports/$level
		set csv_dir $work_dir/../../reports/$level/csv/ 
		set snap_dir   $work_dir/../../snapshots/$level
		set data_dir $work_dir/../../data/$level
		set logs_dir  $work_dir/../../logs/$level
	}

	place {
		set work_dir [pwd]
		set fp_db "../../data/Floorplan_<RUN_TAG>/fp.enc"
		# Setting global congestion effort "high or low or medium"
		set global_cong_effort "high"
		#setting congestion effort "high or low or medium"
		set congestion_effort "high" 
		#Enabling Density Switch
		set maxDensity 0.5
		#Enabling early clock flow "true" or "false"
		set earlyClockFlow true
		#Enabling DRV fixing "true or false"
		set fix_cap true
		set fix_tran true
		set fix_fanout_load true
		# Setting global_congestion effort "high or low or medium"
		set global_cong_effort "high"
		# Setting timing effort to "low" or "medium" or "high" 
		set timing_effort "high"
		# Setting IR drop aware effort "High or low"
		set irdrop_effort "high"

		#Setting Tie Hi/Lo Mode 
		set max_fanout 10
		set max_distance 20
		set tie_cells "LOGIC0_X1 LOGIC1_X1" 
		set keep_existing true
		set prefix_tielo "LITLO"
		set prefix_tiehi "LIHI"
		set cell_tielo "LOGIC0_X1"
		set cell_tiehi "LOGIC1_X1 "
		set create_hier_port true 
		set current_step $design.place
		 

		### don't change any variables here :
		set paths [pwd]
		set path_components [split $paths "/"]
		set level [lindex $path_components end]

		set output_dir $work_dir/../../outputs/$level
		set report_dir $work_dir/../../reports/$level
		set csv_dir $work_dir/../../reports/$level/csv/ 
		set snap_dir   $work_dir/../../snapshots/$level
		set data_dir $work_dir/../../data/$level
		set logs_dir  $work_dir/../../logs/$level
	}

	cts {
		set work_dir [pwd]
		set place_db "../../data/Place_<RUN_TAG>/place.enc"
		#####AOCV_MODE_CAN_BE_NONE/PATH_BASED/GRAPH_BASED#########
		set AOCV_MODE "path_based"
		set route_rule1 2W2S
		set rr1_spacing "metal7:metal6 0.06"
		set rr1_width "metal7:metal6 0.04"
		set rr1_top_layer metal7
		set rr1_bottom_layer metal6
		set route_rule2 2W1S
		set rr2_width "metal5:metal4 0.04"
		set rr2_top_layer metal5
		set rr2_bottom_layer metal4
		set max_transition 0.2
		set max_capacitance 0.2
		set max_length 180
		set max_fanout 32
		set leakage_to_dynamic_ratio 0.5
		set CTS_BUFFERS {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3 BUF_X32 BUF_X16 BUF_X8 BUF_X4 BUF_X2 BUF_X1}
		set CTS_INVERTERS {INV_X1 INV_X2 INV_X4 INV_X8 INV_X16 INV_X32 TINV_X1}
		set CTS_CLOCK_GATING_CELLS {CLKGATE_X1	CLKGATE_X2 CLKGATE_X4 CLKGATE_X8 CLKGATETST_X1 CLKGATETST_X2 CLKGATETST_X4 CLKGATETST_X8}

		#set HOLD_CELLS {DCCKBD10BWP16P90 DCCKBD12BWP16P90 DCCKBD14BWP16P90 DCCKBD16BWP16P90 DCCKBD18BWP16P90 DCCKBD20BWP16P90 DCCKBD24BWP16P90 DCCKBD4BWP16P90 DCCKBD5BWP16P90 DCCKBD6BWP16P90 DCCKBD8BWP16P90}
		set ckg_list "CLKGATE_X1 CLKGATE_X2 CLKGATE_X4 CLKGATE_X8 CLKGATETST_X1 CLKGATETST_X2 CLKGATETST_X4 CLKGATETST_X8"

		set CTS_USEFULL_SKEW ""
		set CTS_POWER_EFFORT "high"
		set trunk_cell CKBD18BWP16P90
		set final_cell CKBD14BWP16P90
		set sink_grid "3 3"
		set sink_area "15 15"
		set sink_grid_box "5 5 101 99"
		set max_cloned_fraction 0.5
		set hold_target_slack 0.005
		set setup_target_slack 0
		set limit 1000000
		set max_paths 10000
		set nworst 100
		set max_slack 0.0
		set current_step $design.cts
		 

		### don't change any variables here :
		set paths [pwd]
		set path_components [split $pa
		### don't change any variables here :
		set paths [pwd]
		set path_components [split $paths "/"]
		set level [lindex $path_components end]

		set output_dir $work_dir/../../outputs/$level
		set report_dir $work_dir/../../reports/$level
		set csv_dir $work_dir/../../reports/$level/csv/ 
		set snap_dir   $work_dir/../../snapshots/$level
		set data_dir $work_dir/../../data/$level
		set logs_dir  $work_dir/../../logs/$level
	}
	route {

		set work_dir [pwd]
		set cts_db "$work_dir/../../data/CTS_<run_tag>/cts_hold.enc"
		set FILLER_CELLS {FILL16BWP16P90 FILL1BWP16P90 FILL2BWP16P90 FILL32BWP16P90 FILL3BWP16P90 FILL4BWP16P90 FILL64BWP16P90 FILL8BWP16P90}
		set DCAP_FILLER_CELLS {DCAP16BWP16P90 DCAP32BWP16P90 DCAP4BWP16P90 DCAP64BWP16P90 DCAP8BWP16P90}
		set ANTENNA_DIODE_CELL {ANTENNABWP16P90}
		set current_step $design.route


		### don't change any variables here :
		set paths [pwd]
		set path_components [split $paths "/"]
		set level [lindex $path_components end]

		set output_dir $work_dir/../../outputs/$level
		set report_dir $work_dir/../../reports/$level
		set csv_dir $work_dir/../../reports/$level/csv/ 
		set snap_dir   $work_dir/../../snapshots/$level
		set data_dir $work_dir/../../data/$level
		set logs_dir  $work_dir/../../logs/$level

	}

    default {
        	puts "Unknown stage: $current_stage"
	}
	
}

# to store changes variables
#source ../../customscripts/config_monitor.tcl
