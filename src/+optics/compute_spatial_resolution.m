function resolution = compute_spatial_resolution(PT, grid)
%COMPUTE_SPATIAL_RESOLUTION Compute the resolution of the excitation volume.
%
%   Compute the spatial resolution based on the probe concentration in
%   triplet state
%
%   Inputs:
%       PT = concentration of probe in the triplet state (N x 1)
%       GRID = object of type CartesianGrid
%
%   Output:
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

import optics.ResolutionData

alpha = 0.5;       % quantile for evaluation of spatial resolution
n_interp = 1001;   % number of points for interpolation

Nr = grid.Nx();
Nz = grid.Ny();

% reshape PT into a 2D array
PTa = reshape(PT, Nr, Nz);
S = PTa/max(PTa(:));

% computation of resolution in x-direction
xx = linspace(grid.xMin, grid.xMax, n_interp);
S_interp = interp1(grid.xCenter(), S(:, 1), xx, 'pchip');
i_last = find(S_interp >= alpha, 1, 'last');
x_res_focal = 2*xx(i_last);

x_res_max = 0;
for i = 1:Nz
    S_interp = interp1(grid.xCenter(), S(:, i), xx, 'pchip');
    i_last = find(S_interp >= alpha, 1, 'last');
    if numel(i_last) == 1
        x_res_max = max(x_res_max, 2*xx(i_last));
    end
end

% computation of resolution in z-direction
zz = linspace(grid.yMin, grid.yMax, n_interp);
S_interp = interp1(grid.yCenter(), S(1, :), zz, 'pchip');
i_last = find(S_interp >= alpha, 1, 'last');
z_res_central = 2*zz(i_last);

z_res_max = 0;
for i = 1:Nr
    S_interp = interp1(grid.yCenter(), S(i, :), zz, 'pchip');
    i_last = find(S_interp >= alpha, 1, 'last');
    if numel(i_last) == 1
        z_res_max = max(z_res_max, 2*zz(i_last));
    end
end

resolution = ResolutionData(x_res_max, x_res_focal, ...
                            z_res_max, z_res_central);
