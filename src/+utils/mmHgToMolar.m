function C_O2 = mmHgToMolar(PO2, T)
%MMHGTOMOLAR Convert oxygen partial pressure in water to molar concentration.
%
%   Inputs:
%       PO2  = oxygen partial pressure [mmHg]
%       T    = temperature [K]
%
%   Output:
%       C_O2 = oxygen concentration [M]

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

import utils.mmHgToPa
import utils.solubility_oxygen

P_atm = 101325; % partial pressure of oxygen at standard conditions [Pa]

% Molar mass of water
M_H2O = 18.01528; % [g mol^-1]

% Density of water in standard conditions
rho_H2O = 1e3; % [kg m^-3]

% water concentration [mol L^-1] = [M] = [kg m^-3 g^-1 mol]
C_H20 = rho_H2O/M_H2O; 

% Molar concentration of oxygen dissolved in water at standard pressure
x_g = solubility_oxygen(T); % molar fraction of oxygen
C_O2_std = x_g/(1-x_g) * C_H20;

% Determine solubility coefficient alpha [M Pa^-1] using data at standard
% pressure. alpha is given by alpha = C/P
alpha = C_O2_std/P_atm;

% Convert PO2 to Pascals
P_Pa = mmHgToPa(PO2);

% Find molar concentration using Henry's law
C_O2 = alpha * P_Pa;


