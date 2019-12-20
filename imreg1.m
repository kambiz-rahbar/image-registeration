% kambiz.rahbar@gmail.com, 2019

clc
clear
close all

%% load ortho and unregistered images
orthophoto = imread('r40635_39_satellite_image_pleiades_barra_da_tujica_brazil_20160421-2.jpg');
figure(1); imshow(orthophoto); title('orthophoto');

unregistered = imread('r40640_39_satellite_image_terrasar-x_barra_da_tujica_brazil_2016-2.jpg');
figure(2); imshow(unregistered); title('unregistered');

%% load correspondence points
if exist('regdata1.mat','file')
    load('regdata1.mat');
end
[movingPoints, fixedPoints] = cpselect(unregistered, orthophoto, movingPoints, fixedPoints, 'Wait', true);
%save('regdata1.mat','fixedPoints','movingPoints');

%% apply registeration
mytform = fitgeotrans(movingPoints, fixedPoints, 'projective');
registered = imwarp(unregistered,mytform,'OutputView',imref2d(size(orthophoto)));

%% blend ortho and registered images and ask user for image cropping, then save results
blend = uint8((registered + orthophoto)/2);
figure(3);
[~, rect] = imcrop(blend);

croped_orthophoto = imcrop(orthophoto,rect);
croped_registered = imcrop(registered,rect);

figure(4);
subplot(1,2,1); imshow(croped_orthophoto);
subplot(1,2,2); imshow(croped_registered);

imwrite(croped_orthophoto,'MS1.tif');
imwrite(croped_registered,'PAN1.tif');

