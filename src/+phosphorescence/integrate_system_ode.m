function [t, PT, O2, O2s] = integrate_system_ode(tspan, PT, O2, O2s, A, q, ...
    alpha, sim_params)
%INTEGRATE_SYSTEM_ODE Integrate the equation system for P^T and O2 with diffusion.
%
%   Integrate the system of equations for P^T and O_2 over the given interval
%   TSPAN using explicit ODE integration.
%
%   If there is no permanent singlet oxygen removal, the system is reduced 
%   by using that the total oxygen concentration stays constant.
%
%   Inputs:
%       TSPAN = time interval (1 x 2 double)
%       PT    = concentration of probe in triplet state (N x 1)
%       O2    = concentration of oxygen in ground state (N x 1)
%       O2s   = concentration of oxygen in singlet state (N x 1)
%       A     = matrix for discretized Laplacian (2N x 2N or 3N x 3N)
%       Q     = source term for the BC from the discretized Laplacian (2N x 1 or 3N x 1)
%       ALPHA = excitation rate [s^-1] (N x 1)
%       SIM_PARAMS = instance of SimulationParametersDiffusion
%
%   Outputs:
%       PT    = updated concentration of probe in triplet state (N x 1)
%       O2    = updated concentration of oxygen in ground state (N x 1)
%       O2s   = updated concentration of oxygen in singlet state (N x 1)    

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

use_sink = sim_params.oxygen_removal();
y0 = assemble_vectors(PT, O2, O2s, use_sink);

options = odeset('Jacobian', @(t, y) jacobian(t, y, alpha, sim_params), ...
                  'RelTol', sim_params.rel_tol, ...
                  'AbsTol', sim_params.abs_tol);
[t, y] = ode45(@(t, y) odefun(t, y, A, q, alpha, sim_params), ...
               tspan, y0, options);
[PT, O2, O2s] = extract_results_from_vector(y', use_sink, sim_params.S_O2);

end

function dy = odefun(~, y, A, q, alpha, sim_params)

import phosphorescence.reaction
import phosphorescence.reaction_sink

use_sink = sim_params.oxygen_removal();
[PT, O2, O2s] = extract_results_from_vector(y, use_sink, sim_params.S_O2);

if (use_sink)
    dy = A*y + q + reaction_sink(PT, O2, O2s, alpha, sim_params);
else
    dy = A*y + q + reaction(PT, O2, alpha, sim_params);
end

end

function J = jacobian(~, y, alpha, sim_params)

import phosphorescence.jacobian_reaction
import phosphorescence.jacobian_reaction_sink

use_sink = sim_params.oxygen_removal();
[PT, O2, ~] = extract_results_from_vector(y, use_sink, sim_params.S_O2);
if (use_sink)
    J = jacobian_reaction_sink(PT, O2, alpha, sim_params);
else
    J = jacobian_reaction(PT, O2, alpha, sim_params);
end
end

function y = assemble_vectors(PT, O2, O2s, use_sink)

% prepare matrices and vectors
if (use_sink)
    y = [PT; O2; O2s];
else
    y = [PT; O2];
end

end

function [PT, O2, O2s] = extract_results_from_vector(y, use_sink, S_O2)

if use_sink
    N = size(y, 1)/3;
else
    N = size(y, 1)/2;
end

PT = y(1:N, :);
O2 = y( N+1 : 2*N ,:);

if (use_sink)
    O2s = y( 2*N+1 : 3*N , :);
else
    O2s = S_O2 - O2;
end

end
