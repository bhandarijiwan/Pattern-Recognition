function [ k ] = formatLibSVM( dataMatrix,resolution,fold,varargin)
%Format the given data matrix into libsvm data format.
%   Assumes each data instance is along the column and 
%   features along the row. Each row is a feature and each 
%   column is a sample.

dataMatrix = dataMatrix';    

foldscalefilepath = sprintf('../Data/%s/LibData/fold_%i_scale.txt',resolution,fold);


optype = varargin{2};
% if nargin==3
%     optype='train';
% else
%     optype='test';
% end
% If training data then save the scale and if
% testing data then reuse the scale.
% scale the data in the range [-1,1];
dataMatrix = scaleData(dataMatrix,[-1,1],optype,foldscalefilepath); 
B = repmat(1:size(dataMatrix,2),size(dataMatrix,1),1);
k = reshape([B;dataMatrix],size(dataMatrix,1),size(dataMatrix,2)*2);

trainDataFilePath = sprintf('../Data/%s/LibData/%s_fold_%i.txt',resolution,optype,fold);
fileID = fopen(trainDataFilePath,'w');
label = varargin{1};
label = label';

for i_row=1:size(k,1)
    fprintf(fileID,' %i ',label(i_row));
    fprintf(fileID,' %i:%.5f ',k(i_row,:));
    fprintf(fileID,' \n');
end
fclose(fileID);


end

function [data]= scaleData(dataMatrix,range,optype,foldscalefilepath)
    % column wise scaling.
    if(strcmpi(optype,'train'));
        mindata = min(dataMatrix);
        maxdata = max(dataMatrix);
        dlmwrite(foldscalefilepath,[mindata' maxdata']);
    elseif(strcmpi(optype,'test'))
        scaledata = dlmread(foldscalefilepath,',');
        mindata= scaledata(:,1)';
        maxdata= scaledata(:,2)';
    else
    end
    data=range(1) + ...
         2 * (dataMatrix - repmat(mindata,size(dataMatrix,1),1))... 
         ./ repmat(maxdata-mindata,size(dataMatrix,1),1);      
end





 



