function R = reaction(PT, O2, alpha, sim_params)
%REACTION_SINK Compute the reaction term between excited probe and oxygen.
%
%   Compute the reaction term between P^T and O2 in the reduced equations 
%   for phosphorescence decays.
%
%   Inputs:
%       PT    = concentration of probe in triplet state (N x 1)
%       O2    = concentration of oxygen in ground state (N x 1)
%       ALPHA = excitation rate [s^-1]
%       SIM_PARAMS = instance of SimulationParameters
%
%   Output:
%       R     = reaction term (2N x 1)
%
% Adrien Luecker, Institute of Fluid Dynamics, ETH Zurich
% May 2014 - September 2017

S_P  = sim_params.S_P;
S_O2 = sim_params.S_O2;
kp   = sim_params.kp;
kq   = sim_params.kq;
kd   = sim_params.kd;
kqpr = sim_params.kqpr;

R1 = alpha*S_P - (alpha + kp + kq*O2).*PT;
R2 = (kd + kqpr)*S_O2   - (kd + kqpr + kq*PT).*O2;

R = [R1 ; R2];