function set_PO2_right_y_axis(PO2_vals, sim_params)
%SET_PO2_RIGHT_Y_AXIS Set a right y-axis with given PO2 values.
%
%   Set a right y-axis with PO2 values at the coordinates associated to decay
%   times on the left y-axis, based on Stern-Vollmer curve parameters.
%
%   Inputs:
%       PO2_VALS: PO2 values to display on the right y-axis
%       TAU_LIMS: 2x1 array with axis limits for tau
%       SIM_PARAMS: instance of SimulationParameters

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

import utils.solubility_oxygen

T = sim_params.temp;
inv_stern_vollmer_func = @(PO2) (1./(sim_params.kp + sim_params.kq*mmHgToMolar(1, T)*PO2));

tau_lims = ylim;

yyaxis right
ylabel('$\mathrm{PO}_2\;[\mathrm{mm\,Hg}]$')
PO2_ticks = zeros(numel(PO2_vals), 1);
PO2_tick_labels = cell(numel(PO2_vals), 1);
for i = 1:numel(PO2_vals)
    tau_val = inv_stern_vollmer_func(PO2_vals(i));
    PO2_ticks(i) = (1e6*tau_val - tau_lims(1))/(tau_lims(2) - tau_lims(1));
    PO2_tick_labels{i} = sprintf('%2.0f', PO2_vals(i));
end
yticks(PO2_ticks)
yticklabels(PO2_tick_labels)
set(gca, 'ycolor', 'k')
yyaxis left
set(gca, 'ycolor', 'k')

end
