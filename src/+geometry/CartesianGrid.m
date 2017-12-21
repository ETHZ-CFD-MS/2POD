classdef CartesianGrid
%CartesianGrid - Class implementing a 2D Cartesian grid.
%
% Class for a 2D Cartesian grid with grading.

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

    properties
        xMin     % Minimal x-coordinate
        xMax     % Maximal x-coordinate
        dx       % Base cell width
        yMin     % Minimal y-coordinate
        yMax     % Maximal y-coordinate
        dy       % Base cell height
        xGrading % Grading function for the x-direction
        yGrading % Grading function for the y-direction
    end
    
    properties (Dependent, Access = public)
        xFaces   % Coordinates of the cell faces in x-direction 
        yFaces   % Coordinates of the cell faces in y-direction
    end
    
    methods
        function obj = CartesianGrid(xMin, xMax, dx, yMin, yMax, dy, xGrading, yGrading)
            % CartesianGrid constructor
            if nargin < 7
                xGrading = @(x) 1;
            end
            if nargin < 8
                yGrading = @(y) 1;
            end
            obj.xMin = xMin;
            obj.xMax = xMax;
            obj.dx   = dx;
            obj.yMin = yMin;
            obj.yMax = yMax;
            obj.dy   = dy;
            obj.xGrading = xGrading;
            obj.yGrading = yGrading;
        end
        function xf = get.xFaces(obj)
            xf = obj.gradedArray(obj.xMin, obj.xMax, obj.dx, obj.xGrading);
        end
        function yf = get.yFaces(obj)
            yf = obj.gradedArray(obj.yMin, obj.yMax, obj.dy, obj.yGrading);
        end
        function xc = xCenter(obj)
            % Return the coordinates of the cell centers in x-direction
            xf = obj.xFaces();
            xc = 0.5*(xf(1:end-1) + xf(2:end));
        end
        function yc = yCenter(obj)
            % Return the coordinates of the cell centers in y-direction
            yf = obj.yFaces();
            yc = 0.5*(yf(1:end-1) + yf(2:end));
        end
        function delta = deltaX(obj)
            % Return the grid cell widths
            xf = obj.xFaces();
            delta = xf(2:end) - xf(1:end-1);
        end
        function delta = deltaY(obj)
            % Return the grid cell heights
            yf = obj.yFaces();
            delta = yf(2:end) - yf(1:end-1);
        end
        function n = Nx(obj)
            % Number of cells in x-direction
            n = numel(obj.xFaces) - 1;
        end
        function n = Ny(obj)
            % Number of cells in y-direction
            n = numel(obj.yFaces) - 1;
        end
        function n = NCells(obj)
            % Total number of cells
            n = obj.Nx()*obj.Ny();
        end
        function is_eq = eq(g1, g2)
            % Equality operator
           is_eq = g1.xMin == g2.xMin ...
                && g1.xMax == g2.xMax ...
                && g1.dx   == g2.dx ...
                && g1.yMin == g2.yMin ...
                && g1.yMax == g2.yMax ...
                && g1.dy   == g2.dy ...
                && isequal(g1.xFaces, g2.xFaces) ...
                && isequal(g1.yFaces, g2.yFaces);
        end
    end
    
    methods (Access = private)
        function array = gradedArray(~, minVal, maxVal, delta, gradingFct)
            % Compute a graded array using a grading function.
            array = minVal;
            while array(end) < maxVal
                array(end+1) = array(end) + delta*gradingFct(array(end));
            end
            % discard the last value if it is further from maxVal than the
            % second last
            if array(end) - maxVal > maxVal - array(end-1)
                array(end) = [];
            end
        end
    end
end
