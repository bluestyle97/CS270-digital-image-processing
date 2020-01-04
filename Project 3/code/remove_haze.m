function [J, J_dark, J_dark_filtered] = remove_haze(image, window_size, omega)

[m, n, ~] = size(image);

% get dark channel
J_dark = get_dark_channel(image, window_size);

% apply guided filter
r = 4;
res = 0.001;
J_dark_filtered = guided_filter(rgb2gray(image), J_dark, r, res);

% get atmosphere
num_brightest_pixels = floor(m * n * 0.01);
dark_vector = reshape(J_dark_filtered, m * n, 1);
image_vector = reshape(image, m * n, 3);
[~, indices] = sort(dark_vector, 'descend');
brightest_indices = indices(1:num_brightest_pixels);
A = sum(image_vector(brightest_indices, :), 1) / num_brightest_pixels;

% get transmission
A_rep = repmat(reshape(A, [1, 1, 3]), m, n);
t = 1 - omega * get_dark_channel(image ./ A_rep, window_size);

% get radiance
t0 = 0.1;
J = ((image - A_rep) ./ repmat(max(t, t0), 1, 1, 3)) + A_rep;

end