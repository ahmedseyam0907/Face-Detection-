img = imread("C:\Users\AFC\Desktop\Uni-Shit\DIP-Project\Test Images\IMG_20250410_201344.jpg");
img = imresize(img, [300 300]);

imginycbcr = rgb2ycbcr(img);
Cb = imginycbcr(:,:,2);
Cr = imginycbcr(:,:,3);

skinrangemask = (Cb >= 77 & Cb <= 130) & (Cr >= 140 & Cr <= 160);

[rows, cols] = size(skinrangemask);
upperpartmask = false(size(skinrangemask));
upperpartmask(1:round(rows*0.75), :) = true; 
skininupperpart = skinrangemask & upperpartmask;

skininupperpart = imfill(skininupperpart, 'holes');
skininupperpart = bwareaopen(skininupperpart, 200);

result = regionprops(skininupperpart, 'BoundingBox', 'Eccentricity');
imshow(img); hold on;
face = 0;

for i = 1:length(result)
eccen = result(i).Eccentricity;
if eccen < 0.9
rect = result(i).BoundingBox;

facepart = imcrop(img, rect);
gfacepart = rgb2gray(facepart);
gfacepart = double(gfacepart);
gfacepart = (gfacepart - min(gfacepart(:))) / (max(gfacepart(:)) - min(gfacepart(:))) * 255;
gfacepart = uint8(gfacepart);


eyespart = gfacepart < 60; 
eyespart = bwareaopen(eyespart, 8);
eyesresult = regionprops(eyespart, 'BoundingBox');

nosepart = (gfacepart > 80) & (gfacepart <120); 
nosepart = bwareaopen(nosepart, 20);
noseresult = regionprops(nosepart, 'BoundingBox');

       
if length(eyesresult) >= 2 && ~isempty(noseresult)
            
rectangle('Position', rect, 'EdgeColor', 'cyan', 'LineWidth',3);
face = 1;
end
end
end

if face == 1
title('Face Detected');
else
title('No Face Detected');
end