clc;
clear;
close all;

D0 = 200;
W = 60;

figure(1);

% Lenna
load Lenna;
subplot(1, 4, 1);
imshow(Lenna, []);
title('Lenna');

result1 = frequency_color_enhance(Lenna, D0, W);
subplot(1, 4, 2);
imshow(result1);
title('Color');

% RSI
load RSI;
subplot(1, 4, 3);
imshow(RSI, []);
title('RSI');

result2 = frequency_color_enhance(RSI, D0, W);
subplot(1, 4, 4);
imshow(result2);
title('Color');
