import plot.plot_param_study
import plot.plot_O2_titration

%% run simulations
run_param_study_O2_diffusion('params.json', 'param_study.json')

%% plot results
plot_O2_titration('results.mat')
plot_param_study('results.mat')
