function P_Pa = mmHgToPa(P_mmHg)
%MMHGTOPA Convert pressure values from mmHg to Pa. Uses standard atmosphere.
%  
%   Input:
%       P_MMHG  Oxygen partial pressure in mmHg
% 
%   Output:
%       P_PA    Oxygen partial pressure in Pa

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

if nargin < 1
    P_mmHg = 1;
end

P_Pa = P_mmHg*101325/760;
