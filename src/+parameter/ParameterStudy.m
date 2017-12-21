classdef ParameterStudy
%PARAMETERSTUDY Encapsulate data for a parameter study
% 
% A parameter study is defined by parameter names and an array of values
% for each parameter. 
%
% The method params = set_params(obj, base_params, i_study) is then used to
% produce a modified version of the SimulationParameters instance
% base_params for the 'i_study'-th element of the parameter study.
% Therefore, the parameter names need to be attributes of the instance of
% SimulationParameters passed as an argument.
%
% Adrien Luecker, Institute of Fluid Dynamics, ETH Zurich
% May 2014 - September 2017

    properties (SetAccess = public)
       param_names   % parameter names (cell of char arrays)
       param_values  % parameter values (cell with respective arrays)
    end
    
    methods (Access = public)
        function obj = ParameterStudy(param_names, param_values)
            % Constructor by components
            obj.param_names = param_names;
            obj.param_values = param_values;
            
            if numel(obj.param_names) ~= numel(obj.param_values)
                error('Inconsistent number of parameter names and values.')
            end
            if numel(obj.param_names) > 2
                error('At most two parameters are currently supported.')
            end
        end
                
        function n = n_params(obj)
            % Return the number of parameters.
            n = numel(obj.param_values);
        end
        
        function size_array = param_size(obj)
            % Return an array with the respective number of elements for
            % each parameter.
            size_array = zeros(obj.n_params, 1);
            for i = 1:obj.n_params()
                size_array(i) = numel(obj.param_values{i});
            end
        end
        
        function n = n_elements(obj)
            % Return the total number of elements in the parameter study.
            n = prod(obj.param_size());
        end
        
        function vals = study_values(obj, i_study)
            % Return the values for a given element of the parameter study.
            %
            % vals = study_values(obj, i_study) returns a cell array vals
            % with the parameter values for the element of the parameter
            % study with index i_study.
            vals = {};
            if obj.n_params == 1
                vals{1} = obj.param_values{1}(i_study);
            elseif obj.n_params == 2
                [X1, X2] = ndgrid(obj.param_values{1}, obj.param_values{2});
                [j, k] = ind2sub(size(X1), i_study);
                vals{1} = X1(j, k);
                vals{2} = X2(j, k);
            end
        end
        
        function params = set_params(obj, base_params, i_study)
            % Return a ParameterStudy instance with parameter values for a
            % given element of the study.
            %
            % The returned instance has all parameter equals to those in
            % the ParameterStudy instance base_params, except those
            % specified in the parameter study. Those are set to the values
            % for the parameter study element with index i_study.
            obj.check_param_names(base_params)
            params = base_params;
            values = obj.study_values(i_study);
            for i = 1:obj.n_params
                params.(obj.param_names{i}) = values{i};
            end
        end
        
        function array = vector2array(obj, vector)
            % Reshape a 1-D vector to an array with as many dimensions as
            % parameters. The i-th dimension has the number of elements of
            % the i-th parameter.
            if obj.n_params == 1
                array = vector;
            elseif obj.n_params == 2
                array = reshape(vector, numel(obj.param_values{1}), numel(obj.param_values{2}));
            end
        end

        function str = param_value_string(obj, i_study)
            % Return a string with the parameter name, its value and the
            % current index in the parameter study.
            str = '';
            for i = 1:obj.n_params()
                if i > 1
                    str = [str, ', '];
                end
                vals = obj.study_values(i_study);
                str = sprintf('%s%s = %g', str, obj.param_names{i}, vals{i});
            end
            str = [str, sprintf(' (%d/%d)\n', i_study, obj.n_elements())];
        end
    end
    
    methods (Access = protected)
        function check_param_names(obj, params)
            for i = 1:obj.n_params
                if ~any(strcmp(obj.param_names{i}, fieldnames(params)))
                    error(fprintf('Parameter %s not found in given simulation parameters', ...
                        obj.param_names(i)))
                end
            end
        end
    end
    
end
