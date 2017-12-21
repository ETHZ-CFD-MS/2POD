%RUN_TUTORIALS Run all tutorials in the tutorials folder.
%
%   Run tutorial in each folder that has a script 'run.m' in it.
%
% Adrien Luecker, Institute of Fluid Dynamics, ETH Zurich
% May 2014 - September 2017

dirs = dir;

for i = 1:numel(dirs)
    if dirs(i).isdir && ~strcmp(dirs(i).name, '.') && ...
       ~strcmp(dirs(i).name, '..') && ~isempty(strfind(ls(dirs(i).name), 'run.m')) 
        cd(dirs(i).name);
        fprintf('\nRunning tutorial ''%s''.\n', dirs(i).name)
        run
        cd ..
    end
end