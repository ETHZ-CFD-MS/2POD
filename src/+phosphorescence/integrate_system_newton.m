function [PT, O2, O2s] = integrate_system_newton(PT, O2, O2s, dt, A, q, alpha, sim_params)
%INTEGRATE_SYSTEM_NEWTON Integrate the equation system for P^T and O2 with diffusion.
%
%   Integrate implicitly the system of equations for P^T and O_2 over one 
%   time step DT using a Newton iteration for the nonlinear reaction term.
%
%   If there is no permanent singlet oxygen removal, the system is reduced 
%   by using that the total oxygen concentration stays constant.
%
%   Inputs:
%       PT    = concentration of probe in triplet state (N x 1)
%       O2    = concentration of oxygen in ground state (N x 1)
%       O2s   = concentration of oxygen in singlet state (N x 1)
%       DT    = time step [s]
%       A     = matrix for discretized Laplacian (2N x 2N or 3N x 3N)
%       Q     = source term for the BC from the discretized Laplacian (2N x 1 or 3N x 1)
%       ALPHA = excitation rate [s^-1]
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

% TODO: test or remove this function

import phosphorescence.jacobian_reaction
import phosphorescence.jacobian_reaction_sink
import phosphorescence.reaction
import phosphorescence.reaction_sink

N = numel(PT);

% prepare matrices and vectors
if (use_sink)
    Id = speye(2*N); % identity matrix
    Y = [PT; O2];
else
    Id = speye(3*N); % identity matrix
    Y = [PT; O2; O2s];   
end

Y_old = Y;
dY    = Y;

while norm(dY)/norm(Y_old) > sim_params.rel_tol
    %  jacobian of reaction term
    if sim_params.no_oxygen_removal()
        J_R = jacobian_reaction(PT, O2, alpha, sim_params);
    else
        J_R = jacobian_reaction_sink(PT, O2, alpha, sim_params);
    end
    
    % whole jacobian
    J = 1/dt*Id - sparse(A) - J_R;
    
    % right-hand side in Newton iteration
    if sim_params.no_oxygen_removal()
        F = 1/dt*(Y-Y_old) - A*Y - q - reaction(PT, O2, alpha, sim_params);
    else
        F = 1/dt*(Y-Y_old) - A*Y - q - reaction_sink(PT, O2, O2s, alpha, sim_params);
    end
    
    % computation of increment
    dY = -(J\F);
    
    % extraction of results
    Y = Y + dY;
    
    PT = Y(1:N);
    O2 = Y( N+1 : 2*N );
    
    if sim_params.no_oxygen_removal()
        O2s = sim_params.S_O2() - O2;
    else
        O2s = Y( 2*N+1 : 3*N );
    end
end
