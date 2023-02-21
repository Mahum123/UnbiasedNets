import numpy as np
from keras.models import Sequential
from keras.layers import Dense
from tensorflow.keras.utils import to_categorical
import pandas as pd

def load_data():
    train_dataset = pd.read_csv("Datasets/iris_train_RUS.csv")
    test_dataset = pd.read_csv("Datasets/iris_test.csv")
    train_columns = train_dataset.columns
    X_train = train_dataset[train_columns[train_columns != 'variety']]
    y_train = train_dataset['variety']

    test_columns = test_dataset.columns
    X_test = test_dataset[test_columns[test_columns != 'variety']]
    y_test = test_dataset['variety']

    y_train = pd.get_dummies(y_train)
    y_test = pd.get_dummies(y_test)

    return X_train, y_train, X_test, y_test

def build_model():
    model = Sequential()
    model.add(Dense(15, activation='relu', input_shape=(X_train.shape[1],)))
    model.add(Dense(15, activation='relu'))
    model.add(Dense(3, activation='softmax'))

    model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])
    return model

X_train, y_train, X_test, y_test = load_data()
model = build_model()

scores_train = model.evaluate(X_train, y_train)
scores_test = model.evaluate(X_test, y_test)

while scores_train[1] < 0.9 and scores_test[1] < 1.0:
    model.fit(X_train, y_train, epochs=106, verbose=2, validation_split=0.2, shuffle=True)
#   With SMOTE:                 119
#   With ROS:                   128

    model.summary()

    np.set_printoptions(threshold=np.inf)
    # print(f'Weights Layer 1: \n{model.layers[0].get_weights()[0]} \n')
    # print(f'Biases Layer 1: \n{model.layers[0].get_weights()[1]} \n')
    # print(f'Weights Layer 2: \n{model.layers[1].get_weights()[0]} \n')
    # print(f'Biases Layer 2: \n{model.layers[1].get_weights()[1]} \n')
    # print(f'Weights Layer 3: \n{model.layers[2].get_weights()[0]} \n')
    # print(f'Biases Layer 3: \n{model.layers[2].get_weights()[1]} \n')

    scores_train = model.evaluate(X_train, y_train)
    # print(f'\n\nTraining Accuracy: {scores_train[1]} \n Error: {1 - scores_train[1]}')
    scores_test = model.evaluate(X_test, y_test)
     # print(f'\n\nTesting Accuracy: {scores_test[1]} \n Error: {1 - scores_test[1]}')


fopen = open("SMV/basis/network.smv", "r")
lines = fopen.readlines()
fopen.close()

f2open = open("run_pbe.m","r")
f2_lines = f2open.readlines()
f2open.close()

f2_lines[65] = 'w1 = [\n'
f2_lines[71] = 'w2 = [\n'
f2_lines[88] = 'w3 = [\n'
f2_lines[105] = 'b1 = [\n'
f2_lines[108] = 'b2 = [\n'
f2_lines[111] = 'b3 = [\n'

# weights in layer 1
line_val = 0
line_val2 = 0
string_val = ''
for i in range(0,4):
    for k in range(0,15):
        lines[114+line_val] = 'w1_'+str(i+1)+'_'+str(k+1)+' := '+str(model.layers[0].get_weights()[0][i][k])+';\n'
        string_val = string_val + str(model.layers[0].get_weights()[0][i][k]) + ' '
        line_val = line_val + 1
    f2_lines[66+line_val2] = string_val + '\n'
    string_val = ''
    line_val2 = line_val2 + 1
f2_lines[70] = '];\n'

# weights in layer 2
line_val = 0
line_val2 = 0
string_val = ''
for i in range(0,15):
    for k in range(0,15):
        lines[177+line_val] = 'w2_'+str(i+1)+'_'+str(k+1)+' := '+str(model.layers[1].get_weights()[0][i][k])+';\n'
        string_val = string_val + str(model.layers[1].get_weights()[0][i][k]) + ' '
        line_val = line_val + 1
    f2_lines[72+line_val2] = string_val+'\n'
    string_val = ''
    line_val2 = line_val2 + 1
f2_lines[87] = '];\n'

# weights in layer 3
line_val = 0
line_val2 = 0
string_val = ''
for i in range(0,15):
    for k in range(0,3):
        lines[405+line_val] = 'w3_'+str(i+1)+'_'+str(k+1)+' := '+str(model.layers[2].get_weights()[0][i][k])+';\n'
        string_val = string_val + str(model.layers[2].get_weights()[0][i][k]) + ' '
        line_val = line_val + 1
    f2_lines[89+line_val2] = string_val+'\n'
    string_val = ''
    line_val2 = line_val2 + 1
f2_lines[104] = '];\n'

# biases in layer 1
line_val = 0
line_val2 = 0
string_val = ''
for i in range(0,15):
    lines[453+line_val] = 'b1_'+str(i+1)+' := '+str(model.layers[0].get_weights()[1][i])+';\n'
    string_val = string_val + str(model.layers[0].get_weights()[1][i]) + ' '
    line_val = line_val + 1
f2_lines[106] = string_val+'\n'
string_val = ''
f2_lines[107] = '];\n'

# biases in layer 2
line_val = 0
line_val2 = 0
string_val = ''
for i in range(0,15):
    lines[469+line_val] = 'b2_'+str(i+1)+' := '+str(model.layers[1].get_weights()[1][i])+';\n'
    string_val = string_val + str(model.layers[1].get_weights()[1][i]) + ' '
    line_val = line_val + 1
f2_lines[109] = string_val+'\n'
string_val = ''
f2_lines[110] = '];\n'

# biases in layer 3
line_val = 0
line_val2 = 0
string_val = ''
for i in range(0,3):
    lines[485+line_val] = 'b3_'+str(i+1)+' := '+str(model.layers[2].get_weights()[1][i])+';\n'
    string_val = string_val + str(model.layers[2].get_weights()[1][i]) + ' '
    line_val = line_val + 1
f2_lines[112] = string_val+'\n'
string_val = ''
f2_lines[113] = '];\n'

fopen = open("SMV/basis/network.smv", "w")
fopen.writelines(lines)
fopen.close()

f2open = open("run_pbe.m", "w")
f2open.writelines(f2_lines)
f2open.close()