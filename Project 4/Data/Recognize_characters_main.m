clc;
close all;
clear;

image = imread('Licenses/5.jpg');
image = horizon(image);

% change background to low intensity
image_mean = mean(image, 'all');
if image_mean > 100
    image = 255 - image;
end

image1 = histeq(image);

figure(1);
subplot(1, 2, 1);
imshow(image1);
subplot(1, 2, 2);
imhist(image1);

image2 = imbinarize(image1, 0.75);
figure(2);
imshow(image2);

image3 = edge(image2, 'approxcanny');
figure(3);
imshow(image3);

se = strel('rectangle', [3, 3]);
image4 = imclose(image3, se);
figure(4);
imshow(image4);

image5 = imfill(image4, 'holes');
figure(5);
imshow(image5);

image6 = bwareaopen(image5, 1000);
figure(6);
imshow(image6);

B = bwboundaries(image6, 'noholes');

% cut digital numbers
[M, N] = size(image6);
shapes = [];
for k = 1 : length(B) 
    maxv = max(B{k});
    minv = min(B{k});
    height = maxv(1) - minv(1);
    width = maxv(2) - minv(2);
    h_ratio = height / M;
    w_ratio = width / N;
    ratio = height / width;
    if 0.3 <= h_ratio && h_ratio <= 0.8 && w_ratio <= 0.2 && 1 <= ratio && ratio <= 5
        shapes = cat(1, shapes, reshape([min(maxv+5, [M,N]); max(minv-5, 1)], 1, 2, 2));
    end
end

characters = []; 
figure('Name', 'Characters');
for i = 1 : size(shapes, 1)
    shape = squeeze(shapes(i, :, :));
    image_split = cut_character(image2, shape, false);
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