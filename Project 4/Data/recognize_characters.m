function characters = recognize_characters(image, folder)

% image:    horizontalized grayscale image
% folder:   folder to save character images

% change background to low intensity
image_mean = mean(image, 'all');
if image_mean > 100
    image = 255 - image;
end

image1 = histeq(image);
image2 = imbinarize(image1, 0.75);
image3 = edge(image2, 'approxcanny');
se = strel('rectangle', [3, 3]);
image4 = imclose(image3, se);
image5 = imfill(image4, 'holes');
image6 = bwareaopen(image5, 1000);

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

if exist(folder, 'dir') == 0
    mkdir(folder);
end

characters = []; 
for i = 1 : size(shapes, 1)
    shape = squeeze(shapes(i, :, :));
    image_split = cut_character(image2, shape, false);
    imwrite(image_split, [folder, '/', int2str(i), '.jpg']);
    
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

end

