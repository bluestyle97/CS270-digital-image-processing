clc;
close all;
clear;

image_raw = imread('Licenses/23.jpg');
image = horizon(image_raw);
figure;
subplot(1, 2, 1);
imshow(image_raw);
subplot(1, 2, 2);
imshow(image);

image_denoised = medfilt2(image, [11, 11]);
figure('Name', 'Denoising');
subplot(1, 2, 1);
imshow(image);
subplot(1, 2, 2);
imshow(image_denoised);

image_edge = edge(image_denoised, 'Canny');
figure('Name', 'Edge');
imshow(image_edge);

se = strel('rectangle', [1, 1]);
image_closed = imclose(image_edge, se);
figure('Name', 'Closing');
imshow(image_closed);

image_filled = imfill(image_closed, 'holes');
figure('Name', 'Filling');
imshow(image_filled);

image_removed = bwareaopen(image_filled, 1000);
figure('Name', 'Removing');
imshow(image_removed);

se = strel('rectangle', [3, 3]);
image_eroded = imerode(image_removed, se);
figure('Name', 'Erosion');
imshow(image_eroded);

B = bwboundaries(image_eroded, 'noholes');

% cut digital numbers
[M, N] = size(image_eroded);
shapes = zeros(length(B), 2, 2);
for k = 1 : length(B) 
    maxv = max(B{k});
    minv = min(B{k});
    shapes(k, :, :) = [min(maxv+5, [M,N]); max(minv-5, 1)];
end

characters = [];
figure('Name', 'Characters');
for i = 1 : length(B)
    shape = squeeze(shapes(i, :, :));
    image_split = cut_character(image_denoised, shape, true);
    subplot(1, length(B), i);
    imshow(image_split);
    
    path1 = 'model/';
    path2 = 'model/more/';
    fileExt = '*.jpg';
    files1 = dir(fullfile(path1, fileExt));
    files2 = dir(fullfile(path2, fileExt));
    
    result = '1';
    max_score = 0;
    
    for j = 1 : size(files1, 1)
        filename = strcat(path1, files1(j, 1).name);
        template_char = files1(j, 1).name(5);
        template = imread(filename);
        if length(size(template)) == 3
            template = rgb2gray(template);
        end
        template = imbinarize(template, 0.5);
        score = corr2(image_split, template);
        if score > max_score
            max_score = score;
            result = template_char;
        end
    end
    
    for j = 1 : size(files2, 1)
        filename = strcat(path2, files2(j, 1).name);
        template_char = files2(j, 1).name(5);
        template = imread(filename);
        if length(size(template)) == 3
            template = rgb2gray(template);
        end
        template = imbinarize(template, 0.5);
        score = corr2(image_split, template);
        if score > max_score
            max_score = score;
            result = template_char;
        end
    end
    
    characters = [characters, result];
end

characters
