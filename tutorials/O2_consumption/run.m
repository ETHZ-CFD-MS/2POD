%% run simulations
run_O2_diffusion('params.json')

%% display results
load('results.mat', 'resolution')
fprintf('Resolution in x-direction: %g\n', resolution{1}.x_res)
fprintf('Resolution in z-direction: %g\n', resolution{1}.z_res)
