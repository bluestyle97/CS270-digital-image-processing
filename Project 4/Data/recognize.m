clc;
close all;
clear;

fp = fopen('results.txt', 'w');
for k = 1 : 40
    license_plate = imread(['Licenses/', int2str(k), '.jpg']);
    license_plate = horizon(license_plate);     % horizontalization
    characters = recognize_characters(license_plate, ['Characters/', int2str(k)]);
    fprintf(fp, '%s\n', characters);
end