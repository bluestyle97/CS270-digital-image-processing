function [licenses] = split_license(oimage)

image=rgb2gray(oimage);
image=histeq(image,2);
image=bwareaopen(image,1000);
B = bwboundaries(image, 'noholes');
[M,N]=size(image);
size_map = containers.Map();
sizes=[];
for k = 1 : length(B)
    thisBoundary = B{k};
    maxv=max(B{k});
    minv=min(B{k});
    sizes=[sizes,(maxv(:,1)-minv(:,1))*(maxv(:,2)-minv(:,2))];
    size_map(num2str((maxv(:,1)-minv(:,1))*(maxv(:,2)-minv(:,2)))) = [min(maxv+5,[M,N]);max(minv-5,1)];
    %imwrite(License(minv(:,1):maxv(:,1),minv(:,2):maxv(:,2),:),['IMG/',num2str(k),'.jpg']);
end

sizes=sort(sizes,'descend');
background=zeros(M,N);
licenses = {};
image_index=1;
for i=1:length(sizes)
    shape=size_map(num2str(sizes(i)));
    if sum(sum(background(shape(2,1):shape(1,1),shape(2,2):shape(1,2))))<sizes(i)/2 && sizes(i)>50000 &&sizes(i)<130000
        licenses{image_index,1}=oimage(shape(2,1):shape(1,1),shape(2,2):shape(1,2),:,:);
        background(shape(2,1):shape(1,1),shape(2,2):shape(1,2))=1;
        image_index=image_index+1;
    elseif sizes(i)>=130000
        background(shape(2,1):shape(1,1),shape(2,2):shape(1,2))=1;
        if shape(1,1)-shape(2,1)>1/2*(shape(1,2)-shape(2,2))
            templicense=split_license2(permute(oimage(shape(2,1):shape(1,1),shape(2,2):shape(1,2),:,:),[2,1,3]));
            for j=1:length(templicense)
                licenses{image_index,1}=permute(templicense{j},[2,1,3]);
                image_index=image_index+1;
            end
        else
            templicense=split_license2(oimage(shape(2,1):shape(1,1),shape(2,2):shape(1,2),:,:));
            for j=1:length(templicense)
                licenses{image_index,1}=templicense{j};
                image_index=image_index+1;
            end
        end
    end
end

end