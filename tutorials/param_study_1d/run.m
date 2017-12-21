import plot.plot_param_study

%% run simulations
run_param_study_fixed_O2('params.json', 'param_study.json')

%% plot results
plot_param_study('results.mat')