read library -Liberty <lib_file path>
read design "<synthesis_netlist_path>" -verilog -golden
read design "<cts_netlist_path>" -verilog -revised
set system mode lec
add compare point -all
compare -threads 4,4
report verification > lec_cts_verify.rpt
exit
