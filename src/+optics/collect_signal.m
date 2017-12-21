function J = collect_signal(PT, grid, kp, phip, chi)
%COLLECT_SIGNAL Collect the phosphorescent signal emitted on the grid.
%
%   COLLECT_SIGNAL(PT, grid, kp, phip, chi) computes the collected
%   phosphorescence signal by the probe in triplet state, given probe
%   parameters.
%
%   Inputs:
%       PT = concentration of probe in the triplet state (N x 1)
%       GRID = object of type CartesianGrid
%       KP = phosphorescence decay rate [s^-1]
%       PHIP = phosphorescence quantum yield
%       CHI = collection efficiency
%
%   Output:
%       J  = collected phosphorescence signal in photon/s

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

N_A = 6.022140857e23; % Avogadro number

rf = grid.xFaces();
zf = grid.yFaces();

Nr = grid.Nx();
Nz = grid.Ny();

% reshape PT into a 2D array
PTa = reshape(PT, Nr, Nz);

% compute geometric quantities
dz = diff(zf);

dza = repmat(dz , Nr, 1);
rpa = repmat(rf(2:end)', 1, Nz);
rma = repmat(rf(1:end-1)', 1, Nz);

% compute average of P^T in domain
% Factor 2: account for symmetry in z-direction
% Factor 1e3: since we use mol l^-1 and m^3
J = 2*chi*N_A*kp*phip*1e3*sum(sum(pi*(rpa.^2-rma.^2).*dza.*PTa));
