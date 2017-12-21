function n_photon = n_photon_for_PO2_accuracy(sigma_PO2, sim_params, bin_width)
%N_PHOTON_FOR_PO2_ACCURACY Compute the number of photons required to
%   achieve a given accuracy in PO2 estimation.
%
%   Compute the number of photons required to achieve a given accuracy in a
%   PO2 measurement based on the Stern-Vollmer equation and a single
%   exponential fit to the phosphorescence decay.
% 
%   The accuracy of the measurement is expressed using SIGMA_PO2, the 
%   standard deviation of the PO2 estimate.
%
%   Inputs:
%       SIGMA_PO2  = standard deviation of the PO2 measurement to achieve [mmHg]
%       SIM_PARAMS = instance of SimulationParameters
%       BIN_WIDTH  = bin width for photon collection [s]
%
%   Output:
%       N_PHOTON   = number of required photons

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

import phosphorescence.n_photon_for_lifetime_accuracy
import utils.mmHgToMolar

% transform units from mmHg to molar
O2 = mmHgToMolar(sim_params.PO2, sim_params.temp);
sigma_O2 = mmHgToMolar(sigma_PO2, sim_params.temp);

% compute the derivative of the Stern-Vollmer equation
kq = sim_params.kq;
kp = sim_params.kp;
dtaudP = -kq/(kp + kq*O2)^2;

% based on a linearization, compute the standard deviation of tau that is
% to be achieved.
tau = 1/(kp + kq*O2);
sigma_tau = abs(dtaudP)*sigma_O2;

n_photon = n_photon_for_lifetime_accuracy(sigma_tau, tau, sim_params.t_coll, bin_width);
