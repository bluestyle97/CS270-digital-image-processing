function result = histogram_equalization(image)
L = 2.^double(nextpow2(max(image, [], 'all')));
histogram = zeros(L, 1);
s = zeros(L, 1);
% get histogram
for i = 1 : L
    histogram(i) = sum(nonzeros(image==(i-1)), 'all');
end
% histogram equalization
result = zeros(size(image));
[M, N] = size(image);
for k = 1 : L
    s(k) = (L-1)./(M.*N).*sum(histogram(1:k), 'all');
    result(image==(k-1)) = uint8(s(k));
end
    
end
