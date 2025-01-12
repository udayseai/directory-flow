read library -Liberty <lib_file path>
read design "<synthesis_netlist_path>" -verilog -golden
read design "<route_netlist_path>" -verilog -revised
set system mode lec
add compare point -all
compare -threads 4,4
report verification > lec_route_verify.rpt
exit
