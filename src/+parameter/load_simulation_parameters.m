function data = load_simulation_parameters(filename)
%LOAD_SIMULATION_PARAMETERS Create a SimulationParameters instance from a file.
%
% The required file format is json with the following syntax:
%
% {
%     "paramName1": val1,
%     "paramName2": val2,
%     ...
% }
%
% Some keys are treated specially after reading:
%   - the unit of kq is changed from [mmHg^-1 s^-1] to [M^-1 s^-1]
%   - the grading functions for the Cartesian (keys "r_grading" and
%     "z_grading") are, if present, evaluated. If not present, they are
%     assigned the constant function equal to one as a default value.
%
% Adrien Luecker, Institute of Fluid Dynamics, ETH Zurich
% May 2014 - September 2017

import utils.mmHgToMolar

if nargin < 1
    filename = 'params.json';
end

data = loadjson(filename);

% convert [mmHg^-1 s^-1] to [M^-1 s^-1]
data.kq = data.kq/mmHgToMolar(1, data.temp);

% test function handles for mesh grading
if isfield(data, 'r_grading')
    data.r_grading = eval(data.r_grading);
else
    data.r_grading = @(r) 1;
end

if isfield(data, 'z_grading')
    data.z_grading = eval(data.z_grading);
else
    data.z_grading = @(z) 1;
end

end