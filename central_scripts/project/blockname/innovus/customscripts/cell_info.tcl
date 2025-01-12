set a [get_db insts]
# result_format==  cell_name :[ cell_count , cell_area , total_area of cell in design]

set results [dict create]
foreach i $a {
    set cell_name [get_db $i .base_cell.name]
    set cell_area [get_db $i .base_cell.area]
    if {[dict exists $results $cell_name]} {
        set count [lindex [dict get $results $cell_name] 0]
        dict set results $cell_name [list [expr {$count + 1}] [lindex [dict get $results $cell_name] 1] [expr {[lindex [dict get $results $cell_name] 2] + $cell_area}]]
    } else {
        dict set results $cell_name [list 1 $cell_area $cell_area]
    }
}


####### convertion into csv #######

set csv_lines [list]
lappend csv_lines "cell_name,cell_count,cell_area,cell_total_area"
foreach cell_name [dict keys $results] {
    set values [dict get $results $cell_name]
    set cell_count [lindex $values 0]
    set cell_area [lindex $values 1]
    set total_area [lindex $values 2]   
    set csv_line [format "%s,%d,%f,%f" $cell_name $cell_count $cell_area $total_area]
    lappend csv_lines $csv_line
}
set csv_output [join $csv_lines "\n"]

######## output_file name
set paths [pwd]
set path_components [split $paths "/"]
set run [lindex [split [lindex $path_components end-2] "run"] end]  
set runtag [lindex [split [lindex  $path_components end] "_"] end] 
set level [lindex $path_components end]

set output_file "$csv_dir/cell_info\_{$run}-{$runtag}.csv"         
set file_id [open $output_file "w"]
puts $file_id $csv_output
close $file_id
puts "CSV file created: $output_file"



