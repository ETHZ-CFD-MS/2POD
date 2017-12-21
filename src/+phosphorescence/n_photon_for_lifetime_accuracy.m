function n_photon = n_photon_for_lifetime_accuracy(sigma_tau, tau, T, bin_width)
%N_PHOTON_FOR_LIFETIME_ACCURACY Compute the number of photons required to
%   achieve a given accuracy in lifetime estimation.
%
% Compute the number of photons required to achieve a given accuracy in a
% lifetime estimation using a single exponential decay. The accuracy of the
% measurement is expressed using SIGMA_TAU, the standard deviation of the
% lifetime estimate.
%
%   Inputs:
%       SIGMA_TAU = standard deviation of the estimate to achieve [s]
%       TAU       = fitted lifetime [s]
%       T         = duration of the collection period [s]
%       BIN_WIDTH = bin width for photon collection [s]
%
%   Output:
%       N_PHOTON  = number of required photons

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

import phosphorescence.variance_lifetime_estimate

k = round(T/bin_width);
n_photon = variance_lifetime_estimate(tau, T, k)/sigma_tau^2;
