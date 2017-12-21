function I = compute_PSF(sim_params, cache_result, cache_filename)
%COMPUTE_PSF Compute the microscope point spread function.
%
%   Compute values of the point-spread function on the faces of a  2D grid 
%   in cylindrical coordinates (r, z).
%   This yields the PSF for one-photon microscopy. It is normalized so that
%   the integral of the PSF over each z-plane is one. More precisely, the
%   normalization is done so that
%
%   \int_0^{2\pi} \int_0^{\infty} I(z, r) r dr d\theta = 1.
%
%   Beware that a factor 2\pi is included in this normalization.
%
%   Inputs:
%       SIM_PARAMS = instance of SimulationParameters
%       CACHE_RESULT = boolean, whether to cache results or not if input is the
%                same
%       CACHE_FILENAME = file name of cache file
%
%    Output:
%       I = PSF values (Nr+1 x Nz+1)

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

import optics.PSF_bessel

if nargin < 2
    cache_result = 1;
end
if nargin < 3
    cache_filename = 'PSF.mat';
end

if cache_result && exist(cache_filename, 'file') == 2
    cached_var_names = {'sim_params', 'I'};
    S = load(cache_filename, cached_var_names{:});
    [~, msgid] = lastwarn;
    if strcmp(msgid, 'MATLAB:load:cannotInstantiateLoadedVariable')
        warning('Could not properly load cached results. Recomputing PSF...')
    else
        if S.sim_params.grid == sim_params.grid ...
                && S.sim_params.wavelength == sim_params.wavelength ...
                && S.sim_params.NA == sim_params.NA ...
                && S.sim_params.n0 == sim_params.n0 ...
                && strcmp(S.sim_params.PSF_type, sim_params.PSF_type)
            I = S.I;
            return
        end
    end
end

grid = sim_params.grid;
rf = grid.xFaces();
zf = grid.yFaces();
Nr = grid.Nx();
Nz = grid.Ny();

lambda  = sim_params.wavelength;
NA      = sim_params.NA;
n0      = sim_params.n0;
PSF_type = sim_params.PSF_type;

I = zeros(Nr+1, Nz+1);

switch PSF_type
    case 'gaussian'
        % center of gaussian
        r0 = 0;
        z0 = 0;
        
        % formulas from "Gaussian approximations of fluorescence microscope 
        % point-spread function models." by Zhang et al. (2008, Applied
        % Optics)
        sigma_r = 0.21*lambda/NA; % Table 1, paraxial WFFM (L^{\infty} constraint)
        sigma_z = 2*sqrt(6)*n0*lambda/(2*pi*NA^2);
        
        [Z, R] = meshgrid(zf, rf);
        
        I = exp(-0.5*((R-r0).^2./sigma_r^2 ...
                     + (Z-z0).^2./sigma_z^2));
                 
        % compute integral on plane z = 0.
        dr = rf(2) - rf(1);
        iz = 1;
        intI = 2*pi*dr*sum(rf'.*I(:,iz));
        I = I/intI;
              
    case 'bessel'
        for j = 1:Nz+1
            I(:,j) = PSF_bessel(zf(j), rf, lambda, NA, n0);
        end
        
        % normalize I by the integral over the plane z=0
        z_level = 0;
        z_sum_r_small = 2*pi*integral(@(r) r*PSF_bessel(z_level, r, lambda, NA, n0), 0, 1e-5, ...
            'ArrayValued', true, 'AbsTol', 1e-12, 'RelTol', 1e-8);
        z_sum_r_large = 2*pi*integral(@(r) r*PSF_bessel(z_level, r, lambda, NA, n0), 1e-5, 1e-4, ...
            'ArrayValued', true, 'AbsTol', 1e-12, 'RelTol', 1e-8);
        z_sumI = z_sum_r_small + z_sum_r_large;
        I = I/z_sumI;
end
% I_center = 0.25*(I(1:end-1, 1:end-1) + I(2:end, 1:end-1) + I(1:end-1, 2:end) + I(2:end,2:end));
% surface_plot(I_center, grid)

if cache_result
    save(cache_filename, 'sim_params', 'I')
end
