#!/bin/bash

python Training/training.py

echo "========================================="
echo "Model Trained + Network File Generated"
echo "========================================="

chmod +x ./SMV/basis/nuXmv_linux64.sh
chmod +x ./SMV/run.sh
./SMV/run.sh

echo "========================================="
echo "Executions Complete"
echo "========================================="

python SMV/smv2csv.py

echo "========================================="
echo "Noise CSV File Generated"
echo "========================================="

matlab -nodisplay -nosplash -nodesktop -r "run('./run_pbe.m');exit;"

echo "========================================="
echo "PBE Value Extracted"
echo "========================================="
