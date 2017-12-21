function profile_plot(rc, zc, phi, coordinate, ylabeltext)
%PROFILE_PLOT Plot a profile of a field on a grid in cylindrical coordinates.
%
% Plot a profile of quantity phi define on a meshgrid with cell centers given by rc
% and zc.
%
%   Inputs:
%       RC  Cell center coordinates in radial direction
%       ZC  Cell center coordinates in axial direction
%       PHI Field defined on a meshgrid with dimensions numel(RC) x numel(ZC)
%       COORDINATE  Name of coordinate along which to plot ('r' or 'z')
%       YLABELTEXT  Y-axis label text

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

if nargin < 4
    coordinate = 'r';
    ylabeltext = '';
end

Nr = numel(rc);
Nz = numel(zc);

phia = reshape(phi, Nr, Nz);

figure

if strcmp(coordinate, 'r')
    plot(rc, phia(:,1))
    xlabel('r [um]')
elseif strcmp(coordinate, 'z')
    plot(zc, phia(1,:))
    xlabel('z [um]')
end

ylabel(ylabeltext);
