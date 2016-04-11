function [rawFiles, names,s ] = imgIn( dirpath, vargin)

    files = dir(strcat(dirpath,'*.pgm'));
    names = zeros(length(files),1);
    if length(files) <1
        disp('There are no files in the supplied directory.');
        return;
    end
    tstimg = imread(strcat(dirpath,files(1).name));
    s=size(tstimg);
    number_of_files_to_read= length(files);
    if(nargin>1)
        number_of_files_to_read=vargin;
    end
    % Assumes here that all the images in the folder are of same size;
    rawFiles = zeros(prod(size(tstimg)),number_of_files_to_read);
    clear tstimg;
    for i =1 : number_of_files_to_read
        rawimg=double(imread(strcat(dirpath,files(i).name),'pgm'));
        k = strsplit(files(i).name,'_');
        names(i) = str2double(cell2mat(k(1)));
        rawFiles(:,i)= reshape(rawimg,prod(size(rawimg)),1);
    end
    
    assignin('base','imgRow',s(1));
    assignin('base','imgCol',s(2));
end