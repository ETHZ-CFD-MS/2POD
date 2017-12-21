function save_fig(fig_name, formats)
%SAVE_FIG Save the current figure with given name and format
%
%   Currently, saving eps, png and fig files is supported.
%
%   Inputs:
%       FIG_NAME = name of the file to save to
%       FORMATS  = cell array with the image format names

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

supported_formats = {'eps', 'png', 'fig'};
if nargin < 2
    formats = supported_formats;
end

% check if the formats are supported
for i = 1:numel(formats)
    if ~any(strcmp(formats{i}, supported_formats))
        error('save_fig:unknown_formats', ...
            'Unknown figure format ''%s''.', formats{i})
    end 
end

% save files
if any(strcmp(formats, 'eps'))
    print(fig_name, '-depsc')
end
if any(strcmp(formats, 'png'))
    print(fig_name, '-dpng', '-r600')
end
if any(strcmp(formats, 'fig'))
    savefig(fig_name)
end
