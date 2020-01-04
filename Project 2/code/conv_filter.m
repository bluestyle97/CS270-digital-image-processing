function output = conv_filter(image, kernel)
[m, n] = size(image);   % size of original image
[s, t] = size(kernel);  % size of kernel
a = (s - 1) / 2;
b = (t - 1) / 2;
% pad image
padded_image = zeros(m+2*a, n+2*b);
padded_image(1+a:m+a, 1+b:n+b) = image;
output = zeros(m, n);
% corelation
for i = 1 : m
    for j = 1 : n
        output(i, j) = sum(padded_image(i:i+s-1, j:j+t-1) .* kernel, 'all');
    end
end

end

