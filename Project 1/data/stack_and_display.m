load frameData;
data = zeros(694, 240, 320);
for i = 1:694
    data(i, :, :) = frameData{i}(:, :);
end
isosurface(data);