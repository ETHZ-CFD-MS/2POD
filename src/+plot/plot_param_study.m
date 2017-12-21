function plot_param_study(input_filename, suffix)
%PLOT_PARAM_STUDY Plot the results of a parameter study.
%
%   Inputs:
%       INPUT_FILENAME  Name of the file containing the results.
%       SUFFIX          Suffix appended to the plot file names.
%
%       This function can handle both one- and two-dimensional parameter studies.
%       The size of the excitation volume is plotted for all parameter values.

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

import plot.make_parameter_study_plotter
import plot.save_fig

%% parameters
if nargin < 1
    input_filename = 'results.mat';
end
if nargin < 2
    suffix = '';
end
plot_param_file = 'plot_params.json';

%% load and prepare data
load(input_filename, 'resolution', 'param_study')

set(0, 'DefaultTextInterpreter', 'latex')

if size(resolution, 2) > 1
    x_res = cellfun(@(res) res.x_res, resolution(:,end));
    x_res_focal = cellfun(@(res) res.x_res_focal, resolution(:,end));
    z_res = cellfun(@(res) res.z_res, resolution(:,end));
else
    x_res = cellfun(@(res) res.x_res, resolution);
    x_res_focal = cellfun(@(res) res.x_res_focal, resolution);
    z_res = cellfun(@(res) res.z_res, resolution);
end
plotter = make_parameter_study_plotter(param_study, plot_param_file);

%% plot
if param_study.n_params() == 1
    figure; hold on
    plotter.plot(1e6*x_res, '$\Delta x \; [\mathrm{\mu m}]$', 'x-')
    plotter.plot(1e6*x_res_focal, '$\Delta x \; [\mathrm{\mu m}]$', 'o-')
    save_fig(['x_res', suffix])
    
    figure; hold on
    plotter.plot(1e6*z_res, '$\Delta z \; [\mathrm{\mu m}]$', 'x-')
    save_fig(['z_res', suffix])
elseif param_study.n_params() == 2
    figure; hold on
    plotter.plot_lines1(1e6*x_res, '$\Delta x \; [\mathrm{\mu m}]$', 'x-')
    plotter.plot_lines1(1e6*x_res_focal, '$\Delta x \; [\mathrm{\mu m}]$', 'o-')
    save_fig(['x_res1', suffix])
    
    figure; hold on
    plotter.plot_lines2(1e6*x_res, '$\Delta x \; [\mathrm{\mu m}]$', 'x-')
    plotter.plot_lines2(1e6*x_res_focal, '$\Delta x \; [\mathrm{\mu m}]$', 'o-')
    save_fig(['x_res2', suffix])
    
    figure; hold on
    plotter.plot_contour(1e6*x_res)
    save_fig(['x_res_contour', suffix]) 
    
    figure; hold on
    plotter.plot_lines1(1e6*z_res, '$\Delta z \; [\mathrm{\mu m}]$')
    save_fig(['z_res1', suffix])
    
    figure; hold on
    plotter.plot_lines2(1e6*z_res, '$\Delta z \; [\mathrm{\mu m}]$')
    save_fig(['z_res2', suffix])
    
    figure; hold on
    plotter.plot_contour(1e6*z_res)
    save_fig(['z_res_contour', suffix]) 
end

end
