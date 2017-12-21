function x_g = solubility_oxygen(T)
%SOLUBILITY_OXYGEN Compute the solubility of oxygen in water.
%
%   Compute the solubility of oxygen in water as a function of temperature.
%   Here the solubility is the molar fraction of the gas, i.e.
%       x_g = n_g/(n_g + n_s)
%   where n_g is the number of moles of gas and n_s the number of moles of
%   solvent. The formula is valid at an oxygen partial pressure of 1.013 bar.
%
%   Input:
%       T = temperature [K]
%
%   Output:
%       X_G = oxygen solubility
%
% The formula is taken from p. 293 in
% Fogg, P. G., and Gerrard, W. (1991) Solubility of Gases in Liquids: A
% Critical Evaluation of Gas/Liquid Systems in Theory and Practice. Wiley
% New York.
% This fit is valid in the range from 273 to 333 K.

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

x_g = exp(-171.2542 + 8391.24./T + 23.24323*log(T));

