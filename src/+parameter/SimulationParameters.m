classdef SimulationParameters
%SIMULATIONPARAMETERS Encapsulate data for simulations of phosphorescence decays.
%
% Adrien Luecker, Institute of Fluid Dynamics, ETH Zurich
% May 2014 - September 2017

    properties (SetAccess = public)
        PO2       % Initial oxygen partial pressure [mmHg]
        S_P       % Initial probe concentration [mol/L]
        kp        % Phosphorescence decay rate with PO2 = 0  [s^-1]
        kq        % Phosphorescence quenching rate [mmHg^-1 s^-1]
        sigma2    % Two-photon absorption cross section of the probe [m^4 s photon^-1]
        D_O2      % Oxygen diffusion rate [m^2 s^-1]
        phip      % Phosphorescence quantum yield [-]
        temp      % Medium temperature [K]
        
        Pm        % Mean laser power [W]
        n_pulse   % Number of laser pulses per excitation gate [-]
        frequency % Laser frequency [s^-1]
        t_pulse   % Laser pulse duration [s]
        wavelength % Laser wavelength [m]
        NA        % Numerical aperture of the objective [-]
        n0        % Refractive index of the medium between lens and specimen [-]
        t_coll    % Duration of the collection period (off-phase) [s]
        chi       % Collection efficiency [-]
        PSF_type  % Model for point spread function ('bessel' or 'gaussian')
        scatt_length_ex % Attenuation length for scattering of the excitation light [m]
        scatt_depth % Depth for the computation of attenuation due to scattering [m]
        
        grid      % CartesianGrid
    end
    
    methods
        function obj = SimulationParameters(data_struct)
            % Constructor
            %
            % The input struct should contain entries for each property of
            % this class, except grid, and the required entries to
            % construct an instance of CartesianGrid.
            required_fields = fieldnames(obj);
            required_fields(strcmp(required_fields, 'grid')) = [];
            
            for i = 1:numel(required_fields)
               obj.(required_fields{i}) = data_struct.(required_fields{i});
            end
            obj.grid = geometry.CartesianGrid(0, data_struct.r_max, data_struct.dr, ...
                0, data_struct.z_max, data_struct.dz, ...
                data_struct.r_grading, data_struct.z_grading);
        end
        
        function O2_concentration = S_O2(obj)
            % Compute the initial oxygen concentration in mol/L.
            import utils.mmHgToMolar
            O2_concentration = mmHgToMolar(obj.PO2, obj.temp);
        end
        
        function t_on = on_time(obj)
            % Compute the duration of the laser on-phase.
            t_on = obj.n_pulse/obj.frequency;
        end
        
        function t_cycle = cycle_length(obj)
            % Compute the total length of a laser cycle (on-phase +
            % off-phase).
            t_cycle = obj.on_time() + obj.t_coll;
        end
    end
end