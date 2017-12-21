#!/bin/bash
#
# Run the script pool_runner.m by making a copy of that script
# and of run_phosphorescence_decays.m, # and submitting the job 
# using bsub.
#

jobDuration=$1

poolScriptName="pool_runner.m"
runScriptName="run_phosphorescence_decays.m"

probeName=$(grep "^probeName" run_phosphorescence_decays.m  | cut -d \' -f2)
runName=$(grep "^runName" run_phosphorescence_decays.m  | cut -d \' -f2)
poolScriptNameBase=$(basename $poolScriptName .m)
poolScriptNameCopy=${poolScriptNameBase}_${probeName}_$runName.m
runScriptNameBase=$(basename $runScriptName .m)
runScriptNameCopyBase=${runScriptNameBase}_${probeName}_$runName
runScriptNameCopy=${runScriptNameCopyBase}.m
logName="diss-${probeName}/$runName.log"

echo "Run name = " $runName
cp $poolScriptName $poolScriptNameCopy
cp $runScriptName $runScriptNameCopy

# change name of the run script in the pool runner
sed -i s/$runScriptNameBase/$runScriptNameCopyBase/ $poolScriptNameCopy

echo "Running file" $poolScriptNameCopy

if [[ $HOSTNAME == euler* ]];
then
    bsub -n 1 -W $1 -R "rusage[mem=8192]" -o $logName -N -u $EMAIL "matlab -nodisplay -singleCompThread -r pool_runner"
fi

