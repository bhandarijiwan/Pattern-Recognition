function [ trainFaces ] = applyMask( trainFiles)
%APPLYMASK Summary of this function goes here
%   Detailed explanation goes here

n=size(trainFiles);
trainFaces=struct();
for i=1:n
    trainFaces(i)=struct();
    
    smsk=double(trainFiles(i).msk);
    trainFaces(i).face = trainFiles(i).img;
    
    rch =trainFiles(i).img(:,:,1);
    rch =rch(smsk~=0);
    
    bch =trainFiles(i).img(:,:,2);
    bch =bch(smsk~=0);
    
    trainFaces(i).face=[rch bch];
    
end
end

