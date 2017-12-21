%% run simulations
run_fixed_O2('params.json')

%% display results
load('results.mat', 'resolution')
fprintf('Resolution in x-direction: %g\n', resolution.x_res)
fprintf('Resolution in z-direction: %g\n', resolution.z_res)
