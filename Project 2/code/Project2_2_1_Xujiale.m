clc;
clear;
close all;

load Lenna;
origin = uint8(Lenna);
figure(1);
ax1 = subplot(1, 2, 1);
imshow(origin, []);
title('Original');

ax2 = subplot(1, 2, 2);
L = 2.^double(nextpow2(max(origin, [], 'all')));
colors = jet(L);
[M, N] = size(origin);
result = zeros(M, N, 3);

for i = 1 : M
    for j = 1 : N
        result(i, j, :) = colors(origin(i, j)+1, :);
    end
end
imshow(result);
title('Color Image');
