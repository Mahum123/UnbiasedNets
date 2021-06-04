# *UnbiasedNets*:A Dataset Diversification Framework for Bias Alleviation in Robust Neural Networks

## Requirements:
The following softwares and packagges are required to run *UnbiasedNets*
* Matlab (versions tested with: R2017b, R2019a)
* Python (versions tested with: 3.7.6, 3.7.9, 3.8.8)
* GCC (versions tested with: 4.8.5 - *version 9.3.0 is not compatible with the current generation of UnbiasedNets*)
* Keras (versions tested with: 2.3.1, 2.4.3)
* Pandas (versions tested with: 1.1.1, 1.1.3)
* Numpy (versions tested with: 1.19.2)
* Scipy (versions tested with: 1.5.2, 1.6.2)

## Datasets included in Repo:
For Iris 
* Training and Testing Datasets (Iris/Datasets/iris_train.csv and Iris/Datasets/iris_test.csv)
* Sample randomly oversampled Training Dataset (Iris/Datasets/iris_train_ROS.csv)
* Sample randomly undersampled Training Dataset (Iris/Datasets/iris_train_RUS.csv)
* Sample SMOTE Training Dataset (Iris/Datasets/iris_train_SMOTE.csv)

 For Lukemia 
* Training and Testing Datasets (Leukemia/Matlab/Datasets/train_data.csv and Leukemia/Matlab/Datasets/test_data.csv)
* Sample randomly oversampled Training Dataset (Leukemia/Matlab/Datasets/train_ROS.csv)
* Sample ADASYN Training Dataset (Leukemia/Matlab/Datasets/train_ADASYN.csv)
* Sample SMOTE Training Dataset (Leukemia/Matlab/Datasets/train_SMOTE.csv)

## Diversification (running UnbiasedNets):
Run the followiing for diversifiying original Iris training dataset
```
cd Iris 
matlab -nodisplay -nosplash -nodesktop -r "run('./Diversification.m');exit;" 
```

Run the followiing for diversifiying original Leukemia training dataset
```
cd Leukemia
matlab -nodisplay -nosplash -nodesktop -r "run('./Matlab/Diversification.m');exit;"
```

## Training and determining Percentage Bias Estimate (PBE) of trained Network:
Run the followiing for diversifiying original Iris training dataset
```
cd Iris
python datasetTrain.py 0
```
> Use 1,2,3 or 4 as argument instead to run experiments for diversified, randomly oversampled, randomly undersampled and SMOTE datasets, respectively
 ```
 chmod +x execute.sh
 ./execute.sh
```

Run the followiing for diversifiying original Leukemia training dataset
```
cd Leukemia
python datasetTrain.py 0
```
> Use 1,2,4 or 5 as argument instead to run experiments for diversified, randomly oversampled, SMOTE and ADASYN datasets, respectively
```
chmod +x execute.sh
./execute.sh
```

## Results
Approach\Dataset | Average PBE (Leukemia) | Average PBE (Iris)
---------------------- | -----------------------------| ----------------------
Original | 0.228 | 0.4732
RUS | 0.1710 | 0.5042
ROS | 0.2213 | 0.8059
SMOTE | 0.1452 | 0.7709
ADASYN | 0.2434 | -
*UnbiasedNets* | 0.1236 | 0.4906
> Due random initialization of network parameters while training, the PBE results vary each time the framework is executed.

## License:
[MIT License](https://opensource.org/licenses/MIT)
