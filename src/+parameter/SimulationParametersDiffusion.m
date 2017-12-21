classdef SimulationParametersDiffusion < parameter.SimulationParameters
%SIMULATIONPARAMETERSDIFFUSION Parameters for 2PLM simulations with O2 diffusion
%
% Adrien Luecker, Institute of Fluid Dynamics, ETH Zurich
% May 2014 - September 2017

    properties
        kd      % Decay rate of singlet oxygen [s^-1]
        kr      % Rate of permanent singlet oxygen removal [s^-1]
        kqpr    % Quenching rate of singlet oxygen by organic molecules [mmHg^-1 s^-1]
        
        n_gates % Number of gates to simulate [-]
        
        abs_tol % Absolute tolerance in the numerical integration
        rel_tol % Relative tolerance in the numerical integration
    end
    
    methods
        function obj = SimulationParametersDiffusion(data_struct)
            % Constructor
            obj = obj@parameter.SimulationParameters(data_struct);
        end
        
        function bool = no_oxygen_removal(obj)
            % Whether no permanent oxygen removal is occurring.
            bool = (obj.kr == 0);
        end
        
        function bool = oxygen_removal(obj)
            % Whether permanent oxygen removal is occurring.
            bool = ~obj.no_oxygen_removal();
        end
    end
    
end

