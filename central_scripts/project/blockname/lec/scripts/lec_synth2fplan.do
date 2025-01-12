read library -Liberty <lib_file path>
read design "<synthesis_netlist path>" -verilog -golden
read design "<fplan_netlist path>" -verilog -revised
set system mode lec
add compare point -all
compare -threads 4,4
report verification > lec_fplan_verify.rpt
exit
