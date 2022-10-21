#!/bin/bash

set -ex
# set option to stop on error, not continue
# x for debugging, writes out each line (more terminal output)

# echo "pwd is $(pwd)"

current_wd=$(pwd)

# Rscript ../aa_write_input_files_01.R

# unlink dangling symbolic links
if [ -e Ostrich.exe ] ; then
    rm Ostrich.exe
fi
if [ -e model/Raven.exe ] ; then
    rm model/Raven.exe
fi

# switch to tmpdir
if [ ! -d $1 ] ; then
	mkdir $1
fi
cd $1
tmpdir="./raven_run_$2_$3"

# remove previous raven_run folders
if [ -d "raven_run" ] ; then 
	for f in ./raven_run*; do
		# echo $f
		rm -r $f
		break
	done
fi

# make tmpdir if not exists
if [ ! -d $tmpdir ] ; then
    mkdir $tmpdir
fi
cd $tmpdir

# copy everything to tmpdir
cp -rp $current_wd/* .

# copy executables over
# rm ./exes/*
cp $current_wd/../../exes/Raven_rev345rc.exe ./model/Raven.exe
cp $current_wd/../../exes/Ostrich.exe ./Ostrich.exe

# make calib_runs folder
# if [ ! -d calib_runs ] ; then
#     mkdir calib_runs
# fi

# run calibration and post calibration processing script
./Ostrich.exe
Rscript aa_postcalib.R


# zip all files we want
tar -czvf best_$2_$3.tar.gz best

# copy zip back to other folder
cp -rp best_$2_$3.tar.gz $current_wd/. 

# cleanup
cd ..
rm -r $tmpdir
cd $current_wd

# unzip calib runs in og directory
tar -xzvf best_$2_$3.tar.gz
rm -r best_$2_$3.tar.gz

