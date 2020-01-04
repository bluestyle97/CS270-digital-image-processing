function [License] = split_license2(image)

[M,N,L] = size(image);
if N > M
    dim = 1;
else
    dim = 2;
end
sums = filter2([1,1,1,1], sum(edge(rgb2gray(image))));
sums(1, 1:100) = max(sums);
sums(1, N-100:N) = max(sums);
[m, mindex] = min(sums);
sums(1, mindex-50:mindex+50) = 500;
if (N-mindex) * M > 150000
    [m, mindex2] = min(sums(1, mindex:N));
    mindex2 = mindex2 + mindex;
    License = {image(:, 1:min(mindex,mindex2), :) ,image(:, min(mindex, mindex2):max(mindex, mindex2), :), image(:, max(mindex,mindex2):N, :)};
elseif mindex*M>150000
    [m,mindex2] = min(sums(1,1:mindex));
    License = {image(:, 1:min(mindex,mindex2), :), image(:, min(mindex,mindex2):max(mindex,mindex2), :),image(:, max(mindex,mindex2):N, :)};
else
    License = {image(:, 1:mindex+5, :),image(:, mindex-5:N, :)};
end
end

