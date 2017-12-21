classdef ResolutionData
%RESOLUTIONDATA Encapsulate data for a microscope spatial resolution.

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

   properties (Access = public)
       x_res         % Maximal resolution parallel to the focal plane
       x_res_focal   % Resolution on the focal plane
       z_res         % Maximal resolution in the axial direction
       z_res_central % Resolution along the microscope z-axis
       
   end
   
   methods
       function obj = ResolutionData(x_res, x_res_focal, z_res, z_res_central)
           % Constructor by components
           obj.x_res = x_res;
           obj.x_res_focal = x_res_focal;
           obj.z_res = z_res;
           obj.z_res_central = z_res_central;
       end
   end
   
end
