clc
clear
close
imagePath = "33.jpg";
windowSize = 2000;
ImageData = imread(imagePath);
ImageData = im2double(ImageData);

snr(ImageData, windowSize)
%Costs = Cost2D('inputArray1',[1:100;3:3:300],'inputArray2',[2:2:200;4:4:400],'displacement',[1:10;2:2:20]);