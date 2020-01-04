clc;
clear;

window_size = 3;
omega = 0.95;

% first image
figure(1);

image1 = double(imread('fog1.jpg'));
[result1, dark_channel1, filtered_dark_channel1] = remove_haze(image1, window_size, omega);

subplot(2, 2, 1);
imshow(uint8(image1));
title('original image');

subplot(2, 2, 2);
imshow(uint8(dark_channel1));
title('dark channel');

subplot(2, 2, 3);
imshow(uint8(filtered_dark_channel1));
title('filtered dark channel');

subplot(2, 2, 4);
imshow(uint8(result1));
title('result');

saveas(gcf, 'result1.jpg');

% second image
figure(2);

image2 = double(imread('fog2.jpg'));
[result2, dark_channel2, filtered_dark_channel2] = remove_haze(image2, window_size, omega);

subplot(2, 2, 1);
imshow(uint8(image2));
title('original image');

subplot(2, 2, 2);
imshow(uint8(dark_channel2));
title('dark channel');

subplot(2, 2, 3);
imshow(uint8(filtered_dark_channel2));
title('filtered dark channel');

subplot(2, 2, 4);
imshow(uint8(result2));
title('result');

saveas(gcf, 'result2.jpg');