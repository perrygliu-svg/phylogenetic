#!/bin/bash
#$ -cwd
# error = Merged with joblog
#$ -o $HOME/joblogs/joblog.$JOB_ID
#$ -j y
#$ -l highp,h_rt=23:45:00
#$ -pe shared 1
#$ -t 1-1:1
#$ -M $USER@mail
#$ -m bea

BEAST_LOCATION="/u/home/p/perry/Projects/beast-mcmc" # with the path to the location
xml_analysis="/u/home/p/perry/phylogenetic/RABV_experimental.xml" #including both the path and the name
BEAGLE_ORDER="0"

. /u/local/Modules/default/init/modules.sh
module load gcc
module load amd/rocm

export GPU_DEVICE_ORDINAL=$SGE_HGR_vega
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Date: " `date `
echo "Device: $GPU_DEVICE_ORDINAL" # TODO check if this is correct since the output is 0
echo "Script name $0"

export LD_LIBRARY_PATH="$HOME/lib:$\{LD_LIBRARY_PATH:-\}"
export PKG_CONFIG_PATH="$HOME/lib/pkgconfig:$\{PKG_CONFIG_PATH:-\}"

echo "The output folder is: ${folder_name}"
echo "Running Analysis on Beast... "
    java -jar "${BEAST_LOCATION}/build/dist/beast.jar" -beagle_order $BEAGLE_ORDER \
    -seed 666 -overwrite "${xml_analysis}" > "experimental.txt" 2>&1

