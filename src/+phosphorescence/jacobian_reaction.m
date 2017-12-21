function J_R = jacobian_reaction(PT, O2, alpha, sim_params)
%JACOBIAN_REACTION Compute the Jacobian of the reaction term for P^T and O2.
%
%   Compute the jacobian of the reaction term between P^T and O2 in the
%   equations for phosphorescence decays.
%   The top left corner of the jacobian corresponds to P^T.
%   The bottom right corner of the jacobian corresponds to O2.
%
%   Inputs:
%       PT         = concentration of probe in triplet state (N x 1)
%       O2         = concentration of oxygen in ground state (N x 1)
%       alpha      = excitation rate [s^-1]
%       sim_params = instance of SimulationParameters
%
%   Output:
%       J_R        = jacobian of reaction rate (2N x 2N)

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

kp = sim_params.kp;
kq = sim_params.kq;
kd = sim_params.kd;

N = numel(PT);

R_11 = spdiags(-(alpha + kp + kq*O2), 0, N, N);
R_12 = spdiags(-kq*PT, 0, N, N);
R_21 = spdiags(-kq*O2, 0, N, N);
R_22 = spdiags(-(kd + kq*PT), 0, N, N);

J_R = [R_11 R_12; ...
       R_21 R_22];
