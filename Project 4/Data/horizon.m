function [license] = horizon(image)
%image: RGB车牌图像
%return 调整为水平的车牌
%通过计算边缘水平方向的和来使车牌水平
maxsum=0;
license=image;

for angle=-30:0.5:30
    templicense=edge(imrotate(rgb2gray(image),angle,'bilinear'));
    se=strel('line',10,0);
    templicense=imerode(templicense,se);
    tempsum=sort(sum(templicense,2),'descend');
    if sum(tempsum(1:2))>maxsum
        maxsum=sum(tempsum(1:2));
        license=imrotate(rgb2gray(image),angle,'bilinear');
    end
end
[M,N]=size(license);
tempsum=sum(edge(license,'Canny'),2);
sortedsum=sort(tempsum,'descend');
startpoint=find(tempsum==sortedsum(1));
startvalue=sortedsum(1);
tempsum(max(1,startpoint-100):min(M,startpoint+100),1)=0;
sortedsum=sort(tempsum,'descend');
endpoint=find(tempsum==sortedsum(1));
endvalue=sortedsum(1);
if abs(startvalue-endvalue)>N/2
    if startpoint>M/2
        license=license(1:startpoint,:);
    else
        license=license(startpoint:M,:);
    end
else
    if startpoint>endpoint
        license=license(endpoint:startpoint,:);
    else
        license=license(startpoint:endpoint,:);
    end
end
end

