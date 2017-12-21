function sumF = total_concentration_cylindrical(F, grid)
%TOTAL_CONCENTRATION_CYLINDRICAL Compute the integral of a field on a CartesianGrid
%
%   SUMF = TOTAL_CONCENTRATION_CYLINDRICAL(F, grid) returns the integrated
%   value in cylindrical coordinates of the field F defined on the 
%   CartesianGrid instance grid.
%
%   Inputs:
%      F - field [M] (N x 1)
%      grid - instance of CartesianGrid
%
%   Output:
%      sumF - sum of the field F [mol]

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

rf = grid.xFaces();
zf = grid.yFaces();

Nr = grid.Nx();
Nz = grid.Ny();

% reshape F into a 2D array
Fa = reshape(F, Nr, Nz);

% transform unit of F from [mol l^-1] to [mol m^-3]
Fa = 1e3*Fa;

% compute geometric quantities
dz = diff(zf);

dza = repmat(dz , Nr, 1);
rpa = repmat(rf(2:end)', 1, Nz);
rma = repmat(rf(1:end-1)', 1, Nz);

sumF = sum(sum(pi*(rpa.^2-rma.^2).*dza.*Fa));
