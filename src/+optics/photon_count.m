function n_photon = photon_count(t, J, t_on)
%PHOTON_COUNT Integrate the number of emitted photon.
%
%   Estimate the number of collected photons by integrating the signal 
%   intensity over the off-phase.
%   That is, J is only integrated for time values greater than t_on.
%
%   Input:
%       T    = times (1 x Nt)
%       J    = signal in mol s^-1 (1 x Nt)
%       T_ON = time from which to fit
%
%   Output:
%       N_PHOTON = number of collected photons

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

idx_off = (t > t_on);
t_off   = t(idx_off);
J_off   = J(idx_off);

n_photon = trapz(t_off, J_off);
