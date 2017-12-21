import phosphorescence.n_photon_for_PO2_accuracy
import plot.make_parameter_study_plotter
import plot.save_fig

%% run simulations
run_param_study_fixed_O2('params.json')

%% analyze results
load('results.mat', 'n_photons', 'param_study', 'sim_params')
sigma_PO2 = 0.5;
n_photon_required = n_photon_for_PO2_accuracy(sigma_PO2, sim_params, 1e-6);
n_gates_required = n_photon_required./n_photons;
acquisition_time_required = n_gates_required*sim_params.cycle_length();

%% plot results
plot_param_file = 'plot_params.json';
suffix = '';
set(0, 'DefaultTextInterpreter', 'latex')
plotter = make_parameter_study_plotter(param_study, plot_param_file);

if param_study.n_params() == 1
    figure; hold on
    plotter.plot(n_photons, '$N_{\mathrm{photon}}$ per gate')
    save_fig(['n_photon', suffix])
    
    figure; hold on
    plotter.plot(n_gates_required, ...
        sprintf('$N_{\\mathrm{gates}}$ for $\\sigma_{\\mathrm{P}O_2} = %g$', sigma_PO2))
    set(gca, 'YScale', 'log')
    save_fig(['n_gates', suffix])
    
    figure; hold on
    plotter.plot(acquisition_time_required, ...
        sprintf('acquisition time for $\\sigma_{\\mathrm{P}O_2} = %g \\; [\\mathrm{s}]$', sigma_PO2))
    set(gca, 'YScale', 'log')
    save_fig(['acquisition_time', suffix])
    
% elseif param_study.n_params() == 2
end
