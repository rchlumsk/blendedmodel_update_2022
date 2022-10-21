
#!/bin/bash

#set -ex
# set option to stop on error, not continue
# x for debugging, writes out each line (more terminal output)

if [ ! -e best ] ; then
    mkdir best
fi

cp ./model/output/Diagnostics.csv best/Diagnostics.csv
cp ./model/modelname.rvp best/modelname.rvp
cp ./model/modelname.rvi best/modelname.rvi
cp ./model/modelname.rvc best/modelname.rvc
cp ./model/modelname.rvt best/modelname.rvt

# exit 0
