img1 = double(rgb2gray(imread('down.bmp')));
img2 = double(rgb2gray(imread('left.bmp')));
img3 = double(rgb2gray(imread('right.bmp')));
img4 = double(rgb2gray(imread('up.bmp')));

%imgMax is a uint8 image which is the maximum of all the 4 images
imgMax = img1;
imgRat1 = img1;
imgRat2 = img2;
imgRat3 = img3;
imgRat4 = img4;

threshold = 0.65;

for i=1:size(img1,1)
    for j=1:size(img1,2)
        imgMax(i,j) = uint8(max(img1(i,j), max(img2(i,j), max(img3(i,j), img4(i,j)))));
        % If its near 0, its a shadow, else its a not a shadow
        imgRat1(i,j) = img1(i,j) ./ imgMax(i,j);
        imgRat2(i,j) = img2(i,j) ./ imgMax(i,j);
        imgRat3(i,j) = img3(i,j) ./ imgMax(i,j);
        imgRat4(i,j) = img4(i,j) ./ imgMax(i,j);
        if imgRat1(i,j) >= threshold
            imgRat1(i,j) = 1;
        else
            imgRat1(i,j) = 0;
        end
        if imgRat2(i,j) >= threshold
            imgRat2(i,j) = 1;
        else
            imgRat2(i,j) = 0;
        end
        if imgRat3(i,j) >= threshold
            imgRat3(i,j) = 1;
        else
            imgRat3(i,j) = 0;
        end
        if imgRat4(i,j) >= threshold
            imgRat4(i,j) = 1;
        else
            imgRat4(i,j) = 0;
        end
    end
end

%%These would give us the boundaries but if the shadow is too large, it
%%won't work
imgFin = imgRat1 .* imgRat2;
imgFin = imgFin .* imgRat3;
imgFin = imgFin .* imgRat4;
%figure();
%imshow(imgFin);

%Find only the sudden changes, so values will be 1 if its a boundary, 0 if
%its not a boundary. These sudden changes correspond to the shadow, so we
%will get the boundaries of the images
imgRat1 = conv2(imgRat1, [-1 -1 -1 -1; -1 0 0 -1; 1 0 0 1; 1 1 1 1]);
imgRat4 = conv2(imgRat4, [1 1 1 1; 1 0 0 1; -1 0 0 -1; -1 -1 -1 -1]);
imgRat2 = conv2(imgRat2, [-1 -1 1 1; -1 0 0 1; -1 0 0 1; -1 -1 1 1]);
imgRat3 = conv2(imgRat3, [1 1 -1 -1; 1 0 0 -1; 1 0 0 -1; 1 1 -1 -1]);

%Remove additional rows/columns
imgRat1 = imcrop(imgRat1, [2 2 size(imgRat1,2)-4 size(imgRat1,1)-4]);
imgRat2 = imcrop(imgRat2, [2 2 size(imgRat2,2)-4 size(imgRat2,1)-4]);
imgRat3 = imcrop(imgRat3, [2 2 size(imgRat3,2)-4 size(imgRat3,1)-4]);
imgRat4 = imcrop(imgRat4, [2 2 size(imgRat4,2)-4 size(imgRat4,1)-4]);

imgEdges = imgRat1 + imgRat2 + imgRat3 + imgRat4;

%1's are where the shadow was and we consider these as the edges, all 0 or
%-ve values will be treated as black -> no boundary
figure();
imshow(imgEdges);

