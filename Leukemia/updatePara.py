import os
import scipy.io

var = scipy.io.loadmat('./Matlab/weights.mat')

val1 = var['w1']
val2 = var['w2']

incorr = var['mis']

mean_train1 = var['mean_train']
std_train1 = var['std_train']

#print(val1)
#print(val2)
#print(mean_train1)
#print(std_train1)

fopen = open("SMV/basis/network.smv","r")
lines = fopen.readlines()
fopen.close()

f2open = open("./run_pbe.m","r")
f2_lines = f2open.readlines()
f2open.close()

f2_lines[66] = 'w1 = [\n'
f2_lines[88] = 'w2 = [\n'
f2_lines[59] = 'mean_train = [\n'
f2_lines[63] = 'std_train = [\n'

#w1
line_val = 0
line_val2 = 0
string_val = ''
for i in range(0,20):
	for k in range(0,6):
		lines[78+line_val] = 'w1_'+str(i+1)+str(k+1)+' := '+str(val1[i][k])+';\n'
		string_val = string_val + str(val1[i][k]) + ' '
		line_val = line_val + 1
	f2_lines[67+line_val2] = string_val + '\n'
	string_val = ''
	line_val2 = line_val2 + 1
f2_lines[87] = '];\n'

#w2
line_val = 0
line_val2 = 0
string_val = ''
for i in range(0,2):
	for k in range(0,20):
		lines[201+line_val] = 'w2_'+str(i+1)+str(k+1)+' := '+str(val2[i][k])+';\n'
		string_val = string_val + str(val2[i][k]) + ' '
		line_val = line_val + 1
	f2_lines[89+line_val2] = string_val + '\n'
	string_val = ''
	line_val2 = line_val2 + 1
f2_lines[91] = '];\n'

#mean and std
line_val = 0
line_val2 = 0
string_val = ''
string_val2 = ''
for i in range(0,5):
	lines[59+line_val] = 'mean_i'+str(i+2)+' := '+str(mean_train1[0][i])+';\n'
	line_val = line_val + 1
	lines[59+line_val] = 'std_i'+str(i+2)+' := '+str(std_train1[0][i])+';\n'
	line_val = line_val + 1
	string_val = string_val + str(mean_train1[0][i]) + ' '
	string_val2 = string_val2 + str(std_train1[0][i]) + ' '

f2_lines[60] = string_val + '\n'
f2_lines[61] = '];\n'
f2_lines[64] = string_val2 + '\n'
f2_lines[65] = '];\n'

fopen = open("SMV/basis/network.smv", "w")
fopen.writelines(lines)
fopen.close()

f2open = open("Matlab/run_pbe.m", "w")
f2open.writelines(f2_lines)
f2open.close()

sh = open("SMV/run.sh", "r")
sh_new = open("SMV/newrun.sh", "w")
for i, line in enumerate(sh):
    if "#pointer for incorr" not in line:
        sh_new.writelines(line)
    else:
        sh_new.writelines(["        if [ $r -eq ",str(incorr[0][0])," ] #pointer for incorr\n"])
sh_new.close()
sh.close()

os.remove("SMV/run.sh")
os.rename("SMV/newrun.sh", "SMV/run.sh")

