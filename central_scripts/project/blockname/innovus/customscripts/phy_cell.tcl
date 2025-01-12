reset_db -category add_endcaps
set_db add_endcaps_left_edge FILL2BWP16P90  ; set_db add_endcaps_right_edge FILL2BWP16P90 ; set_db add_endcaps_top_edge {FILL32BWP16P90 FILL1BWP16P90 FILL2BWP16P90} ; set_db add_endcaps_bottom_edge {FILL32BWP16P90 FILL1BWP16P90 FILL2BWP16P90} ; set_db add_endcaps_left_bottom_corner {FILL4BWP16P90} ; set_db add_endcaps_right_bottom_corner FILL4BWP16P90 ; set_db add_endcaps_left_top_corner FILL4BWP16P90 ; set_db add_endcaps_right_top_corner FILL4BWP16P90 ; set_db add_endcaps_left_top_edge {FILL2BWP16P90} ; set_db add_endcaps_right_top_edge {FILL2BWP16P90} ; set_db add_endcaps_left_bottom_edge {FILL2BWP16P90} ; set_db add_endcaps_right_bottom_edge {FILL2BWP16P90}
#addEndCap -coreBoundaryOnly -prefix ENDCAP
add_endcaps -prefix ENDCAP

set_db add_well_taps_cell FILL8BWP16P90 ; set_db add_well_taps_rule 17.5
add_well_taps -cell FILL8BWP16P90 -cell_interval 35 -prefix WELLTAP

add_decap_cell_candidates DCAP8BWP16P90 10
add_decaps -total_cap 500 -cells {DCAP8BWP16P90} -prefix DECAP
check_endcaps -out_file $report_dir/${current_step}.verifyendcap.rpt
check_well_taps -report $report_dir/${current_step}.welltap.rpt
