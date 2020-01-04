%function: caculate the transformation matrix between GPS transmitter space
%and world sapce
%arg1: coordinates of points in GPS transmitter space
%arg2: coornidates of points in world space
function matrix = getTransformationMatrix(gpsSpaceCoordinates,worldSpaceCoordinates)
gpsSpaceCoordinates = cat(1, gpsSpaceCoordinates, [1 1 1 1]);
matrix = worldSpaceCoordinates / gpsSpaceCoordinates;
matrix = cat(1, matrix, [0 0 0 1]);
end

