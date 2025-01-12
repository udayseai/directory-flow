##example paths == "/nas/nas_v1/Innovus_trials/users/udaykiran/directory_structure/arm/1.0/ibex/SYNTH/uday/run1/scripts/Synthesis_1"

set paths [pwd]
set path_components [split $paths "/"]
set run [lindex [split [lindex $path_components end-2] "run"] end]  
set runtag [lindex [split [lindex  $path_components end] "_"] end] 
set level [lindex $path_components end]


set area [open $csv_dir/area\_$level-$run.csv w]
set power [open $csv_dir/power\_$level-$run.csv w]
set density [open $csv_dir/density\_$level-$run.csv w]
set qor [open $csv_dir/qor\_$level-$run.csv w]
set drv [open $csv_dir/drv\_$level-$run.csv w]
set run_time [open $csv_dir/runtime\_$level-$run.csv w]
set congestion [open $csv_dir/overflow\_$level-$run.csv w]




###############################################################################
set buffers [get_db insts -if {.is_buffer==true}] 
set icgs [get_db insts -if {.is_integrated_clock_gating==true}] 
set combo [get_db insts -if {.is_combinational==true && .is_inverter==false && .is_buffer==false}]
set inv [get_db insts -if {.is_inverter==true}] 
set macro [get_db insts -if {.is_macro==true}] 
set physical [get_db insts -if {.is_physical==true}] 
set sequential [get_db insts -if {.is_sequential==true}] 
set latch [get_db insts -if {.is_latch==true}] 

puts $area "Buffer count,[llength $buffers]"
puts $area "icgs count,[llength $icgs]"
puts $area "combinational count,[llength $combo]"
puts $area "inverter count,[llength $inv]"
puts $area "macro count,[llength $macro]"
puts $area "physical count,[llength $physical]"
puts $area "sequential count,[llength $sequential]"
puts $area "latch count,[llength $latch]"
puts $area "insts count,[llength [get_db insts]]"

try {puts $area "macro area,[expr [join [get_db $macro .area ] + ]]"} on error {msg} {puts $area "macroarea,0"}
try {puts $area "buffer area,[expr [join [get_db $buffers .area ] + ]]"} on error {msg} {puts $area "buffer area,0"}
try {puts $area "inverter area,[expr [join [get_db $inv .area ] + ]]"} on error {msg} {puts $area "inverter area,0"}
try {puts $area "combinational area,[expr [join [get_db $combo .area ] + ]]"} on error {msg} {puts $area "combinational area,0"}
try {puts $area "icgs area,[expr [join [get_db $icgs .area ] + ]]"} on error {msg} {puts $area "icgs area,0"}
try {puts $area "sequential area,[expr [join [get_db $sequential .area ] + ]]"} on error {msg} {puts $area "sequential area,0"}
try {puts $area "Total area,[expr [join [get_db insts .area ] + ]]"} on error {msg} {puts $area "Total area,0"}
close $area


set power_dynamic [expr [join [get_db insts .power_dynamic ] + ]]
set power_internal [expr [join [get_db insts .power_internal ] + ]]
set power_leakage [expr [join [get_db insts .power_leakage ] + ]]
set power_switching [expr [join [get_db insts .power_switching ] + ]]
set power_total [expr [join [get_db insts .power_total ] + ]]
puts $power "dynamic power,$power_dynamic"
puts $power "internal power,$power_internal"
puts $power "leakage power,$power_leakage"
puts $power "switching power,$power_switching"
puts $power "total power,$power_total"
close $power


puts $density "density,[lindex [get_metric design.density] end]"
close $density

puts $qor "[join [split [get_metric timing.hold.wns] ] ,]"
puts $qor "[join [split [get_metric timing.hold.tns] ] ,]"
puts $qor "[join [split [get_metric timing.hold.feps] ] ,]"
puts $qor "[join [split [get_metric timing.setup.wns] ] ,]"
puts $qor "[join [split [get_metric timing.setup.tns] ] ,]"
puts $qor "[join [split [get_metric timing.setup.feps] ] ,]"
close $qor


foreach {i j} [get_metric timing.drv*] {puts $drv "$i,$j"}
close $drv

puts $run_time "[join [split [get_metric flow.cputime]] ,]"
puts $run_time "[join [split [get_metric flow.realtime]] ,]"
puts $run_time "[join [split [get_metric flow.memory]] ,]"
puts $run_time "[join [split [get_metric flow.realtime.total]] ,]"
puts $run_time "[join [split [get_metric flow.cputime.total]] ,]"
close $run_time


report_congestion -overflow > &congestionn
regexp  (Overflow.*?)\n $congestionn match cong
if [info exists cong] {
	puts $congestion $cong
} else {
puts $congestion 0
}
close $congestion

