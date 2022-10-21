@echo off

cd ./model/
Raven.exe modelname -o ./output/
REM Rscript rcalc_diagnostics.R
cd ..

