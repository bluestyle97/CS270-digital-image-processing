function result = histogram_matching(image, target)
% image: the image to be matched
% target: the image whose histogram is the matching target
L = 256;
target_hist = zeros(L, 1);
% get target histogram
for i = 1 : L
    target_hist(i) = sum(nonzeros(target==(i-1)), 'all');
end
[m, n] = size(image);
image_hist = zeros(L, 1);
% get image histogram
for i = 1 : L
    image_hist(i) = sum(nonzeros(image==(i-1)), 'all');
end

result = zeros(size(image));
ac1 = zeros(L, 1);
T1 = zeros(L, 1, 'uint8');
ac1(1) = image_hist(1);
for i = 2 : L
    ac1(i) = ac1(i - 1) + image_hist(i);
end
ac1 = ac1 * (L - 1);
for i = 1 : 256
    T1(i) = uint8(round((ac1(i)) / (m * n)));
end

ac2 = zeros(L, 1);
T2 = zeros(L, 1, 'uint8');
ac2(1) = target_hist(1);
for i = 2 : L
    ac2(i) = ac2(i - 1) + target_hist(i);
end
ac2 = ac2 * (L - 1);
hist_sum = sum(target_hist);
for i = 1 : L
    T2(i) = uint8(round((ac2(i)) / hist_sum));
end

temp = zeros(L, 1, 'uint8');
T3 = T1;
for i = 1 : L
    for j = 1 : L
        temp(j) = abs(T1(i) - T2(j));
    end
    [~, B] = min(temp);
    T3(i) = B - 1;
end

% transform input image
for i = 1 : m
    for j = 1 : n
        result(i, j) = T3(uint8(image(i, j)) + 1);
    end
end
end
