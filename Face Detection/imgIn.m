function [ rawFiles ] = imgIn( dirpath, traintest , ischorme)
%IMGIN Summary of this function goes here
%   Detailed explanation goes here

switch traintest
    case 'training'
        files = dir('./Data/Training/Training_*.ppm');
        imname1=strcat(dirpath,'Training_');
    case 'test'
        files = dir('./Data/Test/Test_*.ppm');
        imname1=strcat(dirpath,'Test_');
end
rawFiles = struct();
for i =1 : length(files)
    imname=strcat(imname1,sprintf('%d',i),'.ppm');
    if(exist(imname,'file')==2)
       maskname=(strcat(dirpath,sprintf('ref%d',i),'.ppm'));
         if(exist(maskname,'file')==2)
             
             if(ischorme)
                rawFiles(i).img = toChormatic(...
                                   imread(imname,'ppm'));
             else
                 rawFiles(i).img = rgb2ycbcr(...
                                   double(imread(imname,'ppm')));
               % We don't need the luminance componnet;
               rawFiles(i).img = rawFiles(i).img(:,:,2:3);
               
             end                               
             rawFiles(i).msk = imread(maskname,'ppm');
             rawFiles(i).msk = sum(rawFiles(i).msk,3);
             rawFiles(i).msk = (rawFiles(i).msk>=255);
         else
             continue;
         end
    else
        continue;
    end
end

end

