clear;
close all;
clc;

%% License Plate Extraction

% convert rgb to grayscale
license = imread('./License_plates.jpg');
figure(1);
imshow(license);
title('RGB');

gray_license = rgb2gray(license);
figure(2);
imshow(gray_license);
title('Grayscale');

% histogram equalization
hiseq_license = histeq(gray_license);
figure(3);
imshow(hiseq_license);
title('Histogram Equalization');

% calculate std and median filtering
std_image = hiseq_license;
[M,N] = size(hiseq_license);
for i = 10 : M-10
    for j = 10 : N-10
        a = double(gray_license(i-9:i+9, j-9:j+9));
        std_image(i,j) = std(a(:));
    end
end
med_license = medfilt2(gray_license+uint8(255-255*std_image), [7, 7]);
figure(4);
imshow(med_license);
title('Median Filtered');

% dilation and obtain connected components
se1 = strel('line', 15, 0);
B = bwboundaries(imdilate(bwareaopen(med_license>92, 1000), se1), 'noholes');

% save the sizes and rectangular shapes of all connected components
sizes = zeros(length(B), 1);
shapes = zeros(length(B), 2, 2);
for k = 1 : length(B) 
    maxv = max(B{k});
    minv = min(B{k});
    sizes(k, 1) = (maxv(:,1) - minv(:,1)) * (maxv(:,2) - minv(:,2));
    shapes(k, :, :) = [min(maxv+5, [M,N]); max(minv-5, 1)];
end

% sort by size and extract license plates
[sizes, index] = sort(sizes, 'descend');
background = zeros(M,N);
license_plates = {};
license_index = 1;
z = 1;
c = 1;
for i = 1 : length(sizes)
    shape = squeeze(shapes(index(i), :, :));
    % delete plates whose size is small
    if sum(sum(background(shape(2,1):shape(1,1), shape(2,2):shape(1,2)))) < sizes(i)/2 && sizes(i) > 50000 && sizes(i) < 125000 && mean(std(double(rgb2gray(license(shape(2,1):shape(1,1),shape(2,2):shape(1,2), :, :))))) > 15
        z = z + 1;
        license_plates{license_index, 1} = license(shape(2,1):shape(1,1), shape(2,2):shape(1,2), :, :);
        license_index = license_index+1;
        background(shape(2,1):shape(1,1), shape(2,2):shape(1,2)) = 1;
    % large plates, split them
    elseif sizes(i) > 125000
        temp_license = split_license(license(shape(2,1):shape(1,1), shape(2,2):shape(1,2), :, :));
        for j = 1 : length(temp_license)
            if mean(std(double(rgb2gray(temp_license{j})))) > 10
                c = c + 1;
                license_plates{license_index, 1} = temp_license{j};
                license_index = license_index + 1;
            end
        end
    end
end

% save extracted license plates
if exist('Licenses', 'dir') == 0
    mkdir('Licenses')
end
for k = 1 : length(license_plates) 
    imwrite(license_plates{k}, ['Licenses/', num2str(k), '.jpg']);
end

%% Character Recognition

fp = fopen('results.txt', 'w');
for k = 1 : length(license_plates)
    license_plate = imread(['Licenses/', int2str(k), '.jpg']);
    license_plate = horizon(license_plate);     % horizontalization
    characters = recognize_characters(license_plate, ['Characters/', int2str(k)]);
    fprintf(fp, '%s\n', characters);
end