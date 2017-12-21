function plot_O2_titration(input_filename, suffix)
%PLOT_O2_TITRATION Plot titration curves for a parameter study of oxygen
%   partial pressure.
%
% INPUT_FILENAME  Name of the file containing the results.
% SUFFIX          Suffix appended to the plot file names.

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

import plot.save_fig
import utils.mmHgToMolar

%% parameters
if nargin < 1
    input_filename = 'results.mat';
end
if nargin < 2
    suffix = '';
end

%% load and prepare data
load(input_filename, 'resolution', 'param_study', 'sim_params', 'tau')
stern_vollmer_func = @(tau) ((1./tau) - sim_params.kp)/ ....
    (sim_params.kq*mmHgToMolar(1, sim_params.temp));
O2_vals = param_study.param_values{1};
tau_vals = tau(:, end);  % plot the values of tau from the last gate
set(0, 'DefaultTextInterpreter', 'latex')

%% plot results
figure
plot(1e6*tau_vals, O2_vals, 'k', 'DisplayName', 'with org. molec.')
xlabel('$\tau \; [\mathrm{\mu s}]$')
ylabel('$\mathrm{PO}_2 \; [\mathrm{mm\,Hg}]$')
hold on

plot(1e6*tau_vals, stern_vollmer_func(tau_vals), 'b--', 'DisplayName', 'Stern-Vollmer')
ylim([min(O2_vals), max(O2_vals)])
legend('show', 'location', 'northeast');

save_fig(['O2_titration', suffix])

end

