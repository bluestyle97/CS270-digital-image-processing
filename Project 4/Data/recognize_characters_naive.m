function characters = recognize_characters(image, folder)

% image:    grayscale image
% folder:   folder to save character images

image_denoised = medfilt2(image, [11, 11]);
image_edge = edge(image_denoised, 'Canny');
se = strel('rectangle', [1, 1]);
image_closed = imclose(image_edge, se);
image_filled = imfill(image_closed, 'holes');
image_removed = bwareaopen(image_filled, 1000);
se = strel('rectangle', [3, 3]);
image_eroded = imerode(image_removed, se);
B = bwboundaries(image_eroded, 'noholes');

% cut digital numbers
[M, N] = size(image_eroded);
shapes = zeros(length(B), 2, 2);
for k = 1 : length(B) 
    maxv = max(B{k});
    minv = min(B{k});
    shapes(k, :, :) = [min(maxv+5, [M,N]); max(minv-5, 1)];
end

if exist(folder, 'dir') == 0
    mkdir(folder);
end

characters = [];
for i = 1 : length(B)
    shape = squeeze(shapes(i, :, :));
    image_split = cut_character(image_denoised, shape, true);
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

