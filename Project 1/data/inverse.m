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
inverseVoxel = zeros(xSize, ySize, zSize);
%reconstruction
for i = 1:xSize
    for j = 1:ySize
        for k = 1:zSize
            %transform points in world space into GPS transmitter space
            x = xMin + (i-1)*voxelSize;
            y = yMin + (j-1)*voxelSize;
            z = zMin + (k-1)*voxelSize;
            gpsPoint = matrix \ [x; y; z; 1];
            gpsPoint = gpsPoint(1:3);
            %determine the nearest frame plane
            m = squeeze(gpsData(:, 2, :)) - squeeze(gpsData(:, 1, :));
            n = squeeze(gpsData(:, 4, :)) - squeeze(gpsData(:, 1, :));
            normals = cross(m, n);
            norms = zeros(1, 694);
            for l = 1:694
                norms(l) = norm(normals(:, l));
            end
            distances = abs(dot(squeeze(gpsData(:,1,:))-gpsPoint, normals, 1) ./ norms);
            [minDistance, index] = min(distances);
            %project onto frame plane
            B = cat(2, m(:, index), n(:, index));
            projPoint = B / (B'*B) * B' * gpsPoint; %projection equation
            %caculate the indices of pixel on frame plane
            abDistance = norm(cross(gpsData(:,1,index)-projPoint, m(:, index))) / norm(m(:, index));
            adDistance = norm(cross(gpsData(:,1,index)-projPoint, n(:, index))) / norm(n(:, index));
            abLength = norm(m(:, index));
            adLength = norm(n(:, index));
            row = round(abDistance / abLength * 239 + 1);
            column = round(adDistance / adLength * 319 + 1);
            %ensure the projected point lies inside the frame plane
            if and(row <= 240, column <= 320)
                inverseVoxel(i, j, k) = frameData{index}(row, column);
            end
        end
    end
end
save inverseVoxel;
isosurface(inverseVoxel);

            
            