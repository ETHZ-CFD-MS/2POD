function A = diffusion_matrix_cylindrical(grid, D)
%DIFFUSION_MATRIX_CYLINDRICAL Build a matrix for the diffusion operator.
% Builds the matrix for the discretized Laplacian operator in cylindrical
% coordinates (r, z) (problem symmetric in theta) using finite-differences.
% A von Neumann boundary condition is used at the boundaries.
%
% GRID  instance of CartesianGrid (the r-direction is denoted by x, the z-direction by y)
% D     diffusion coefficient
%
% A  = matrix for Laplacian operator in cylindrical coordinates

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

% Coordinates of cell centers
rc = grid.xCenter();
zc = grid.yCenter();
rf = grid.xFaces();
zf = grid.yFaces();

Nr = numel(rc);
Nz = numel(zc);

A = spalloc(Nr*Nz, Nr*Nz, 5*Nr*Nz);

for i = 1:Nr
    r  = rc(i);              % cell center coordinate
    rE = rf(i+1);            % cell face coordinate
    rW = rf(i);              % cell face coordinate
    dr = rE - rW;            % cell width
    
    for j = 1:Nz
        zN = zf(j+1);            % cell face coordinate
        zS = zf(j);              % cell face coordinate
        dz = zN - zS;            % cell width
        
        % flattened index
        k = i + (j-1)*Nr;
        % flattened indices of neighbors
        kE = k+1;
        kW = k-1;
        kN = k+Nr;
        kS = k-Nr;
        
        % contribution of r-coordinate
        % split cases: center / boundary / interior
        if i == 1
            drE = rc(i+1) - rc(i);   % distance between cell centers on positive side
            A(k,k)  = A(k,k)  - 1/(r*dr)*(rE/drE);
            A(k,kE) = A(k,kE) + 1/(r*dr)*(rE/drE);
        elseif i == Nr
            drW = rc(i)   - rc(i-1); % distance between cell centers on negative side
            A(k,k) = A(k,k) - 1/(r*dr)*(rW/drW);
            A(k,kW) = A(k,kW) + 1/(r*dr)*(rW/drW); 
        else
            drE = rc(i+1) - rc(i);   % distance between cell centers on positive side
            drW = rc(i)   - rc(i-1); % distance between cell centers on negative side
            A(k,k)  = A(k,k)  - 1/(r*dr)*(rE/drE + rW/drW);
            A(k,kE) = A(k,kE) + 1/(r*dr)*(rE/drE);
            A(k,kW) = A(k,kW) + 1/(r*dr)*(rW/drW);  
        end
        
        % contribution of z-coordinate
        % split cases: bottom / top / interior
        if j == 1
            dzN = zc(j+1) - zc(j);   % distance between cell centers on positive side
            A(k,k)  = A(k,k)  - 1/(dz*dzN);
            A(k,kN) = A(k,kN) + 1/(dz*dzN);
        elseif j == Nz
            dzS = zc(j)   - zc(j-1); % distance between cell centers on negative side
            A(k,k)  = A(k,k)  - 1/(dz*dzS);
            A(k,kS) = A(k,kS) + 1/(dz*dzS);
        else
            dzN = zc(j+1) - zc(j);   % distance between cell centers on positive side
            dzS = zc(j)   - zc(j-1); % distance between cell centers on negative side
            A(k,k)  = A(k,k)  - 1/dz*(1/dzN + 1/dzS);
            A(k,kN) = A(k,kN) + 1/(dz*dzN);
            A(k,kS) = A(k,kS) + 1/(dz*dzS);
        end
    end
end

A = D*A;
