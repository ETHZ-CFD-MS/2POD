function surface_plot(phi, grid, z_scaling)
%SURFACE_PLOT Pseudocolor plot of a field defined on a CartesianGrid.
%
%   Plot a quantity phi defined on a mesh grid with cell centers given in 
%   an object of type CartesianGrid.
%
%   Inputs:
%       PHI  = field to plot (grid.Nx() x grid.Ny())
%       GRID = object of type CartesianGrid
%       Z_SCALING = scaling factor for the field phi

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

if nargin < 3
    z_scaling = 1;
end

rc = grid.xCenter();
zc = grid.yCenter();

Nr = grid.Nx();
Nz = grid.Ny();

phia = reshape(phi, Nr, Nz);

% plot array
set(0,'DefaultTextInterpreter', 'latex')
h = pcolor(1e6*rc, 1e6*zc, z_scaling*phia');
% h = surf(1e6*rc, 1e6*zc, z_scaling*phia');
% view(2);
% set(gcf,'Renderer','painters'); % workaround so t
set(h, 'EdgeColor', 'none');
colorbar('TickLabelInterpreter', 'latex')
xlabel('$r \; [\mu \mathrm{m}]$')
ylabel('$z \; [\mu \mathrm{m}]$')
set(gca, 'TickLabelInterpreter', 'latex');
box on
% drawnow
