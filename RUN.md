Additional instructions to run 2POD
===================================

Running simulations on the command line
---------------------------------------

To run simulations simultaneously, launch the running script (e.g.
'run.m') from the command line as follows:

    matlab -nodisplay < run.m | tee run_name.log

When the execution has started, the script can be modified and used in
the MATLAB GUI without affecting the simulation.

Running on a cluster with LSF
-----------------------------

2POD has been used on a cluster using the IBM LSF (load sharing facility).
The [introduction](https://scicomp.ethz.ch/wiki/Getting_started_with_clusters#Using_the_batch_system) 
on the ETH Zurich website is useful, as well as the
[LSF submission line advisor](https://scicomp.ethz.ch/lsf_submission_line_advisor).
The [documentation](https://www.ibm.com/support/knowledgecenter/en/SSETD4_9.1.3/lsf_welcome.html)
is available on the IBM website.

A serial simulation can be with maximum run time of 30 min and 4096MB of memory can be
submitted to LSF as follows.

    bsub -W 0:30 -R "rusage[mem=4096]" "matlab -nodisplay -singleCompThread < run.m"

The setup of parallel simulations with MATLAB on the Euler cluster is described
[here](https://scicomp.ethz.ch/wiki/MATLAB) 
and
[here](https://scicomp.ethz.ch/wiki/MATLAB_PCT).

Since the parameter studies with our code are embarrassingly parallel, its
parallelization simply relies on `parfor`.

A wrapper for parallel simulations is given by `scripts/pool_runner.m`. 
This wrapper is specially adapted to the Euler cluster at ETH Zurich. The cluster
configuration in MATLAB needs to be adapted to different computing environments.
The tutorial `tutorials/param_study/power_probe_dependence_parallel` can be run in parallel by 
submitting the script `pool_runner.m` to LSF as follows:

    bsub -n 1 -W 04:00 matlab -singleCompThread -r pool_runner

The number of processors is defined by the variable `n_proc` in `pool_runner.m`.
The time limit for the further submitted jobs is defined by the line

    cluster.SubmitArguments = '-W 04:00';

and can be adapted.

If parallel computations are not desired, the `parfor` keyword can be replaced by `for`.
