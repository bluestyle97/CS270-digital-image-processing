function dark_channel = get_dark_channel(image, window_size)

[m, n, ~] = size(image);

pad_size = floor(window_size/2);
padded_image = padarray(image, [pad_size pad_size], Inf);
dark_channel = zeros(m, n); 

for i = 1 : m
    for j = 1 : n
        patch = padded_image(i:i+window_size-1, j:j+window_size-1, :);
        dark_channel(i, j) = min(patch(:));
     end
end

end