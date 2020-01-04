function result = frequency_color_enhance(image, D0, W)
[M, N] = size(image);
u = -M:(M-1);
v = -N:(N-1);
[V, U] = meshgrid(v, u);
D = sqrt(U.^2 + V.^2);    % D(u, v)
F = fftshift(fft2(image, 2*M, 2*N));   % DFT

% GLPF
H_glpf = exp(-(D.^2)./(2*(D0-W/2)^2));
ret_glpf = uint8(real(ifft2(ifftshift(H_glpf .* F))));

% GBPF
H_gbpf = 1-exp(-((D.^2-D0^2)./(D.*W)).^2);
ret_gbpf = uint8(real(ifft2(ifftshift(H_gbpf .* F))));

% GHPF
H_ghpf = 1-exp(-(D.^2)./(2*(D0+W/2)^2));
ret_ghpf = uint8(real(ifft2(ifftshift(H_ghpf .* F))));

% post processing
R = histogram_equalization(ret_glpf(1:M, 1:N));
G = histogram_matching(ret_gbpf(1:M, 1:N), R);
B = histogram_matching(ret_ghpf(1:M, 1:N), R);
avg_kernel = [1 1 1; 1 1 1; 1 1 1] ./ 9;
B = (B + conv_filter(B, avg_kernel)) ./ 2;
result = uint8(cat(3, R, G, B));

end

