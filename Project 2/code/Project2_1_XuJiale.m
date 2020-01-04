clc;
clear;
close all;

load Lenna;
origin = Lenna;
figure(1);
subplot(1, 5, 1);
imshow(origin, []);
title('Original');

% parameters
c = 2;
D0 = 200;   % cutoff frequency

% Laplacian
kernel = [-1 -1 -1; -1 8 -1; -1 -1 -1];
g_lap = uint8(origin) + c * uint8(conv_filter(origin, kernel));
subplot(1, 5, 2);
imshow(g_lap, []);
title('Laplacian');

[M, N] = size(origin);
u = -M:(M-1);
v = -N:(N-1);
[V, U] = meshgrid(v, u);
D = sqrt(U.^2 + V.^2);    % D(u, v)
F = fftshift(fft2(origin, 2*M, 2*N));   % DFT

% IHPF
H_ihpf = zeros(2*M, 2*N);
H_ihpf(D > D0) = 1;
ret_ihpf = real(ifft2(ifftshift(H_ihpf .* F)));
g_ihpf = uint8(origin) + c * uint8(ret_ihpf(1:M, 1:N));
subplot(1, 5, 3);
imshow(g_ihpf, []);
title('IHPF');

% BHPF
n = 2;
H_bhpf = 1./(1+(D0./D).^(2*n));
ret_bhpf = real(ifft2(ifftshift(H_bhpf .* F)));
g_bhpf = uint8(origin) + c * uint8(ret_bhpf(1:M, 1:N));
subplot(1, 5, 4);
imshow(g_bhpf, []);
title('BHPF');

% GHPF
H_ghpf = 1-exp(-(D.^2)./(2*D0^2));
ret_ghpf = real(ifft2(ifftshift(H_ghpf .* F)));
g_ghpf = uint8(origin) + c * uint8(ret_ghpf(1:M, 1:N));
subplot(1, 5, 5);
imshow(g_ghpf, []);
title('GHPF');
