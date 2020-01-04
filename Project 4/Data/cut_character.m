function image_out = cut_character(image_in, shape, binarize)

image_out = image_in(shape(2,1):shape(1,1), shape(2,2):shape(1,2));
if binarize
    image_out = imbinarize(image_out, 0.5);
end
image_out = bwareaopen(image_out, 100);

[m, n] = size(image_out);
top = 1;
bottom = m;
left = 1;
right = n;

% get the top boundaryof character
while sum(image_out(top, :)) < 5 && top <= m
    top = top + 1;
end

% get the bottom boundary of character
while sum(image_out(bottom, :)) < 5 && bottom >= 1
    bottom = bottom - 1;
end

% get the left boundary of character
while sum(image_out(:, left)) < 5 && left <= n
    left = left + 1;
end

% get the right boundary of cahracter
while sum(image_out(:, right)) < 5 && right >= 1
    right = right - 1;
end

width = right - left;
height = bottom - top;

% cut character region, resize
image_out = imcrop(image_out, [left top width height]);
image_out = imresize(image_out, [40, 20], 'nearest');

end