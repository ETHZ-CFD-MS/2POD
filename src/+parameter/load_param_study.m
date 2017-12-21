function param_study = load_param_study(filename)
%LOAD_PARAM_STUDY Create a ParameterStudy instance from a file.
%
% The required file format is json with the following syntax:
%
% {
%    "paramName1": [val1, val2, val3, ...],
%    "paramName2": [vala, valb, valc, ...]
% }
%
% Alternatively, the parameter values can be given by a MATLAB expression
% enclosed in double quotes, such as:
%
%    "paramName1": "valMin:step:valMax"
%
% Adrien Luecker, Institute of Fluid Dynamics, ETH Zurich
% May 2014 - September 2017

import parameter.ParameterStudy

if nargin < 1
    filename = 'param_study.json';
end

data = loadjson(filename);
param_names = fieldnames(data);
values = struct2cell(data);

for i = 1:numel(values)
    if ischar(values{i})
        try
            values{i} = eval(values{i});
        catch
            error('load_param_study:EvalError', ...
                ['Error while reading file %s.\n'...
                 'Could not evaluate expression ''%s'' for parameter ''%s''.'], ...
                 filename, values{i}, param_names{i})
        end
    end
end

param_study = ParameterStudy(param_names, values);
