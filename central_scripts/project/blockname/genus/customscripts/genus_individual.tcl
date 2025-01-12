proc stage_individual {name} {
set commands { "report_gates" "report_timing_summary" }
foreach i $commands {
[redirect abc "$i"]
set paths [pwd]
set path_components [split $paths "/"]
set run [lindex [split [lindex $path_components end-2] "run"] end]  
set runtag [lindex [split [lindex  $path_components end] "_"] end] 
set level [lindex $path_components end]
generatecsv "../../reports/$level/csv/$name\_$i\_$level\-$run.csv" $i
rm abc}
}

proc final_individual {name} {
set commands {"check_design" "check_timing_intent" "report_power" "report_clocks" "report_messages -all -error -warning" "report_runtime" }
foreach i $commands { 

set paths [pwd]
set path_components [split $paths "/"]
set run [lindex [split [lindex $path_components end-2] "run"] end]  
set runtag [lindex [split [lindex  $path_components end] "_"] end]
set level [lindex $path_components end]
[redirect abc "$i" ]
generatecsv "../../reports/$level/csv/[lindex $i 0]\_$level\-$run.csv" [lindex $i 0]
rm abc}
}


proc generatecsv {name command} { [python3.9 ../../customscripts/synth_individual_stage.py $name $command]}


