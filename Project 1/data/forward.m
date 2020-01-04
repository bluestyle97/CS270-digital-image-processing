load calibrationPoints;
load frameData;
load gpsData;
%obtain transformation matrix
matrix = getTransformationMatrix(calibrationPoints(:, :, 1), calibrationPoints(:, :, 2));
%construct regular volume
worldData = matrix * cat(1, reshape(gpsData, 3, 4*694), ones(1, 4*694));
worldData = worldData(1:3, :);
xMin = min(worldData(1, :), [], 'all');
xMax = max(worldData(1, :), [], 'all');
yMin = min(worldData(2, :), [], 'all');
yMax = max(worldData(2, :), [], 'all');
zMin = min(worldData(3, :), [], 'all');
zMax = max(worldData(3, :), [], 'all');
voxelSize = 0.5;
xSize = ceil((xMax-xMin) / voxelSize);
ySize = ceil((yMax-yMin) / voxelSize);
zSize = ceil((zMax-zMin) / voxelSize);
forwardVoxel = zeros(xSize, ySize, zSize);
%reconstruction
count = zeros(xSize, ySize, zSize); %record how many pixels are assigned to one voxel
for img = 1:694
    for i = 1:240
        for j = 1:320
            %caculate the coordinates of pixels in GPS transmitter space
            rec = gpsData(:, :, img);
            m = ((240-i)*rec(:,1)+(i-1)*rec(:,4)) / 239;
            n = ((240-i)*rec(:,2)+(i-1)*rec(:,3)) / 239;
            gpsPoint = ((320-j)*m+(j-1)*n) / 319;
            %transform points into world space
            worldPoint = matrix * cat(1, gpsPoint, 1);
            worldPoint = worldPoint(1:3);
            %assign each transformed point to the nearest voxel
            XYZ = floor(abs(worldPoint - [xMin; yMin; zMin])/voxelSize) + [1; 1; 1];
            forwardVoxel(XYZ(1), XYZ(2), XYZ(3)) = forwardVoxel(XYZ(1), XYZ(2), XYZ(3)) + frameData{img}(i,j);
            %record the number of assigned pixels
            count(XYZ(1), XYZ(2), XYZ(3)) = count(XYZ(1), XYZ(2), XYZ(3)) + 1;
        end
    end
end
%take the average of intensity values if multiple pixels were mapped to
%one voxel
for i = 1:xSize
    for j = 1:ySize
        for k = 1:zSize
            %ensure zeros won't be divided
            if ~count(i, j, k) == 0
                forwardVoxel(i, j, k) = forwardVoxel(i, j, k) / count(i, j, k);
            end
        end
    end
end
save forwardVoxel;
isosurface(forwardVoxel);
