#!/bin/bash
#
# Run the script run_phosphorescence_decays.m by making a copy of the script
# and submitting the job (uses LSF if run on Euler).
#

jobDuration=$1

scriptName="run_phosphorescence_decays.m"

probeName=$(grep "^probeName" run_phosphorescence_decays.m  | cut -d \' -f2)
runName=$(grep "^runName" run_phosphorescence_decays.m  | cut -d \' -f2)
scriptNameBase=$(basename $scriptName .m)
scriptNameCopy=${scriptNameBase}_${probeName}_$runName.m
logName="diss-${probeName}/$runName.log"

echo "Run name = " $runName
cp $scriptName $scriptNameCopy

echo "Running file" $scriptNameCopy

if [[ $HOSTNAME == euler* ]];
then
    bsub -W $1 -R "rusage[mem=8192]" -o $logName -N -u aluecker@student.ethz.ch "matlab -nodisplay -singleCompThread < $scriptNameCopy"
else
    matlab -nodisplay < $scriptNameCopy | tee $runName.log
fi
