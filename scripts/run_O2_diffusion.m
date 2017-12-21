function run_O2_diffusion(sim_param_file)
% RUN_O2_DIFFUSION Simulate phosphorescence decays with oxygen diffusion.

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
import parameter.make_simulation_parameters
import phosphorescence.fit_decay
import phosphorescence.phosphorescence_decay

%% arguments
if nargin < 1
    sim_param_file = 'params.json';
end

%% initialization
sim_params = make_simulation_parameters(sim_param_file);
save_file_name = 'results';
tau = zeros(sim_params.n_gates, 1);
n_photons = zeros(sim_params.n_gates, 1);

%% simulation
[J, tt, resolution] = phosphorescence_decay(sim_params);
for i = 1:sim_params.n_gates
    [tau(i), ~] = fit_decay(tt{i}, J{i}, sim_params.on_time);
    n_photons(i) = photon_count(tt{i}, J{i}, sim_params.on_time);
end

%% save data
save([save_file_name '.mat'], 'J', 'tt', 'sim_params', 'tau', 'n_photons', 'resolution')
fprintf('Saved simulation data to %s.\n', [save_file_name '.mat'])

end

