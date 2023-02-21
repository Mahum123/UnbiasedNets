# Required packages for functioning
import os
import sys

sel_dataset = int(sys.argv[1]) #training dataset to use

# Original Dataset 	= 0
# Unbiased Dataset 	= 1
# ROS Dataset 		= 2
# RUS Dataset 		= 3
# SMOTE Dataset 	= 4
# ADASYN Dataset 	= 5

val = ""
epochs = 0

if sel_dataset == 0:
	val = "train_data.csv"
	epochs = 80
elif sel_dataset == 1:
	val = "train_diversified.csv"
	epochs = 12
elif sel_dataset == 2:
	val = "train_ROS.csv"
	epochs = 56
elif sel_dataset == 3:
	val = "train_RUS.csv"
	epochs = 84 
elif sel_dataset == 4:
	val = "train_SMOTE.csv"
	epochs = 56
elif sel_dataset == 5:
	val = "train_ADASYN.csv"
	epochs = 56 # Vals required

path_val = "/Datasets/" + val

train_file = "./Matlab/Training.m"

ofile = open(train_file, "r")
lines = ofile.readlines()
ofile.close()
lines[27] = "    temp = csvread(strcat(temp_val,\'"+path_val+"\'));\n"
lines[51] = "    epoch="+str(epochs)+";\n"

tfile = open(train_file, "w")
tfile.writelines(lines)
tfile.close()
