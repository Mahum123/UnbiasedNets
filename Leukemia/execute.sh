#!/bin/bash

echo "========================================="
echo "Training Network"
echo "========================================="

matlab -nodisplay -nosplash -nodesktop -r "run('./Matlab/Training.m');exit;"

echo "========================================="
echo "Training Completed"
echo "========================================="

python updatePara.py

echo "========================================="
echo "Files Modified"
echo "========================================="

chmod +x ./SMV/basis/nuXmv_linux64.sh
chmod +x ./SMV/run.sh
./SMV/run.sh

echo "========================================="
echo "Executions Complete"
echo "========================================="

python SMV/smv2csv.py

echo "========================================="
echo "CSV File Generated"
echo "========================================="

matlab -nodisplay -nosplash -nodesktop -r "run('./run_pbe.m');exit;"

echo "========================================="
echo "PBE Values Extracted"
echo "========================================="
