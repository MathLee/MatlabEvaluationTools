clear;
clc;
close all;

imPath = '/home/lgy/flownet2-master/RGBT_MODEL/dataset/RGBT_VT821/RGB/';
TPath = '/home/lgy/flownet2-master/RGBT_MODEL/dataset/RGBT_VT821/T/';
files = dir([imPath '*.jpg']);
num1 = length(files);

IMAGE_DIM_H = 288;
IMAGE_DIM_W = 288;

im_R = zeros(IMAGE_DIM_H,IMAGE_DIM_W);
im_G = zeros(IMAGE_DIM_H,IMAGE_DIM_W);
im_B = zeros(IMAGE_DIM_H,IMAGE_DIM_W);

imT_R = zeros(IMAGE_DIM_H,IMAGE_DIM_W);
imT_G = zeros(IMAGE_DIM_H,IMAGE_DIM_W);
imT_B = zeros(IMAGE_DIM_H,IMAGE_DIM_W);

for i = 1 : num1
    im = imread([imPath files(i).name]);    
    im = single(im);
    im = imresize(im, [IMAGE_DIM_H IMAGE_DIM_W], 'bilinear');
    im_R = im(:,:,1) + im_R;
    im_G = im(:,:,2) + im_G;
    im_B = im(:,:,3) + im_B;
    
    imT = (imread([TPath files(i).name(1:end-4) '.jpg' ]));
    imT = single(imT);
    imT = imresize(imT, [IMAGE_DIM_H IMAGE_DIM_W], 'bilinear');
    imT_R = imT(:,:,1) + imT_R;
    imT_G = imT(:,:,2) + imT_G;
    imT_B = imT(:,:,3) + imT_B; 
   
end

% num_all = num1;
% im_R_mean = sum(sum(im_R/num_all))/(IMAGE_DIM_H*IMAGE_DIM_W);
% im_G_mean = sum(sum(im_G/num_all))/(IMAGE_DIM_H*IMAGE_DIM_W);
% im_B_mean = sum(sum(im_B/num_all))/(IMAGE_DIM_H*IMAGE_DIM_W);
% 
% imT_R_mean = sum(sum(imT_R/num_all))/(IMAGE_DIM_H*IMAGE_DIM_W);
% imT_G_mean = sum(sum(imT_G/num_all))/(IMAGE_DIM_H*IMAGE_DIM_W);
% imT_B_mean = sum(sum(imT_B/num_all))/(IMAGE_DIM_H*IMAGE_DIM_W);
% 
% display(['im_R_mean: ' num2str(im_R_mean) ', im_G_mean: ' num2str(im_G_mean) ', im_B_mean: ' num2str(im_B_mean) ]);
% display(['T_R_mean: ' num2str(imT_R_mean) ', T_G_mean: ' num2str(imT_G_mean) ', T_B_mean: ' num2str(imT_B_mean) ]);


%%
imPath = '/home/lgy/flownet2-master/RGBT_MODEL/dataset/RGBT_VT1000/RGB/';
TPath = '/home/lgy/flownet2-master/RGBT_MODEL/dataset/RGBT_VT1000/T/';
files2 = dir([imPath '*.png']);
num2 = length(files2);

for j = 1 : num2
    im = imread([imPath files2(j).name]);    
    im = single(im);
    im = imresize(im, [IMAGE_DIM_H IMAGE_DIM_W], 'bilinear');
    im_R = im(:,:,1) + im_R;
    im_G = im(:,:,2) + im_G;
    im_B = im(:,:,3) + im_B;
    
    imT = (imread([TPath files2(j).name(1:end-4) '.png' ]));
    imT = single(imT);
    imT = imresize(imT, [IMAGE_DIM_H IMAGE_DIM_W], 'bilinear');
    imT_R = imT(:,:,1) + imT_R;
    imT_G = imT(:,:,2) + imT_G;
    imT_B = imT(:,:,3) + imT_B; 
    
end

num_all = num1 + num2;
im_R_mean = sum(sum(im_R/num_all))/(IMAGE_DIM_H*IMAGE_DIM_W);
im_G_mean = sum(sum(im_G/num_all))/(IMAGE_DIM_H*IMAGE_DIM_W);
im_B_mean = sum(sum(im_B/num_all))/(IMAGE_DIM_H*IMAGE_DIM_W);

imT_R_mean = sum(sum(imT_R/num_all))/(IMAGE_DIM_H*IMAGE_DIM_W);
imT_G_mean = sum(sum(imT_G/num_all))/(IMAGE_DIM_H*IMAGE_DIM_W);
imT_B_mean = sum(sum(imT_B/num_all))/(IMAGE_DIM_H*IMAGE_DIM_W);

display(['im_R_mean: ' num2str(im_R_mean) ', im_G_mean: ' num2str(im_G_mean) ', im_B_mean: ' num2str(im_B_mean) ]);
display(['T_R_mean: ' num2str(imT_R_mean) ', T_G_mean: ' num2str(imT_G_mean) ', T_B_mean: ' num2str(imT_B_mean) ]);

% im_R_mean: 129.4971, im_G_mean: 132.4638, im_B_mean: 127.1397
% T_R_mean: 174.2724, T_G_mean: 77.3299, T_B_mean: 86.1234


