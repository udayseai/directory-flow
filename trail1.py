
import os
import shutil
mode = 0o777
def create_central_directory_structure(name, project, blocks, tools, sub_plug, stages):	
	try:
		for proj in project:
			for blk in blocks:
				for tool in tools:
					for plug in sub_plug:
						if plug == "scripts" and tool == "innovus":
							for stage in stages:
								os.makedirs(os.path.join(name, proj, blk, tool, plug, stage), mode=mode, exist_ok=True)
						elif tool in ["genus", "lec","tempus","innovus"]:
							os.makedirs(os.path.join(name, proj, blk, tool, plug), mode=mode, exist_ok=True)
						else:
							os.makedirs(os.path.join(name, proj, blk, tool), mode=mode, exist_ok=True)
	except FileExistsError:
		pass
	except Exception as e:
		print(e)

def get_user_input():
	pname = str.strip(input("Enter the name of your project: "))
	block_name = str.strip(input("Enter the name of your block : "))
	user_name = input("Enter the user name: ")
	stage_in_flow = input("Enter the stage in flow (ex: all, synthesis, PNR , LEC , STA ): ")
	return pname,block_name ,user_name, stage_in_flow

def handle_synthesis():
	run = input("Enter the run (ex: run1, run2...): ")
	run_tag = input("Enter the run tag name: ")
	return run, run_tag

def handle_pnr():
	run = input("Enter the run (ex: run1, run2...): ")
	sta = input("Enter the stages of run (ex: all, individual, or from any stage to stage): ")	
	stages = []
	valid_stages = ["Floorplan", "Place", "CTS", "Route"]
	if sta == "all":	
		run_tag = input("Enter the run tag name: ")
		stages = [f'{stage}_{run_tag}' for stage in valid_stages]
	
	elif sta == "individual":
		individual_stages = input("Enter individual stages separated by spaces (ex: Floorplan Place CTS Route): ")
		run_tag = input("Enter the run tag name: ")
		for stage in individual_stages.split():
			if stage in valid_stages:
				stages.append(f"{stage}_{run_tag}")
	elif "to" in sta:
		run_tag = input("Enter the run tag name: ")
		start_stage, end_stage = sta.split("to")
		start_index = valid_stages.index(start_stage.strip())
		end_index = valid_stages.index(end_stage.strip())
		for i in range(start_index, end_index + 1):
			stages.append(f"{valid_stages[i]}_{run_tag}")
	return run, run_tag, stages
def handle_all():
	run = input("Enter the run (ex: run1, run2...): ")
	run_tag = input("Enter the run tag name: ")
	return run, run_tag

def handle_lec():
	run = input("Enter the run (ex: run1, run2...): ")
	run_tag = input("Enter the run tag name: ")
	return run, run_tag

def handle_sta():
	run = input("Enter the run (ex: run1, run2...): ")
	run_tag = input("Enter the run tag name: ")
	return run, run_tag

def directory_creation(pname, rtlrelease, block, default_flow, workarea, stage_in_asic, runname, stages_run_tag, level1, csv_folder):
	try:
		for rtlreleases in rtlrelease:
			for default_flows in default_flow:
				for stagess in stage_in_asic:
					os.makedirs(os.path.join(pname, rtlreleases, block, default_flows), mode=mode, exist_ok=True)
					if stagess in ["PD", "SYNTH"]:
						path_1 = os.path.join(pname, rtlreleases, block, stagess, workarea, runname)
						os.makedirs(path_1, mode=mode, exist_ok=True)
						for stag in stages_run_tag:
							for level in level1:
								if level not in ["customscripts" ,"inputs","run_database"]:
									path_2 = os.path.join(path_1, level, stag)
									os.makedirs(path_2, mode=mode, exist_ok=True)
									if level == "reports":
										os.makedirs(os.path.join(path_2, csv_folder), mode=mode, exist_ok=True)
								else:
									os.makedirs(os.path.join(path_1, level), mode=mode, exist_ok=True)
					elif stagess in ["LEC", "STA"]:
						for j in ["scripts", "customscripts", "reports", "inputs"]:
							os.makedirs(os.path.join(pname, rtlreleases, block, stagess, workarea, runname, j), mode=mode, exist_ok=True)
							if j not in ["inputs","customscripts"]:
								for stag in stages_run_tag:
									os.makedirs(os.path.join(pname, rtlreleases, block, stagess, workarea, runname, j, stag), mode=mode, exist_ok=True)
	except Exception as e:print(f" error making directory_structure {e}")


			

def copy_files(central_directory_path,name,project,blocks,sub_plug,stages,pname ,rtlrelease,block_name ,default_flow ,workarea ,stage_in_asic,runname,stages_run_tag,level1):
	for i in stage_in_asic:
		for j in stages_run_tag:
			for k in level1:
				if (i == "SYNTH"):						
					try:													
						[shutil.copy2(os.path.join(src, f), os.path.join(dst, f)) for src, dst in [(f"{central_directory_path}/{name}/{project[0]}/{blocks[0]}/genus/inputs/", f"{pname}/{rtlrelease[0]}/{block_name}/SYNTH/{workarea}/{runname}/inputs/")] for f in os.listdir(src) if not os.path.exists(os.path.join(dst, f))]
						[shutil.copy2(os.path.join(src, f), os.path.join(dst, f)) for src, dst in [(f"{central_directory_path}/{name}/{project[0]}/{blocks[0]}/genus/scripts/", f"{pname}/{rtlrelease[0]}/{block_name}/SYNTH/{workarea}/{runname}/scripts/{j}/")] for f in os.listdir(src) if not os.path.exists(os.path.join(dst, f))]												
						[shutil.copy2(os.path.join(src, f), os.path.join(dst, f)) for src, dst in [(f"{central_directory_path}/{name}/{project[0]}/{blocks[0]}/genus/customscripts/", f"{pname}/{rtlrelease[0]}/{block_name}/SYNTH/{workarea}/{runname}/customscripts/")] for f in os.listdir(src) if not os.path.exists(os.path.join(dst, f))]
					except Exception as e:print(f" copy_file stage SYNTH {e}")
				
				if (i == "PD"):	
					try:													
						[shutil.copy2(os.path.join(src, f), os.path.join(dst, f)) for src, dst in [(f"{central_directory_path}/{name}/{project[0]}/{blocks[0]}/innovus/inputs/", f"{pname}/{rtlrelease[0]}/{block_name}/PD/{workarea}/{runname}/inputs/")] for f in os.listdir(src) if not os.path.exists(os.path.join(dst, f))]
						[shutil.copy2(os.path.join(src, f), os.path.join(dst, f)) for src, dst in [(f"{central_directory_path}/{name}/{project[0]}/{blocks[0]}/innovus/scripts/{j.split('_')[0]}/", f"{pname}/{rtlrelease[0]}/{block_name}/PD/{workarea}/{runname}/scripts/{j}/")] for f in os.listdir(src) if not os.path.exists(os.path.join(dst, f))]											
						[shutil.copy2(os.path.join(src, f), os.path.join(dst, f)) for src, dst in [(f"{central_directory_path}/{name}/{project[0]}/{blocks[0]}/innovus/customscripts/", f"{pname}/{rtlrelease[0]}/{block_name}/PD/{workarea}/{runname}/customscripts/")] for f in os.listdir(src) if not os.path.exists(os.path.join(dst, f))]
					except Exception as e:print(f" copy_file stage PD {e}")

				if (i == "LEC"):
					if (j.split("_")[0] == "LEC"):
						try:													
							[shutil.copy2(os.path.join(src, f), os.path.join(dst, f)) for src, dst in [(f"{central_directory_path}/{name}/{project[0]}/{blocks[0]}/lec/inputs/", f"{pname}/{rtlrelease[0]}/{block_name}/LEC/{workarea}/{runname}/inputs/")] for f in os.listdir(src) if not os.path.exists(os.path.join(dst, f))]
							[shutil.copy2(os.path.join(src, f), os.path.join(dst, f)) for src, dst in [(f"{central_directory_path}/{name}/{project[0]}/{blocks[0]}/lec/scripts/", f"{pname}/{rtlrelease[0]}/{block_name}/LEC/{workarea}/{runname}/scripts/{j}/")] for f in os.listdir(src) if not os.path.exists(os.path.join(dst, f))]
							[shutil.copy2(os.path.join(src, f), os.path.join(dst, f)) for src, dst in [(f"{central_directory_path}/{name}/{project[0]}/{blocks[0]}/lec/customscripts/", f"{pname}/{rtlrelease[0]}/{block_name}/LEC/{workarea}/{runname}/customscripts/")] for f in os.listdir(src) if not os.path.exists(os.path.join(dst, f))]
						except Exception as e:pass				
				
				if (i == "STA"):
					try:
						[shutil.copy2(os.path.join(src, f), os.path.join(dst, f)) for src, dst in [(f"{central_directory_path}/{name}/{project[0]}/{blocks[0]}/tempus/inputs/", f"{pname}/{rtlrelease[0]}/{block_name}/STA/{workarea}/{runname}/inputs/")] for f in os.listdir(src) if not os.path.exists(os.path.join(dst, f))]
						[shutil.copy2(os.path.join(src, f), os.path.join(dst, f)) for src, dst in [(f"{central_directory_path}/{name}/{project[0]}/{blocks[0]}/tempus/scripts/", f"{pname}/{rtlrelease[0]}/{block_name}/STA/{workarea}/{runname}/scripts/{j}/")] for f in os.listdir(src) if not os.path.exists(os.path.join(dst, f))]
						[shutil.copy2(os.path.join(src, f), os.path.join(dst, f)) for src, dst in [(f"{central_directory_path}/{name}/{project[0]}/{blocks[0]}/tempus/customscripts/", f"{pname}/{rtlrelease[0]}/{block_name}/STA/{workarea}/{runname}/customscripts/")] for f in os.listdir(src) if not os.path.exists(os.path.join(dst, f))]
					except Exception as e:print(f" error copy_file stage  STA {e}")

				if (i == "config"):
					try:
 						[shutil.copy(f"{central_directory_path}/{name}/{project[0]}/{blocks[0]}/genus/complete_config.tcl", f"{pname}/{rtlrelease[0]}/{block_name}/config/config_{workarea}_{runname}.tcl") for _ in [0] if not os.path.exists(f"{pname}/{rtlrelease[0]}/{block_name}/config/config_{workarea}_{runname}.tcl")]
						
					except Exception as e:print(f" error copy_file stage  config")


def making_of_default_files(pname, rtlrelease, block_name,stage_in_flow,workarea,runname,stages_run_tag,abcd):	
	for i in stage_in_flow:
		if i == "PD":				
			for  j in stages_run_tag:
				default_make_path=f"{pname}/{rtlrelease[0]}/{block_name}/{i}/{workarea}/{runname}/scripts/{j}/make_{j.split('_')[0].lower()}.csh"
				if not os.path.exists(default_make_path):
					y=open(f"{pname}/{rtlrelease[0]}/{block_name}/{i}/{workarea}/{runname}/scripts/{j}/make_{j.split('_')[0].lower()}.csh",'w')						
					y.write(f"""\nsource /nas/nas_v1/tools.bashrc\ndate=`date +"%d-%m-%y_%H-%M-%S"`\ninnovus -stylus -log ../../logs/{j}/{j.split('_')[0].lower()}_"$date".log -files ./{j.split('_')[0].lower()}.tcl  """)
		if i =="SYNTH":	
			for  j in stages_run_tag:
				default_make_path=f"{pname}/{rtlrelease[0]}/{block_name}/{i}/{workarea}/{runname}/scripts/{j}/make_{j.split('_')[0].lower()}.csh"
				if not os.path.exists(default_make_path):
					y=open(f"{pname}/{rtlrelease[0]}/{block_name}/{i}/{workarea}/{runname}/scripts/{j}/make_{j.split('_')[0].lower()}.csh",'w')						
					y.write(f"""\nsource /nas/nas_v1/tools.bashrc\ndate=`date +"%d-%m-%y_%H-%M-%S"`\ngenus -log ../../logs/{j}/genus_"$date".log -f ./synthesis.tcl """)
		if i == "LEC":
			default_lib_config_path=f"{pname}/{rtlrelease[0]}/{block_name}/{i}/{workarea}/{runname}/scripts/default_lib.tcl"
			if not os.path.exists(default_lib_config_path):
				z=open(default_lib_config_path,'w')
				z.write(f"""read library -Liberty <lib_path>""")
			for  j in stages_run_tag:
				default_script_path=f"{pname}/{rtlrelease[0]}/{block_name}/{i}/{workarea}/{runname}/scripts/{j}/{j.split('_')[0].lower()}.do"
				if not os.path.exists(default_script_path):
					z=open(default_script_path,'w')
					z.write(f"""\nsource ../default_lib.tcl\nread design <synthesis_netlist> -verilog -golden\nread design <stage_netlist> -verilog -revised\nset system mode lec\nadd compare point -all\ncompare -threads 4,4\nreport verification > ../reports/{j}/lec_{j.split('_')[0].lower()}_verify.rpt\nexit""")
			for  j in stages_run_tag:
				default_make_path=f"{pname}/{rtlrelease[0]}/{block_name}/{i}/{workarea}/{runname}/scripts/{j}/make_LEC_{j.split('_')[0].lower()}.csh"
				if not os.path.exists(default_make_path):
					y=open(f"{pname}/{rtlrelease[0]}/{block_name}/{i}/{workarea}/{runname}/scripts/{j}/make_LEC_{j.split('_')[0].lower()}.csh",'w')
					y.write(f"""\nsource /nas/nas_v1/tools.bashrc\nlec -GXL -nogui -color -64 -dofile {j.split('_')[0].lower()}.do """)
		#### making of complete make file in scripts directory :
		if i in ["SYNTH","PD"]:
			ppp=os.getcwd()
			for  j in stages_run_tag:		
				if i == "PD":
					abcd.write(f"""\ncd {ppp}/{pname}/{rtlrelease[0]}/{block_name}/{i}/{workarea}/{runname}/scripts/{j}/ """)
					abcd.write(f"""\nsource make_{j.split('_')[0].lower()}.csh """)
				if i == "SYNTH":
					abcd.write(f"""\ncd {ppp}/{pname}/{rtlrelease[0]}/{block_name}/{i}/{workarea}/{runname}/scripts/{j}/ """)
					abcd.write(f"""\nsource make_{j.split('_')[0].lower()}.csh """)
				if i == "LEC":
					abcd.write(f"""\ncd {ppp}/{pname}/{rtlrelease[0]}/{block_name}/{i}/{workarea}/{runname}/scripts/{j}/ """)
					abcd.write(f"""\nsource make_LEC_{j.split('_')[0].lower()}.csh""")
					
		



def linking_config(pname ,rtlrelease,block_name,default_flow,workarea,stage_in_asic,runname,stages_run_tag,level1):
	ppp=os.getcwd()
	src =f"{ppp}/{pname}/{rtlrelease[0]}/{block_name}/config/config_{workarea}_{runname}.tcl"
	dst =[f"{ppp}/{pname}/{rtlrelease[0]}/{block_name}/SYNTH/{workarea}/{runname}/scripts/config.tcl", f"{ppp}/{pname}/{rtlrelease[0]}/{block_name}/PD/{workarea}/{runname}/scripts/config.tcl"]
	for dsts in dst:
		if os.path.exists('/'.join(dsts.split('/')[:-1])):
			try:
				#print(src,dsts)
				os.symlink(src,dsts)
			except FileExistsError : pass
			except Exception as e: print(e)
		else:
			pass


################################################################################################################################################################################


def main():
	central_directory_path = "/nas/nas_v1/Innovus_trials/users/udaykiran/trails"
	# Parameters for central_directory
	name = "central_scripts"
	project = ['project']
	blocks = ["blockname"]
	tools = ["innovus", "genus", "lec", "calibre", "voltus", "starRc","tempus"]
	sub_plug = ["scripts", "inputs", "customscripts", "input_lib"]
	stages = ['Floorplan', 'Place', 'CTS', 'Route']

	# Get user input and handle stages
	pname, block_name, user_name, stage_in_flow = get_user_input()

	# Parameters for flow directory
	rtlrelease = ["1.0"]
	default_flow = ['RTL', 'INPUT_LIB','config']
	workarea = user_name
	runname = None  # Initialize runname; will be set later based on user input
	level1 = ['logs', 'reports', 'outputs', 'inputs', 'data', 'scripts', 'customscripts', 'snapshots','run_database']
	csv_folder = "csv"

	# Create central directory structure
	#create_central_directory_structure(name, project, blocks, tools, sub_plug, stages)

	# Handle different stages based on user input
	if stage_in_flow == "synthesis":
		run, run_tag = handle_synthesis()
		print(f"Synthesis run: {run}, Tag: {run_tag}")
		runname = run 
		stages_run_tag = [f"Synthesis_{run_tag}"]  # Example of how to create a list of stages
		default_make_path="make.csh"
		abcd=open(default_make_path,'w')
		directory_creation(pname, rtlrelease, block_name, default_flow, workarea, ["SYNTH"], runname, stages_run_tag, level1, csv_folder)
		copy_files(central_directory_path,name,project,blocks,sub_plug,stages,pname ,rtlrelease,block_name ,default_flow ,workarea ,["SYNTH","config"],runname,stages_run_tag,level1)
		making_of_default_files(pname, rtlrelease, block_name, ["SYNTH"],workarea,runname,stages_run_tag,abcd)
		linking_config(pname ,rtlrelease,block_name,default_flow,workarea,["SYNTH"],runname,stages_run_tag,level1)
	elif stage_in_flow == "PNR":
		run, run_tag, stages_run_tag = handle_pnr()
		print(f"PNR run: {run}, Tag: {run_tag}, Stages: {stages_run_tag}")
		runname = run  # Set runname for directory creation
		default_make_path="make.csh"
		abcd=open(default_make_path,'w')
		directory_creation(pname, rtlrelease, block_name, default_flow, workarea, ["PD", "EMIR", "DV", "PV", "LEC"], runname, stages_run_tag, level1, csv_folder)
		copy_files(central_directory_path,name,project,blocks,sub_plug,stages,pname ,rtlrelease,block_name ,default_flow ,workarea ,["PD", "EMIR", "DV", "PV", "LEC","config"],runname,stages_run_tag,level1)
		making_of_default_files(pname, rtlrelease, block_name, ["PD", "EMIR", "DV", "PV", "LEC"],workarea,runname,stages_run_tag,abcd)
		linking_config(pname ,rtlrelease,block_name,default_flow,workarea,["PD"],runname,stages_run_tag,level1)
		for i in stages_run_tag:
			stages_run_tag=[]
			if ((i.split("_")[0] == "CTS") or (i.split("_")[0] == "Route")):
				
				stages_run_tag.append(i)  # Append to the list
			if stages_run_tag:  # Check if there are any relevant tags
				directory_creation(pname, rtlrelease, block_name, default_flow, workarea, ["STA"], runname, stages_run_tag, level1, csv_folder)
				copy_files(central_directory_path,name,project,blocks,sub_plug,stages,pname ,rtlrelease,block_name ,default_flow ,workarea ,["STA"],runname,stages_run_tag,level1)

				making_of_default_files(pname, rtlrelease, block_name, ["STA"],workarea,runname,stages_run_tag,abcd)

	elif stage_in_flow == "all":
		run, run_tag = handle_all()
		print(f"Synthesis run: {run}, Tag: {run_tag}, PNR run: {run}, Tag: {run_tag}, LEC run: {run}, Tag: {run_tag}, STA run: {run}, Tag: {run_tag}")
		runname = run  # Set runname for directory creation
		stages_run_tag = [f"Synthesis_{run_tag}"]
		default_make_path="make.csh"
		abcd=open(default_make_path,'w')
		directory_creation(pname, rtlrelease, block_name, default_flow, workarea, ["SYNTH"], runname, stages_run_tag, level1, csv_folder)
		copy_files(central_directory_path,name,project,blocks,sub_plug,stages,pname ,rtlrelease,block_name ,default_flow ,workarea ,["SYNTH","config"],runname,stages_run_tag,level1)
		making_of_default_files(pname, rtlrelease, block_name, ["SYNTH"],workarea,runname,stages_run_tag,abcd)
		linking_config(pname ,rtlrelease,block_name,default_flow,workarea,["SYNTH"],runname,stages_run_tag,level1)

		stages_run_tag =[f"Floorplan_{run_tag}",f"Place_{run_tag}",f"CTS_{run_tag}",f"Route_{run_tag}"]
		directory_creation(pname, rtlrelease, block_name, default_flow, workarea, ["PD","LEC"], runname, stages_run_tag, level1, csv_folder)
		copy_files(central_directory_path,name,project,blocks,sub_plug,stages,pname ,rtlrelease,block_name ,default_flow ,workarea ,["PD","LEC","config"],runname,stages_run_tag,level1)
		making_of_default_files(pname, rtlrelease, block_name, ["PD","LEC"],workarea,runname,stages_run_tag,abcd)
		linking_config(pname ,rtlrelease,block_name,default_flow,workarea,["PD"],runname,stages_run_tag,level1)

		stages_run_tag =[f"LEC_{run_tag}"]	
		#directory_creation(pname, rtlrelease, block_name, default_flow, workarea, ["LEC"], runname, stages_run_tag, level1, csv_folder)
		copy_files(central_directory_path,name,project,blocks,sub_plug,stages,pname ,rtlrelease,block_name ,default_flow ,workarea ,["LEC"],runname,stages_run_tag,level1)

		stages_run_tag =[f"STA_{run_tag}"]
		directory_creation(pname, rtlrelease, block_name, default_flow, workarea, ["STA"], runname, stages_run_tag, level1, csv_folder)
		copy_files(central_directory_path,name,project,blocks,sub_plug,stages,pname ,rtlrelease,block_name ,default_flow ,workarea ,["STA"],runname,stages_run_tag,level1)

	elif stage_in_flow == "LEC":
		run, run_tag = handle_sta()
		print(f"LEC run: {run}, Tag: {run_tag}")
		runname = run  # Set runname for directory creation
		stages_run_tag = [f"LEC_{run_tag}"]  # Example of how to create a list of stages
		directory_creation(pname, rtlrelease, block_name, default_flow, workarea, ["LEC"], runname, stages_run_tag, level1, csv_folder)
		copy_files(central_directory_path,name,project,blocks,sub_plug,stages,pname ,rtlrelease,block_name ,default_flow ,workarea ,["LEC"],runname,stages_run_tag,level1)

	
	elif stage_in_flow == "STA":
		run, run_tag = handle_lec()
		print(f"STA run: {run}, Tag: {run_tag}")
		runname = run  # Set runname for directory creation
		stages_run_tag = [f"STA_{run_tag}"]  # Example of how to create a list of stages
		directory_creation(pname, rtlrelease, block_name, default_flow, workarea, ["STA"], runname, stages_run_tag, level1, csv_folder)
		copy_files(central_directory_path,name,project,blocks,sub_plug,stages,pname ,rtlrelease,block_name ,default_flow ,workarea ,["STA"],runname,stages_run_tag,level1)

			

	


if __name__ == "__main__":
	main()
						


