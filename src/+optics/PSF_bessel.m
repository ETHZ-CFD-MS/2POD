function I = PSF_bessel(z, r, lambda, NA, n0)
%PSF_BESSEL Compute the point spread function based on the Bessel function.
%
% The point-spread function (PSF) is computed using equations from 
% 1990-Sheppard-Image formation in two-photon fluorescence microscopy
% This is a one-photon PSF.
%
%   Input:
%       Z = coordinate in microscope z-axis
%       R = coordinate in microscope x-y plane (can be a vector)
%       LAMBDA = light wavelength [m]
%       NA = lens numerical aperture
%       N0 = refractive index of lens immersion medium
%
%   Output:
%       I = PSF profile (len(R) x 1)

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

k = 2*pi/lambda; % wave number

alpha = asin(NA/n0);
u = 4*k*sin(alpha/2)^2*z;
v = k*sin(alpha)*r(:);
%     u = k*NA^2*z;
%     v = k*NA  *r(:);
Ifun = @(rho) besselj(0, v*rho).*repmat(exp(-0.5*1i*u*rho.^2).*rho, numel(v), 1);
I = abs(2*integral(Ifun, 0, 1, 'ArrayValued', true, 'AbsTol', 1e-12, 'RelTol', 1e-8)).^2;
end
