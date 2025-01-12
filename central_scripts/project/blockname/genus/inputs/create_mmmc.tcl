
####################
# MMMMC Creation
####################

##### Library set Creation
set ss1_library_file "/nas/nas_v1/PDK/tsmc_downloads/tcbn16ffcllbwp16p90_100b/tcbn16ffcllbwp16p90_100a_ccs/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn16ffcllbwp16p90_100a/tcbn16ffcllbwp16p90ssgnp0p675v125c_ccs.lib"
set ss2_library_file "/nas/nas_v1/PDK/tsmc_downloads/tcbn16ffcllbwp16p90_100b/tcbn16ffcllbwp16p90_100a_ccs/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn16ffcllbwp16p90_100a/tcbn16ffcllbwp16p90ssgnp0p675vm40c_ccs.lib"

set ff1_library_file "/nas/nas_v1/PDK/tsmc_downloads/tcbn16ffcllbwp16p90_100b/tcbn16ffcllbwp16p90_100a_ccs/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn16ffcllbwp16p90_100a/tcbn16ffcllbwp16p90ffgnp0p825v125c_ccs.lib"
set ff2_library_file "/nas/nas_v1/PDK/tsmc_downloads/tcbn16ffcllbwp16p90_100b/tcbn16ffcllbwp16p90_100a_ccs/TSMCHOME/digital/Front_End/timing_power_noise/CCS/tcbn16ffcllbwp16p90_100a/tcbn16ffcllbwp16p90ffgnp0p825vm40c_ccs.lib"

set ss1_corner "rcworst_CCworst"
set ss2_corner "cworst_CCworst" 
set ff1_corner "rcbest_CCbest"
set ff2_corner "cbest_CCbest"

set rc_worst_qrc_tech_file_path "/nas/nas_v1/PDK/tsmc_downloads/24012024/rcworst/Tech/rcworst_CCworst/qrcTechFile"
set cc_worst_qrc_tech_file_path "/nas/nas_v1/PDK/tsmc_downloads/24012024/cworst/Tech/cworst_CCworst/qrcTechFile"
set rc_best_qrc_tech_file_path "/nas/nas_v1/PDK/tsmc_downloads/24012024/rcbest/Tech/rcbest_CCbest/qrcTechFile"
set cc_best_qrc_tech_file_path "/nas/nas_v1/PDK/tsmc_downloads/24012024/cbest/Tech/cbest_CCbest/qrcTechFile"

create_library_set -name ls_ss1_125 -timing $ss1_library_file
create_library_set -name ls_ss2_m40 -timing $ss2_library_file
create_library_set -name ls_ff1_125 -timing $ff1_library_file
create_library_set -name ls_ff2_m40 -timing $ff2_library_file

##### Create Timing Condition

#create_timing_condition -name tc_${corner} -library_set ls_${corner} -opcond <> -opcond_library <>

##### RC corner Creation
create_rc_corner -name ss1_rc_corner -qrc_tech $rc_worst_qrc_tech_file_path -temperature 125
create_rc_corner -name ss2_rc_corner -qrc_tech $cc_worst_qrc_tech_file_path -temperature 125
create_rc_corner -name ss3_rc_corner -qrc_tech $rc_worst_qrc_tech_file_path -temperature -40
create_rc_corner -name ss4_rc_corner -qrc_tech $cc_worst_qrc_tech_file_path -temperature -40
create_rc_corner -name ff1_rc_corner -qrc_tech $rc_best_qrc_tech_file_path -temperature 125
create_rc_corner -name ff2_rc_corner -qrc_tech $cc_best_qrc_tech_file_path -temperature 125
create_rc_corner -name ff3_rc_corner -qrc_tech $rc_best_qrc_tech_file_path -temperature -40
create_rc_corner -name ff4_rc_corner -qrc_tech $cc_best_qrc_tech_file_path -temperature -40

####Timing Library Creation

create_timing_condition -name tc_ss1_125 -library_sets ls_ss1_125 
create_timing_condition -name tc_ss2_m40 -library_sets ls_ss2_m40 
create_timing_condition -name tc_ff1_125 -library_sets ls_ff1_125 
create_timing_condition -name tc_ff2_m40 -library_sets ls_ff2_m40 

##### Delay Corner Creation

create_delay_corner -name dc_ss1_corner -timing_condition tc_ss1_125 -rc_corner ss1_rc_corner
create_delay_corner -name dc_ss2_corner -timing_condition tc_ss1_125 -rc_corner ss2_rc_corner
create_delay_corner -name dc_ss3_corner -timing_condition tc_ss2_m40 -rc_corner ss3_rc_corner
create_delay_corner -name dc_ss4_corner -timing_condition tc_ss2_m40 -rc_corner ss4_rc_corner
create_delay_corner -name dc_ff1_corner -timing_condition tc_ff1_125 -rc_corner ff1_rc_corner
create_delay_corner -name dc_ff2_corner -timing_condition tc_ff1_125 -rc_corner ff2_rc_corner
create_delay_corner -name dc_ff3_corner -timing_condition tc_ff2_m40 -rc_corner ff3_rc_corner
create_delay_corner -name dc_ff4_corner -timing_condition tc_ff2_m40 -rc_corner ff4_rc_corner

##### Constraint mode Creation 
set sdc_file "../inputs/constraint.sdc"
create_constraint_mode -name func -sdc_files $sdc_file

##### Analysis view Creation 

create_analysis_view -name func_ss0p675v125c_$ss1_corner -delay_corner dc_ss1_corner -constraint_mode func
create_analysis_view -name func_ss0p675v125c_$ss2_corner -delay_corner dc_ss2_corner -constraint_mode func
create_analysis_view -name func_ss0p675vm40c_$ss1_corner -delay_corner dc_ss3_corner -constraint_mode func
create_analysis_view -name func_ss0p675vm40c_$ss2_corner -delay_corner dc_ss4_corner -constraint_mode func
create_analysis_view -name func_ff0p825v125c_$ff1_corner -delay_corner dc_ff1_corner -constraint_mode func
create_analysis_view -name func_ff0p825v125c_$ff2_corner -delay_corner dc_ff2_corner -constraint_mode func
create_analysis_view -name func_ff0p825vm40c_$ff1_corner -delay_corner dc_ff3_corner -constraint_mode func
create_analysis_view -name func_ff0p825vm40c_$ff2_corner -delay_corner dc_ff4_corner -constraint_mode func

##### setting active analysis views 

set_analysis_view -setup {func_ss0p675v125c_rcworst_CCworst  func_ss0p675vm40c_rcworst_CCworst} -hold {func_ff0p825v125c_rcbest_CCbest func_ff0p825vm40c_rcbest_CCbest}


