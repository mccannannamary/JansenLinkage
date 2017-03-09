function nodePositions = nodePositionsForEachAngle(l,angles,pointx,pointy)
% get a matrix of positions for all nodes for each angle given in storage
% input Storage = matrix of angles that links form with x-y axis
% output nodePositions = matrix of x and y coordinates of each node for
% each angle in Storage

numArgs = 4;
if (nargin ~= numArgs)
    error('Wrong number of input arguments. Enter 6 input arguments');
end
nodePositions = [pointx+l*cos(angles) pointy+l*sin(angles)];
end

