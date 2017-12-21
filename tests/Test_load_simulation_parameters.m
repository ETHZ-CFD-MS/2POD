classdef Test_load_simulation_parameters < matlab.unittest.TestCase
    %TEST_LOAD_SIMULATION_PARAMETERS Summary of this class goes here
    %   Detailed explanation goes here

    properties
    end
    
    methods
    end
    
    methods (Test)
        
        function TestReadArrayParameter(self)
            import parameter.load_param_study
            param_study = load_param_study('{"Pm": [5e-3, 10e-3]}');
            self.verifyEqual(param_study.param_names{1}, 'Pm')
            self.verifyEqual(param_study.param_values{1}, [5e-3, 10e-3])
        end
        
        function TestReadCharParameter(self)
            import parameter.load_param_study
            param_study = load_param_study('{"Pm": "1:2:10"}');
            self.verifyEqual(param_study.param_names{1}, 'Pm')
            self.verifyEqual(param_study.param_values{1}, [1, 3, 5, 7, 9])
        end
        
        function TestReadIncorrectCharParameter(self)
            import parameter.load_param_study
            self.verifyError(@() load_param_study('{"Pm": "1:2abc"}'), ...
                'load_param_study:EvalError')
        end
        
    end
    
end

