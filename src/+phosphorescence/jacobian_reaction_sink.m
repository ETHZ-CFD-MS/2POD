function J_R = jacobian_reaction_sink(PT, O2, alpha, sim_params)
%JACOBIAN_REACTION_SINK Compute the Jacobian of the reaction term for P^T, O2
%   and singlet oxygen.
%
%   Compute the jacobian of the reaction term between P^T, O2 and O2^* 
%   (singlet oxygen) in the reduced equations for phosphorescence decays.
%
%   Inputs:
%       PT  = concentration of probe in triplet state (N x 1)
%       O2  = concentration of oxygen in ground state (N x 1)
%       alpha = excitation rate [s^-1]
%       sim_params = instance of SimulationParameters
%
%   Output:
%       J_R = jacobian of reaction rate (3N x 3N)

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
kr = sim_params.kr;
kqpr = sim_params.kqpr;

N = numel(PT);

R_11 = spdiags(-(alpha + kp + kq*O2), 0, N, N);
R_12 = spdiags(-kq*PT, 0, N, N);
R_13 = spdiags(zeros(N,1), 0, N, N);
R_21 = spdiags(-kq*O2, 0, N, N);
R_22 = spdiags(-kq*PT, 0, N, N);
R_23 = spdiags((kd + kqpr)*ones(N,1), 0, N, N);
R_31 = spdiags(kq*O2, 0, N, N);
R_32 = spdiags(kq*PT, 0, N, N);
R_33 = spdiags(-(kd + kqpr + kr)*ones(N,1), 0, N, N);

J_R = [R_11 R_12 R_13; ...
       R_21 R_22 R_23; ...
       R_31 R_32 R_33];
