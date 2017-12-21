classdef ParameterStudyPlotter2D < plot.ParameterStudyPlotter
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
        param_label1   % Axis label text for the 1st study parameter
        param_label2   % Axis label text for the 2nd study parameter
        param_factor1  % Multiplicative factor for plotting the 1st parameter
        param_factor2  % Multiplicative factor for plotting the 2nd parameter
    end
    
    methods
        function obj = ParameterStudyPlotter2D(param_study, ...
                param_label1, param_label2, ...
                param_factor1, param_factor2)
            obj = obj@plot.ParameterStudyPlotter(param_study);
            obj.param_label1 = param_label1;
            obj.param_label2 = param_label2;
            obj.param_factor1 = param_factor1;
            obj.param_factor2 = param_factor2;
        end
        
        function plot_lines1(obj, values, y_label, varargin)
            param_size = obj.param_study.param_size();
            val_array = obj.param_study.vector2array(values);
            for i = 1:param_size(2)
                plot(obj.param_factor1*obj.param_study.param_values{1}, ...
                    val_array(:,i), varargin{:})
            end
            xlabel(obj.param_label1)
            ylabel(y_label)
            set(gca, 'FontSize', 16)
        end
        
        function plot_lines2(obj, values, y_label, varargin)
            param_size = obj.param_study.param_size();
            val_array = obj.param_study.vector2array(values);
            for i = 1:param_size(1)
                plot(obj.param_factor2*obj.param_study.param_values{2}, ...
                    val_array(i,:), varargin{:})
            end
            xlabel(obj.param_label2)
            ylabel(y_label)
            set(gca, 'FontSize', 16)
        end
        
        function plot_contour(obj, values, varargin)
            val_array = obj.param_study.vector2array(values);
            [C, h] = contour(obj.param_factor1*obj.param_study.param_values{1},...
                obj.param_factor2*obj.param_study.param_values{2}, ...
                val_array');
            clabel(C, h, 'Interpreter', 'latex')
            xlabel(obj.param_label1, 'Interpreter', 'latex')
            ylabel(obj.param_label2, 'Interpreter', 'latex')
            set(gca, 'FontSize', 16)
        end
    end
    
end
