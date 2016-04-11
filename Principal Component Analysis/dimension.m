function [ k ] = dimension( percentInf, eigvals,varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
eigSum = sum(eigvals);
% preserve % of the information 
eigSumPre= percentInf*eigSum;
s=0;
k=1;
while(s<=eigSumPre)
    s=s+eigvals(k)   ;
    k=k+1; % k holds the index 
end
k=k-1;
end

