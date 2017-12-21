function [J, tt, resolution] = phosphorescence_decay_fixed_O2(sim_params)
%PHOSPHORESCENCE_DECAY_FIXED_O2 Compute phosphorescence decays with fixed O2.
%
% Compute phosphorescence signal for given concentrations of oxygen,
% two-photon enhanced probe and laser properties, with the assumption that
% the ground state oxygen concentration is constant.
%
%   Input:
%       SIM_PARAMS = instance of SimulationParameters
%
%   Outputs:
%       J   = phosphorence signal (Nt x 1) array
%       TT  = times for phosphorescence  (Nt x 1) array
%       RESOLUTION = instance of ResolutionData

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

import optics.collect_signal
import optics.compute_PSF
import optics.compute_spatial_resolution
import phosphorescence.excitation_rate
import plot.surface_plot
import utils.mmHgToMolar

%% Set parameters
S_O2 = mmHgToMolar(sim_params.PO2, sim_params.temp); % initial oxygen concentration [M]
S_P = sim_params.S_P;
plot_results = 0;

n_dt_off = 100;
n_dt_on = 50;

%% Initialization of fields
PT  = zeros(sim_params.grid.NCells(), 1);

dt_off = sim_params.n_pulse/(sim_params.frequency*n_dt_off);
dt_on = sim_params.t_coll/n_dt_on;
tt = zeros(n_dt_off + n_dt_on + 1, 1);
J  = zeros(n_dt_off + n_dt_on + 1, 1);

%% Compute photon flux and excitation rate
I = compute_PSF(sim_params);
alpha = excitation_rate(I, sim_params);

%% Integrate over on-phase
tt(1:n_dt_off+1) = 0:dt_off:dt_off*n_dt_off;
J(1) = collect_signal(PT, sim_params.grid, sim_params.kp, sim_params.phip, ...
    sim_params.chi);
k_tot = sim_params.kp + S_O2*sim_params.kq;
pulse_integration = 0;
if pulse_integration
    for i = 1:sim_params.n_pulse
        % Phase 1: integrate over femtosecond pulse
        % Use that the solution of df/dt = a + b*f is
        %        f = (a/b + f(0))*e^(bt) - a/b
        % with a = alpha*S_P and b = -alpha
        PT = (-S_P + PT).*exp(-alpha*t_pulse) + S_P;
        
        % Phase 2: integrate between femtosecond pulse (alpha = 0, phosphorescence only)
        PT = PT.*exp(-k_tot*dt_off);
        J(i+1) = collect_signal(PT, sim_params.grid, sim_params.kp, ...
            sim_params.phip, sim_params.chi);
    end
else
    alpha_bar = alpha*sim_params.t_pulse*sim_params.frequency;
    for i = 1:n_dt_off
        delta_t = i*dt_off;
        PT = (alpha_bar*S_P)./(alpha_bar + k_tot).*(1 - exp(-(k_tot + alpha_bar)*delta_t));
        J(i+1) = collect_signal(PT, sim_params.grid, sim_params.kp, ...
            sim_params.phip, sim_params.chi);
    end
end

resolution = compute_spatial_resolution(PT, sim_params.grid);

if plot_results
    figure
    surface_plot(PT, sim_params.grid, 1e6)
    title(sprintf('$P^T$ after on-phase'))
end

%% Integrate over collection period
PT_intermediate = PT;
for i = 1:n_dt_on
    PT_intermediate = PT_intermediate.*exp(-k_tot*dt_on);
    tt(n_dt_off + i + 1) = tt(n_dt_off + i) + dt_on;
    J(n_dt_off + i + 1) = collect_signal(PT_intermediate, sim_params.grid, ...
        sim_params.kp, sim_params.phip, sim_params.chi);
end

PT = PT.*exp(-k_tot*sim_params.t_coll);

%% Plot after off-phase
if 0 && plot_results
    figure
    plot(1e6*tt, J, '-b')
    xlabel('$t\;[\mu \mathrm{s}]$')
    xlim([1e6*min(tt) 1e6*max(tt)])
    ylabel('$J\;[\mathrm{photon/s}]$')
    title('Collected intensity')
    set(gca, 'TickLabelInterpreter', 'latex');
end
