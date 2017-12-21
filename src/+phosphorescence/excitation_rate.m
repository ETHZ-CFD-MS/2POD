function alpha = excitation_rate(I, sim_params)
%EXCITATION_RATE Compute the excitation rate of the phosphorescent probe.
% 
%   Compute the excitation rate alpha as a function of the point-spread
%   function and laser properties.
%
%   Inputs:
%       I          = normalized point-spread function (Nr+1 x Nz+1)
%       SIM_PARAMS = instance of SimulationParameters
%
%   Output:
%       ALPHA      = excitation rate [s^-1] (N x 1)

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

import plot.profile_plot

rf = sim_params.grid.xFaces();
Nz = sim_params.grid.Ny();

lambda  = sim_params.wavelength;
P       = sim_params.Pm;
f       = sim_params.frequency;
t_pulse = sim_params.t_pulse;

attenuation_function = @(l, z) exp(-z/l);
scatt_length_ex = sim_params.scatt_length_ex;
scatt_depth = sim_params.scatt_depth;
attenuation_factor = attenuation_function(scatt_length_ex, scatt_depth);

% other constants
c = 2.99792e8; % speed of light [m s^-1]
h = 6.626e-34; % Planck's constant [J s]

% number of photons per pulse
m = attenuation_factor*P*lambda/(h*c*f);

% compute excitation rate
dr = sim_params.grid.deltaX();
dr_mat = repmat(dr', 1, Nz);
rf_mat = repmat(rf', 1, Nz);
% radially weighted intensity at cell centers (using bilinear interpolation)
% The factor 2*pi is present because of the PSF normalization.
Ic = 0.25*dr_mat.*2*pi.*(rf_mat(1:end-1,:).*I(1:end-1,1:end-1) + ...
                         rf_mat(1:end-1,:).*I(1:end-1,2:end)   + ... 
                         rf_mat(2:end,:).*I(2:end,1:end-1)     + ...
                         rf_mat(2:end,:).*I(2:end,2:end));

% profile_plot(rc, zc, I_bar/max(I_bar(:)), 'r', 'Energy density [AU]')
% profile_plot(rc, zc, I_bar/max(I_bar(:)), 'z', 'Energy density [AU]')
                     
% intensity per cell face area [m^-2]
Ic_per_area = Ic./repmat(pi*(rf(2:end).^2 - rf(1:end-1).^2)', 1, Nz);

% excitation rate
alpha = sim_params.sigma2*(Ic_per_area*m/t_pulse).^2;

% return vectorized array
alpha = alpha(:);