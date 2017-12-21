% To run this script on the Euler cluster:
% bsub -n 1 -W 04:00 -N -u $EMAIL matlab -singleCompThread -r pool_runner

n_proc = 8;

cluster = parcluster('EulerLSF8h');
cluster.SubmitArguments = '-W 04:00';
jobid = getenv('LSB_JOBID');
mkdir(jobid);
cluster.JobStorageLocation = jobid;
parpool(cluster, n_proc)

run

delete(gcp('nocreate'))
