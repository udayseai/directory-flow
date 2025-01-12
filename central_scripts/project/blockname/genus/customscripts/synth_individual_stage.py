
import re,time,sys
###output files###
#output_files="../reports/csv/synth_report.csv"
out=open(sys.argv[1],'w')

## input_filess
files_name="abc"



### for report_area
def report_area(content):
	try: 
		h=re.findall('^\s*(Instance .*)',content,re.S|re.M)[0].split("\n")
		for i in h:
			if ((i.startswith("-")) or (len(i)==0)):
				pass
			if ((i.startswith(" Instance"))):
				c=i.split("  ")
				c=str(c).replace('[','').replace(']','').replace("'",'')
				out.write(c)
				out.write("\n")
			else:
				c=i.split(maxsplit=5)
				c=str(c).replace('[','').replace(']','').replace("'",'')
				out.write(c)
				out.write("\n")


		out.write("\n")
	except Exception as e: print(e)

### for report_gates
def report_gates(content):
	try:
		a=re.findall('\s*(Type\s*Instances\s*Area\s*Area %.*)^$',content,re.S|re.M)[0].split("\n")
		for i in a:
			if ((i.startswith("-")) or (len(i)==0)):
				pass
			else:
				c=i.split()
				if (len(c)>=5):
					c[3]="Area%"
					c.pop()
				c=str(c).replace('[','').replace(']','').replace("'",'')
		        	#print(c)
				out.write(c)
				out.write("\n")
		out.write("\n")
	except Exception as e: pass

### for check_design
def check_design(content): 
	try:
		b=re.findall('^\s*(Name .*?)^$',content,re.M|re.S)[0].split("\n")
		for i in b:
			
			if ((i.startswith("-")) or (len(i)==0)):
				pass
			else:			
				c=i.rsplit(maxsplit=1)			
				c=str(c).replace('[','').replace(']','').replace("'",'')
				#print(c)
				out.write(c)
				out.write("\n")
		out.write("\n")
	except Exception as e: print(e)

### for report_timing_summary
def report_timing_summary(content):
	try:
		d=re.findall('^#\s*(SETUP .*?)^$',content,re.M|re.S)[0].split("\n")
		e=re.findall('^#\s*(DRV .*?)^$',content,re.M|re.S)[0].split("\n")
	
		for i in d:
			#print(i)
			if ((i.startswith("#")) or (len(i)==0)):
				pass
			else:			
				c=i.rsplit(maxsplit=3)			
				c=str(c).replace('[','').replace(']','').replace("'",'')
				#print(c)
				out.write(c)
				out.write("\n")
		out.write("\n")
		for i in e:
			#print(i)
			if ((i.startswith("#")) or (len(i)==0)):
				pass
			else:			
				c=i.rsplit(maxsplit=3)			
				c=str(c).replace('[','').replace(']','').replace("'",'')
				#print(c)
				out.write(c)
				out.write("\n")
		out.write("\n")
	
	except Exception as e: pass
	
### for check_timing_intent	
def check_timing_intent(content):
	try:
		f=re.findall('^(Lint summary)(.*)^$',content,re.M|re.S)
		for i,j in f:
			out.write(i)
			out.write("\n")
			k=j.strip().split("\n")
			for l in k:
				c=l.rsplit(maxsplit=1)
				c=str(c).replace('[','').replace(']','').replace("'",'')
				out.write(c)
				out.write("\n")
		out.write("\n")
	except Exception as e: print(e)
def report_power(content):
	
	try:
		g=re.findall('^(\s*Category.*)',content,re.M|re.S)[0].split("\n")
		for i in g:
			if ((i.startswith("  --")) or (len(i)==0)):
				pass
			else:
				c=i.split()
				c=str(c).replace('[','').replace(']','').replace("'",'')
				#print(c)
				out.write(c)
				out.write("\n")
	
	
		out.write("\n")	
	except Exception as e: pass
	
def report_clocks(content):
	pass
def report_messages (content):
	for i in content.split("\n"):
		if ((i.startswith("|")) and (i.endswith("|"))):
			
			c=i.replace(",","").split("|")
			c=str(c).replace('[','').replace(']','').replace("'",'')
			out.write(c)
			out.write("\n")
	out.write("\n")

def report_runtime(content):
	s=re.findall('([A-Z]+) .* ([\d+\.]+) (\w+)',content)
	for i in s:
		#print(i)
		out.write(f'{i[0]},{i[1]+i[2]}')
		out.write("\n")
	out.write("\n")
files = open(files_name,'r').read()

data=re.findall(r'^ZYX(.*?)@(.*?)\n(.*?)ZYX$',files,re.M|re.S)


#for con in data :
#	stage=con[0]
#	c=con[1]
#	da=con[2]
#	#print(c)
#	globals()[c.split()[0]](da,stage)
#
print(sys.argv)
globals()[sys.argv[2]](open('abc','r').read())		
