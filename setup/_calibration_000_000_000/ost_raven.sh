
#!/bin/bash

#set -ex
# set option to stop on error, not continue
# x for debugging, writes out each line (more terminal output)


cd model
./Raven.exe modelname -o ./output/
cd ..

