#!/usr/local/bin/python3.9
import os,re,json,time,sys
print(sys.argv)
starttime=time.time()
##command to execute in innovus
#set fpp [open instt w];puts $fpp "{";foreach i [get_db insts] {if {[get_db $i .base_cell.is_inverter]} {puts $fpp "\"[get_db $i .name]\":\"inverter\","} elseif {[get_db $i .base_cell.is_buffer]} {puts $fpp "\"[get_db $i .name]\":\"buffer\","} elseif {[get_db $i .base_cell.is_combinational]} {puts $fpp "\"[get_db $i .name]\":\"combinational\","} elseif {[get_db $i .base_cell.is_sequential]} {puts $fpp "\"[get_db $i .name]\":\"sequential\","}};foreach i [get_db current_design .nets] {try {set name [get_db $i .name];set length [expr [string map {" " "+"} [get_db $i .wires.length]]];puts $fpp "\"$name\":$length,"} on error {msg} {puts $fpp "\"$name\":0,"}};puts $fpp "}";close $fpp;
#report_timing -output_format gtd
celld=json.loads(open('instt','r').read().replace(',\n}','}'))
#redirect -var congestion {report_congestion -hotspot -overflow}
#regexp -all -inline {\d+\.*\d+\s+\d+\.*\d+\s+\d+\.*\d+\s+\d+\.*\d+\s*\|\s+\d+\.*\d+} $congestion
#regexp -all -inline {\d+\.*\d*\s+\d+\.*\d*\s+\d+\.*\d*\s+\d+\.*\d*\s*} $congestion

path=os.getcwd()
paths=path.split("/")
run_number=paths[-3].split("run")
run_tag=paths[-1]
csv_file=f"{sys.argv[2]}_{run_tag}-{run_number[-1]}.csv"
kk=open(csv_file,'w')

kk.write('beginpoint,endpoint,period,libsetup,checktype,required,arrival,slack,launchclk,captureclk,skew,fanout,netdelay,netcount,instcount,invdelay,bufdelay,combodelay,seqdelay,invcount,bufcount,combocount,seqcount,portcount,load,wirelength\n')
r=open(sys.argv[1],'r').read()
paths=re.findall('PATH.*?END_PATH',r,re.S)
def p(val):return val.strip().replace('{','').replace('}','')

for i in paths:
	#print(i)
	endpoin=re.findall('ENDPT.*',i)[0].split(' ')
	endpoint=p(endpoin[1]+'/'+endpoin[2])
	beginpoin=re.findall('BEGINPT.*',i)[0].split(' ')
	beginpoint=p(beginpoin[1]+'/'+beginpoin[2])
	check_type=(re.findall('CHECK_TYPE {(.*?)}',i)[0])
	#print(beginpoint,endpoint,check_type)
	required=re.findall('{Required Time} {(.*?)}',i)[0]
	arrival=re.findall('{Arrival Time} {(.*?)}',i)[0]
	slack=re.findall('{Slack Time} {(.*)}',i)[0]
	try:libsetup=re.findall('{-} {Setup} {(.*)}',i)[0]
	except IndexError:libsetup=0#print(datapath)
	datapath=re.findall('DATA_PATH(.*)END_DATA_PATH',i,re.S)[0].strip()
	launchclkpath=re.findall('LAUNCH_CLK_PATH(.*)END_LAUNCH_CLK_PATH',i,re.S)[0].strip().split('\n')[1:]
	captureclkpath=re.findall('CAP_CLK_PATH(.*)END_CAP_CLK_PATH',i,re.S)[0].strip().split('\n')[1:]
	clkarr=re.findall('{Beginpoint Arrival Time} {(.*?)}',re.findall('ARR_CLC(.*)END_ARR_CLC',i,re.S)[0].strip())[0].strip()
	try:otherclkarr=re.findall('{Beginpoint Arrival Time} {(.*?)}',re.findall('OTHER_ARR_CLC(.*)END_OTHER_ARR_CLC',i,re.S)[0].strip())[0].strip()
	except:otherclkarr='na'
	try:launchclk=round((float(re.findall('{(.*?)}',launchclkpath[-1])[-5])-float(clkarr)),4)
	except IndexError:launchclk=clkarr
	try:captureclk=round((float(re.findall('{(.*?)}',captureclkpath[-1])[-5])-float(otherclkarr)),4)
	except IndexError:captureclk=otherclkarr
	try:skew=float(captureclk)-float(launchclk)
	except Exception as e:skew='na'
	netdelay=0.0
	portcount=0
	portdelay=0.0
	invdelay=0.0
	combodelay=0.0
	bufdelay=0.0
	seqdelay=0.0
	seqcount=0
	invcount=0
	bufcount=0
	combocount=0
	fanout=0
	fanout1=0
	instcount=0
	netcount=0
	load=0.0
	totaldelay=0.0
	wirelength=0.0
	for line in datapath.split('\n')[1:]:
		aa=re.findall('{(.*?)}',line)
		#print((aa))
		#totaldelay+=float(aa[7])
		if ' NET ' in line:
			load+=float(aa[-6])
			netdelay+=float(aa[7])
			netn=aa[5]
			wirelength+=celld[netn]
			netcount+=1
		if ((' INST ' in line)):
			instcount+=1
			fanout+=int((aa[-2]))
			inst=aa[0]
			if (celld[inst] == 'inverter'):
				invdelay+=float(aa[7])
				invcount+=1
			elif (celld[inst] == 'buffer'):
				bufdelay+=float(aa[7])
				bufcount+=1
			elif (celld[inst] == 'sequential'):
				seqdelay+=float(aa[7])
				seqcount+=1
			elif (celld[inst] == 'combinational'):
				combodelay+=float(aa[7])
				combocount+=1
		if (' PORT ' in line):
			portcount+=1
			fanout+=int(aa[-2])
	#print(round(netdelay,6))
	#print(round(combdelay,6))
	kk.write(f'{beginpoint},{endpoint},{otherclkarr},{libsetup},{check_type},{required},{arrival},{slack},{launchclk},{captureclk},{skew},{fanout},{round(netdelay,6)},{netcount},{instcount},{invdelay},{bufdelay},{combodelay},{seqdelay},{invcount},{bufcount},{combocount},{seqcount},{portcount},{load},{wirelength}\n')
	#exit()
print('seconds',time.time()-starttime)

