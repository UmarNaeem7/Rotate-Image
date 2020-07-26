function [d] = imageRotate(image, angle)
%Rotate image by the given angle in counter-clockwise direction
%   Detailed explanation goes here
a = image;

%optimize solution for degrees that are multiples of 90
%we will also not need any padding for these cases
if angle==90
    %transpose will be similar to this rotation
    [p,q,r] = size(a);
    if r==1
        b = transpose(a);
    else
        e = a(:,:,1);
        e1 = transpose(e);
        f = a(:,:,2);
        f1 = transpose(f);
        g = a(:,:,3);
        g1 = transpose(g);
        b = zeros(q,p,r);
        b(:,:,1) = e1;
        b(:,:,2) = f1;
        b(:,:,3) = g1;
    end
    d = uint8(b);
elseif angle==180
    %flip image will be similar to this rotation
    [p,q,r] = size(a);
    b = zeros(p,q,r);
    b(end:-1:1, end:-1:1, :) = a(1:end, 1:end, :);
    d = uint8(b);
elseif angle==270
    %transpose of flipped image will be similar to this rotation
    [p,q,r] = size(a);
    b = zeros(p,q,r);
    b(end:-1:1, end:-1:1, :) = a(1:end, 1:end, :);
    if r==1
        c = transpose(b);
    else
        e = b(:,:,1);
        e1 = transpose(e);
        f = b(:,:,2);
        f1 = transpose(f);
        g = b(:,:,3);
        g1 = transpose(g);
        c = zeros(q,p,r);
        c(:,:,1) = e1;
        c(:,:,2) = f1;
        c(:,:,3) = g1;
    end
    d = uint8(c);
elseif angle==360
    %image will remain same for this rotation
    d = a;
else
    [p, q, s] = size(a);
    %preparing for padding image so that no information of image 
    %is not lost after rotation
    diagonal = sqrt(p^2 + q^2);
    col = ceil(diagonal - q) + 2;
    row = ceil(diagonal - p) + 2;
    b = zeros(p+row, q+col, s);
    b(ceil(row/2):(ceil(row/2)+p-1),ceil(col/2):(ceil(col/2)+q-1),:) = a;
    
    %image is padded with long black boundaries
    
    
    %find midpoints of image around which image is to be rotated
    midpointx = ceil((size(b, 1) + 1)/2);
    midpointy = ceil((size(b, 2) + 1)/2);
    
    d = zeros(size(b));
    
    %rotation
    for i=1:size(d, 1)
        for j=1:size(d, 2)
            
             %find new coordinates but also use midpoints
             x = (i-midpointx)*cosd(angle) + (j-midpointy)*sind(angle);
             y = (j-midpointy)*cosd(angle) - (i-midpointx)*sind(angle);
             x = round(x) + midpointx;
             y = round(y) + midpointy;
             
             %check if new coordinate is not negative and is in range
             if (x>=1 && y>=1 && x<=size(b,2) && y<=size(b,1))
                  d(i,j,:)=b(x,y,:);         
             end
    
        end
    end
    e = uint8(d);
    d = e;
end
    
end

