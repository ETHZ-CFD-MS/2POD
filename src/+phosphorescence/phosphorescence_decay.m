function [J, tt, resolution] = phosphorescence_decay(sim_params)
%PHOSPHORESCENCE_DECAY Compute phosphorescence decays with O2 diffusion.
%
%   Compute phosphorescence signal for given concentrations of oxygen,
%   two-photon enhanced probe, with oxygen diffusion and, optionally, removal
%   of singlet oxygen.
%
%   Input:
%       SIM_PARAMS = instance of SimulationParametersDiffusion
%
%   Outputs:
%       J   = phosphorence signal (n_gates x 1) cell
%       TT  = times for phosphorescence (n_gates x 1) cell
%       RESOLUTION = cell with instances of ResolutionData

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

import diffusion.diffusion_matrix_cylindrical
import diffusion.set_diffusion_matrix_BC
import geometry.total_concentration_cylindrical
import optics.collect_signal
import optics.compute_PSF
import optics.compute_spatial_resolution
import phosphorescence.excitation_rate
import phosphorescence.integrate_system_ode
import plot.surface_plot
import utils.mmHgToMolar

%% Set parameters
BC = 'Dirichlet';
plot_results = 1;
if plot_results
    figure('units', 'inches', 'position', [0 0 12 7.2], 'PaperPosition', [0 0 8 5.6]);
end

%% Initialization of matrices and fields
N = sim_params.grid.NCells();
% Create matrix for the discretized Laplacian
A_O2 = diffusion_matrix_cylindrical(sim_params.grid, sim_params.D_O2);
[A_O2,  q_O2]  = set_diffusion_matrix_BC(sim_params.grid, A_O2, sim_params.D_O2, BC, sim_params.S_O2);
[A_O2s, q_O2s] = set_diffusion_matrix_BC(sim_params.grid, A_O2, sim_params.D_O2, BC,    0);

if (sim_params.no_oxygen_removal())
    A = [sparse(N, N)  sparse(N, N); ...
         sparse(N, N)  A_O2        ];
    q = [zeros(N, 1); q_O2];
else 
    A = [sparse(N, N)  sparse(N, N)  sparse(N, N) ; ...
         sparse(N, N)  A_O2          sparse(N, N) ; ...
         sparse(N, N)  sparse(N, N)  A_O2s  ];
    q = [zeros(N, 1); q_O2; q_O2s];
end

% Initialize fields
PT  = zeros(N, 1);
O2  = sim_params.S_O2*ones(N, 1);
O2s = zeros(N, 1);

tt = cell(sim_params.n_gates, 1);
J = cell(sim_params.n_gates, 1);
PT_central = cell(sim_params.n_gates, 1);
resolution = cell(sim_params.n_gates, 1);

sum_O2_before_on_phase = zeros(sim_params.n_gates, 1);
sum_O2_after_off_phase = zeros(sim_params.n_gates, 1);

%% Compute photon flux and excitation rate
I = compute_PSF(sim_params);
alpha = excitation_rate(I, sim_params);

%% Main loop: loop over gates
for i_gate = 1:sim_params.n_gates
    
    fprintf('\nStarting gate %i ===============================\n', i_gate)
    if sim_params.oxygen_removal
        sum_O2_before_on_phase(i_gate) = total_concentration_cylindrical(O2+O2s, sim_params.grid);
        fprintf('Total oxygen concentration before on-phase: %g mol\n', ...
            sum_O2_before_on_phase(i_gate))
    end
        
    %% Integrate over on-phase
    t = 0;
    alpha_bar = alpha*sim_params.t_pulse*sim_params.frequency;
    tspan = [t , t + sim_params.on_time];
    [t_int, PT, O2, O2s] = integrate_system_ode(tspan, PT, O2, O2s, ...
        A, q, alpha_bar, sim_params);
    tt{i_gate} = t_int(2:end);
    J{i_gate} = zeros(size(tt{i_gate}));
    PT_central{i_gate} = PT(1, 2:end);
    for j = 1:numel(t_int)-1
        J{i_gate}(j) = collect_signal(PT(:,j+1), sim_params.grid, ...
            sim_params.kp, sim_params.phip, sim_params.chi);
    end
    t = t + sim_params.on_time;
    PT  = PT(:,end);
    O2  = O2(:,end);
    O2s = O2s(:,end);
    
    resolution{i_gate} = compute_spatial_resolution(PT, sim_params.grid);
    
    %% Plot after on-phase
    if plot_results
        subplot(2, 2, 1)
        surface_plot(PT, sim_params.grid, 1e6)
        title(sprintf('$P^T$ after on-phase'))
        subplot(2, 2, 2)
        surface_plot(O2, sim_params.grid, 1/mmHgToMolar(1, sim_params.temp))
        title(sprintf('Ground state O$_2$ after on-phase'))
    end
    
    %% Integrate over collection period
    tspan = [t , t + sim_params.t_coll];
    [t_int, PT, O2, O2s] = integrate_system_ode(tspan, PT, O2, O2s, A, q, 0, ...
                                sim_params);
    
    for i = 1:numel(t_int)-1  % t_int also contains the first time step of the integration
        tt{i_gate}(end+1) = t_int(i+1);
        J{i_gate}(end+1) = collect_signal(PT(:,i+1), sim_params.grid, ...
            sim_params.kp,  sim_params.phip, sim_params.chi);
        PT_central{i_gate}(end+1) = PT(1,i+1);
    end
    
    t = t + sim_params.t_coll;
    
    PT  = PT(:,end);
    O2  = O2(:,end);
    O2s = O2s(:,end);
    
    if sim_params.oxygen_removal
        sum_O2_after_off_phase(i_gate) = total_concentration_cylindrical(O2+O2s, sim_params.grid);
        fprintf('Oxygen loss during last gate: %g mol\n', ... 
            sum_O2_before_on_phase(i_gate) - sum_O2_after_off_phase(i_gate))

    end
    
    %% Plot after off-phase
    if plot_results
        subplot(2, 2, 3)
        plot(1e6*tt{i_gate}, J{i_gate}, '-b')
        xlabel('$t\;[\mu \mathrm{s}]$')
        xlim([1e6*min(tt{i_gate}) 1e6*max(tt{i_gate})])
        ylabel('$J\;[\mathrm{photon/s}]$')
        title('Collected intensity')
        set(gca, 'TickLabelInterpreter', 'latex');
        set(gca, 'TickLabelInterpreter', 'latex');
        
        subplot(2, 2, 4)
        surface_plot(O2, sim_params.grid, 1/mmHgToMolar(1, sim_params.temp))
        title(sprintf('Ground state O$_2$ after off-phase'))
        % ensure that the color scale axis is the same than in the plot
        % above
        subplot(2, 2, 2)
        clim = caxis;
        subplot(2, 2, 4)
        caxis(clim)
        drawnow
    end
end

