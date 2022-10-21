@echo off
@TITLE SAVE BEST SOLUTION
echo saving input files for the best solution found...

IF NOT EXIST best mkdir best

cp ./model/output/Diagnostics.csv best/Diagnostics.csv
cp ./model/modelname.rvp best/modelname.rvp
cp ./model/modelname.rvi best/modelname.rvi







