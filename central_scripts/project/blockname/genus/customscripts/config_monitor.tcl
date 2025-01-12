set monitored_file "../config.tcl" ;# Path to the monitored file
set baseline_file "../../customscripts/complete_config.tcl" ;# Path to the baseline file
set report_file "../../run_database/changes_in_config.tcl" ;# File to log changes

# Procedure to read and normalize a file
proc read_file {filename} {
    set file_data [list]
    if {[file exists $filename]} {
        set fp [open $filename r]
        while {[gets $fp line] >= 0} {
            # Normalize the line by trimming leading/trailing spaces and converting tabs to spaces
            set normalized_line [string trim [string map {\\n "" \\r "" \\t " "} $line]]
            if {$normalized_line ne ""} {
                lappend file_data $normalized_line
            }
        }
        close $fp
    }
    return $file_data
}

# Procedure to write changes to the report file
proc write_to_file {filename content} {
    set fp [open $filename a]
    puts $fp $content
    close $fp
}

# Procedure to get differences between the monitored and baseline files
proc get_diff {monitored baseline} {
    set monitored_lines [read_file $monitored]
    set baseline_lines [read_file $baseline]
    
    set changes {}

    # Compare each line
    for {set i 0} {$i < [llength $monitored_lines]} {incr i} {
        set monitored_line [lindex $monitored_lines $i]
        if {[llength $baseline_lines] > $i} {
            set baseline_line [lindex $baseline_lines $i]
            if {$monitored_line ne $baseline_line} {
                # Detected a difference in the current line
                lappend changes "Line $i changed:\nMonitored: $monitored_line\nBaseline: $baseline_line\n"
            }
        } else {
            lappend changes "Line $i added in monitored file: $monitored_line\n"
        }
    }
    
    # Check for lines in the baseline that are not in the monitored file (deleted lines)
    for {set i 0} {$i < [llength $baseline_lines]} {incr i} {
        if {$i >= [llength $monitored_lines]} {
            set baseline_line [lindex $baseline_lines $i]
            lappend changes "Line $i removed from monitored file: $baseline_line\n"
        }
    }

    return $changes
}

# Procedure to detect changes and log them to the report file
proc detect_changes {monitored baseline stage report_file} {
    set changes [get_diff $monitored $baseline]
    if {[llength $changes] > 0} {
        set report "Stage: $stage\nDetected changes:\n"
        foreach change $changes {
            append report "  - $change\n"
        }
        append report "---------------------------------\n"
        write_to_file $report_file $report
    } else {
        set report "Stage: $stage\nNo changes detected.\n---------------------------------\n"
        write_to_file $report_file $report
    }
}

# Main script logic
if {[info exists current_stage]} {
    puts "Checking for changes in stage: $current_stage"
    detect_changes $monitored_file $baseline_file $current_stage $report_file
} else {
    puts "Error: 'current_stage' is not defined. Please define it in the main file."
}
