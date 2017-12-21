function run_param_study_O2_diffusion(sim_param_file, param_study_file)
% RUN_PARAM_STUDY_O2_DIFFUSION Run a parameter study of phosphorescence decays
%   with oxygen diffusion and (possibly) photoconsumption.

% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
% Adrien Luecker, Institute of Fluid Dynamics, ETH Zurich, 2014-2017

import optics.photon_count
import parameter.load_param_study
import parameter.make_simulation_parameters
import phosphorescence.fit_decay
import phosphorescence.phosphorescence_decay

%% arguments
if nargin < 1
    sim_param_file = 'params.json';
end
if nargin < 2
    param_study_file = 'param_study.json';
end

%% initialization 
base_sim_params = make_simulation_parameters(sim_param_file);
save_file_name = 'results';

param_study = load_param_study(param_study_file);
n = param_study.n_elements;

tau = zeros(n, base_sim_params.n_gates);
n_photons = zeros(n, base_sim_params.n_gates);
resolution = cell(n, base_sim_params.n_gates);

%% main loop
parfor i = 1:n
    fprintf(param_study.param_value_string(i));
    sim_params = param_study.set_params(base_sim_params, i);
    [J, tt, resolution(i,:)] = phosphorescence_decay(sim_params);
    tau_all_gates = zeros(sim_params.n_gates, 1);
    n_photons_all_gates = zeros(sim_params.n_gates, 1);
    for j_gate = 1:sim_params.n_gates
        [tau_all_gates(j_gate), ~] = fit_decay(tt{j_gate}, J{j_gate}, sim_params.on_time);
        n_photons_all_gates(j_gate) = photon_count(tt{j_gate}, J{j_gate}, sim_params.on_time);
    end
    tau(i, :) = tau_all_gates;
    n_photons(i, :) = n_photons_all_gates;
end

%% save data
save([save_file_name '.mat'], 'base_sim_params', 'param_study', 'tau', 'n_photons',...
    'resolution')
fprintf('Saved simulation data to %s.\n', [save_file_name '.mat'])

end
