function plotter = make_parameter_study_plotter(param_study, plot_param_file)
%MAKE_PARAMETER_STUDY_PLOTTER Factory method for parameter study plotter
%
%   The plot parameters are read from a JSON file.
%   The derived class from ParameterStudyPlotter is chosen based on the
%   number of parameters in the parameter study.
%
%   Inputs:
%       PARAM_STUDY     = instance of ParameterStudy
%       PLOT_PARAM_FILE = path to input JSON file
%
%   Output:
%       PLOTTER         = instance of ParameterStudyPlotter

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

import plot.ParameterStudyPlotter1D
import plot.ParameterStudyPlotter2D

if nargin < 2
   plot_param_file = 'plot_params.json';
end

plot_params_data = loadjson(plot_param_file);

if param_study.n_params() == 1
    param_label = plot_params_data.param_label;
    param_factor = plot_params_data.param_factor;
    plotter = ParameterStudyPlotter1D(param_study, param_label, param_factor);
elseif param_study.n_params() == 2
    param_label1 = plot_params_data.param_label1;
    param_label2 = plot_params_data.param_label2;
    param_factor1 = plot_params_data.param_factor1;
    param_factor2 = plot_params_data.param_factor2;
    plotter = ParameterStudyPlotter2D(param_study, param_label1, param_label2, ...
                                      param_factor1, param_factor2);
end

end
