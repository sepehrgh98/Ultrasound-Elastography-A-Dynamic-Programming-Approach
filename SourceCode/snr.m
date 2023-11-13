a=imread('cameraman.tif');
a=im2double(a);
window= a(20:40,20:40);

S= sum(window, "all");
mean=S/(size(window,1)*size(window,2));

tmp=0;
for i=1:size(window,1)
    for j=1:size(window,2)
        tmp=tmp+(window(i,j)-mean).^2;
    end
end

variance = sqrt((1/(size(window,1)*size(window,2)))*tmp);

%%% SNR (db)
%     SNR = 20*log10(rms(signal)/rms(noise));
SNR = 20*log10(mean/variance)

%%% SNR (Power)
%     SNR = rms(signal)/rms(noise);
SNR = mean/variance



