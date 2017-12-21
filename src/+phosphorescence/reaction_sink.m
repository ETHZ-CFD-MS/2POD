function R = reaction_sink(PT, O2, O2s, alpha, sim_params)
%REACTION_SINK Compute the reaction term between P^T, O2 and singlet O2.
%
%   Compute the reaction term between P^T, O2 and O2^* (singlet oxygen) in 
%   the reduced equations for phosphorescence decays.
%   The first row corresponds to P^T.
%   The second row corresponds to O2.
%   The third row corresponds to O2^*.
%
%   Inputs:
%       PT    = concentration of probe in triplet state (N x 1)
%       O2    = concentration of oxygen in ground state (N x 1)
%       O2s   = concentration of singlet oxygen (N x 1)
%       ALPHA = excitation rate [s^-1]
%       SIM_PARAMS = instance of SimulationParameters
%
%   Output:
%       R     = reaction term (3N x 1)
%
% Adrien Luecker, Institute of Fluid Dynamics, ETH Zurich
% May 2014 - September 2017

S_P  = sim_params.S_P;
kp   = sim_params.kp;
kq   = sim_params.kq;
kd   = sim_params.kd;
kr   = sim_params.kr;
kqpr = sim_params.kqpr;

R1 = alpha*S_P - (alpha + kp + kq*O2).*PT;
R2 =           - kq*PT.*O2                 + (kd+kqpr)*O2s;
R3 =             kq*PT.*O2                 - (kd+kqpr+kr)*O2s;

R = [R1 ; R2 ; R3];