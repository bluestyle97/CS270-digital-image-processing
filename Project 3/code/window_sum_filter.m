function result = window_sum_filter(image, r)

% result(x, y) = = sum(sum(image(x-r:x+r, y-r:y+r)));

[m, n] = size(image);
result = zeros(m, n);

% Y axis
im_cum = cumsum(image, 1);

result(1:r+1, :) = im_cum(1+r:2*r+1, :);
result(r+2:m-r, :) = im_cum(2*r+2:m, :) - im_cum(1:m-2*r-1, :);
result(m-r+1:m, :) = repmat(im_cum(m, :), [r, 1]) - im_cum(m-2*r:m-r-1, :);

% X axis
im_cum = cumsum(result, 2);

result(:, 1:r+1) = im_cum(:, 1+r:2*r+1);
result(:, r+2:n-r) = im_cum(:, 2*r+2:n) - im_cum(:, 1:n-2*r-1);
result(:, n-r+1:n) = repmat(im_cum(:, n), [1, r]) - im_cum(:, n-2*r:n-r-1);

end