function [A, q] = set_diffusion_matrix_BC(grid, A, D, BC, BCval)
%SET_DIFFUSION_MATRIX_BC Set coefficients for a speciric boundary condition.
%
% Builds the matrix for the discretized Laplacian operator in cylindrical
% coordinates (r, z) (problem symmetric in theta) using finite-differences.
% A von Neumann boundary condition is used at the boundaries.
%
% GRID = object of type Cartesian grid (the r-direction is denoted by x, the z-direction by y)
% A  = matrix for diffusion operator
% D  = diffusion coefficient
% BC = boundary-condition type ('Neumann' or 'Dirichlet')
% BCval = fixed-value for the boundary condition
%
% A  = modified matrix for Laplacian operator in cylindrical coordinates
% q  = boundary source term for Laplacian operator

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

rc = grid.xCenter();
zc = grid.yCenter();
rf = grid.xFaces();
zf = grid.yFaces();

Nr = numel(rc);
Nz = numel(zc);

q = zeros(Nr*Nz, 1);

% boundary for maximal radius
for j = 1:Nz
    dr = rf(end) - rf(end-1);
    r  = rc(end);
    rE = rf(end);
    
    % flattened index
    k = Nr + (j-1)*Nr;
    
    switch BC
        case 'Neumann'
            % do nothing
        case 'Dirichlet'
            A(k, k) = A(k, k) -       2*D*rE/(r*dr^2);
            q(k)    = q(k)    + BCval*2*D*rE/(r*dr^2);
        otherwise
            error(['Unknown boundary condition ' BC])
    end
end

% boundary for maximal z-coordinate
for i = 1:Nr
    dz = zf(end) - zf(end-1);
    
    % flattened index
    k = i + (Nz-1)*Nr;
    
    switch BC
        case 'Neumann'
            % do nothing
        case 'Dirichlet'
            A(k, k) = A(k, k) -       2*D/dz^2;
            q(k)    = q(k)    + BCval*2*D/dz^2;
    end
end
