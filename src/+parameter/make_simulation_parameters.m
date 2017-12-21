function params = make_simulation_parameters(param_file)
%MAKE_SIMULATION_PARAMETERS Factory for instances of SimulationParameters
%
% Subclasses of SimulationParameters are chosen based on the value of the
% key "type" in the input file.
%
% Adrien Luecker, Institute of Fluid Dynamics, ETH Zurich
% May 2014 - September 2017

import parameter.load_simulation_parameters
import parameter.SimulationParameters
import parameter.SimulationParametersDiffusion

if nargin < 1
   param_file = 'params.json';
end

params_data = load_simulation_parameters(param_file);

if isfield(params_data, 'type') && strcmp(params_data.type, 'O2_diffusion')
    params = SimulationParametersDiffusion(params_data);
else
    params = SimulationParameters(params_data);
end

end

