

set_db add_rings_target default ; set_db add_rings_extend_over_row 0 ; set_db add_rings_ignore_rows 0 ; set_db add_rings_avoid_short 0 ; set_db add_rings_skip_shared_inner_ring none ; set_db add_rings_stacked_via_top_layer AP ; set_db add_rings_stacked_via_bottom_layer M8 ; set_db add_rings_via_using_exact_crossover_size 1 ; set_db add_rings_orthogonal_only true ; set_db add_rings_skip_via_on_pin {  standardcell } ; set_db add_rings_skip_via_on_wire_shape {  noshape }

#add_rings -nets {VDD VSS} -type core_rings -follow core -layer {top M9 bottom M9 left M8 right M8} -width "{{top $rw bottom $rw left $rw right $rw}}" -spacing "{{top $rs bottom $rs left $rs right $rs}}" -offset "{{top $ro bottom $ro left $ro right $ro}}" -center 1 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid grid

add_rings -nets {VDD VSS} -type core_rings -follow core -layer {top M9 bottom M9 left M8 right M8} -width [list top $rw bottom $rw left $rw right $rw] -spacing [list top $rs bottom $rs left $rs right $rs] -offset [list top $ro bottom $ro left $ro right $ro] -center 1 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid grid

### Stripe Creation 

##Layer M9
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area false ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape none ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer M9 ; set_db add_stripes_stacked_via_bottom_layer M8 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape { noshape }

add_stripes -nets {VDD VSS} -layer M9 -direction horizontal -width $mw9 -spacing $ms9 -set_to_set_distance $sts -area $diebox  -start_from bottom -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit M9 -pad_core_ring_bottom_layer_limit M8 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid grid

##Layer M8
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area false ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape none ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer M9 ; set_db add_stripes_stacked_via_bottom_layer M7 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape { noshape }

add_stripes -nets {VDD VSS} -layer M8 -direction vertical -width $mw8 -spacing $ms8 -set_to_set_distance $sts -area $diebox -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit M9 -pad_core_ring_bottom_layer_limit M8 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid grid


##Layer M7
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area false ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape none ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer M8 ; set_db add_stripes_stacked_via_bottom_layer M7 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  ring  noshape   }

add_stripes -nets {VDD VSS} -layer M7 -direction horizontal -width $mw7 -spacing $ms7 -set_to_set_distance $sts -area $diebox -start_from bottom -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit M1 -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid grid

###Layer M6
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area false ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape none ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer M7 ; set_db add_stripes_stacked_via_bottom_layer M5 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  ring  noshape }
add_stripes -nets {VDD VSS} -layer M6 -direction vertical -width $mw6 -spacing $ms6 -set_to_set_distance $sts -area $diebox -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit M1 -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid grid
###Layer M5
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area false ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape none ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer M6 ; set_db add_stripes_stacked_via_bottom_layer M2 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  ring  noshape   }
add_stripes -nets {VSS VDD} -layer M5 -direction horizontal -width $mw5 -spacing $ms5 -set_to_set_distance $sts -area $diebox -start_from bottom -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid grid

###Layer M2
set_db add_stripes_ignore_block_check false ; set_db add_stripes_break_at none ; set_db add_stripes_route_over_rows_only false ; set_db add_stripes_rows_without_stripes_only false ; set_db add_stripes_extend_to_closest_target none ; set_db add_stripes_stop_at_last_wire_for_area false ; set_db add_stripes_partial_set_through_domain false ; set_db add_stripes_ignore_non_default_domains false ; set_db add_stripes_trim_antenna_back_to_shape none ; set_db add_stripes_spacing_type edge_to_edge ; set_db add_stripes_spacing_from_block 0 ; set_db add_stripes_stripe_min_length stripe_width ; set_db add_stripes_stacked_via_top_layer M5 ; set_db add_stripes_stacked_via_bottom_layer M1 ; set_db add_stripes_via_using_exact_crossover_size false ; set_db add_stripes_split_vias false ; set_db add_stripes_orthogonal_only true ; set_db add_stripes_allow_jog { padcore_ring  block_ring } ; set_db add_stripes_skip_via_on_pin {  standardcell } ; set_db add_stripes_skip_via_on_wire_shape {  ring       noshape   }
add_stripes -nets {VSS VDD} -layer M2 -direction vertical -width $mw2 -spacing $ms2 -set_to_set_distance $sts -area $diebox -start_from left -switch_layer_over_obs false -max_same_layer_jog_length 2 -pad_core_ring_top_layer_limit AP -pad_core_ring_bottom_layer_limit M1 -block_ring_top_layer_limit AP -block_ring_bottom_layer_limit M1 -use_wire_group 0 -snap_wire_center_to_grid grid

###Sroute to create Std rail
set_db route_special_via_connect_to_shape { stripe }
route_special -connect {block_pin pad_pin pad_ring core_pin floating_stripe} -layer_change_range { M1(1) M2(2) } -block_pin_target {nearest_target} -pad_pin_port_connect {all_port one_geom} -pad_pin_target {nearest_target} -core_pin_target {first_after_row_end} -floating_stripe_target {block_ring pad_ring ring stripe ring_pin block_pin followpin} -allow_jogging 1 -crossover_via_layer_range { M1(1) M2(2) } -nets { VDD VSS } -allow_layer_change 1 -block_pin use_lef -target_via_layer_range { M1(1) M2(2) }


