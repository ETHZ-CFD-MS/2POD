classdef ParameterStudyPlotter1D < plot.ParameterStudyPlotter
%PARAMETERSTUDYPLOTTER1D Implements plotting for 1D parameter studies

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

    properties
        param_label   % Axis label text for the study parameter
        param_factor  % Multiplicative factor for plotting
    end
    
    methods
        function obj = ParameterStudyPlotter1D(param_study, param_label, ...
                param_factor)
            obj = obj@plot.ParameterStudyPlotter(param_study);
            obj.param_label = param_label;
            obj.param_factor = param_factor;
        end
        
        function plot(obj, values, y_label, varargin)
            plot(obj.param_factor*obj.param_study.param_values{1}, ...
                 values, varargin{:})
            xlabel(obj.param_label, 'Interpreter', 'latex')
            ylabel(y_label, 'Interpreter', 'latex')
            set(gca, 'FontSize', 16)
        end
    end
    
end
