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
	val = "iris_train.csv"
	epochs = 80
elif sel_dataset == 1:
	val = "iris_train_diversified.csv"
	epochs = 38
elif sel_dataset == 2:
	val = "iris_train_ROS.csv"
	epochs = 128
elif sel_dataset == 3:
	val = "iris_train_RUS.csv"
	epochs = 106
elif sel_dataset == 4:
	val = "iris_train_SMOTE.csv"
	epochs = 119
elif sel_dataset == 5:
	val = "iris_train_ADASYN.csv"
	epochs = 80 # Vals required

path_val = "Datasets/" + val

train_file = "Training/training.py"

ofile = open(train_file, "r")
lines = ofile.readlines()
ofile.close()
lines[7] = "    train_dataset = pd.read_csv(\""+path_val+"\")\n"
lines[38] = "    model.fit(X_train, y_train, epochs="+str(epochs)+", verbose=2, validation_split=0.2, shuffle=True)\n"

tfile = open(train_file, "w")
tfile.writelines(lines)
tfile.close()
