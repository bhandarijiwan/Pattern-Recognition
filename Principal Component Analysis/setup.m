function [ output_args ] = setup(trainFilesLocation, genFilesLocation)
%   This function generates the  eigen vectors and coefficients 
%   and saves them in 'eigenvecs.csv' and 'coeff.csv' respectively.
%   It will also save all the  eigen values in 'eigenvals.csv' and will
%   also save the covariance matrix in 'cov.csv';

% Data that is generated is going to be inside gen_data_loc.
% gen_data_loc='./Data/Train/gen/';
gen_data_loc=genFilesLocation;

if ~exist(gen_data_loc,'dir')
    mkdir(gen_data_loc);
    regenerate=true;
elseif ~exist(strcat(gen_data_loc,'covmat.csv'),'file') ...
               || ~exist(strcat(gen_data_loc,'eigvals.csv'),'file')...
               || ~exist(strcat(gen_data_loc,'eigenvecs.csv'),'file') ...
               || ~exist(strcat(gen_data_loc,'coeff.csv'),'file' )...
               || ~exist(strcat(gen_data_loc,'fid.csv'),'file')
           regenerate=true;
else
    regenerate=false;
end

default_Train_Loc=trainFilesLocation;
% default_Train_Loc='./Data/Train/fa_H/';
files = dir(strcat(default_Train_Loc,'*.pgm'));

% By default use all the images for training. This might take a lot of
% time. There is a lot 1200+ in the folder.
files_to_use=length(files);
[trainFiles , fnames]=imgIn(default_Train_Loc);

avgFace= mean(trainFiles,2);
trainFiles = bsxfun(@minus,trainFiles,avgFace);
assignin('base','avgFace',avgFace);
clear avgFace;
if regenerate
    
    % Covariance Matrices
    covmat= 1/(files_to_use-1) .* (trainFiles * trainFiles');
    csvwrite(strcat(gen_data_loc,'covmat.csv'),covmat);
    % calculate the M eigen vectors/values for covmat using M eigen vectors/
    % values of trainFiles'*trainFiles (M*M) rather than trainFiles * trainFiles' (N^2*N^2)
    AAT = trainFiles * trainFiles';
    ATA = trainFiles'*trainFiles;
    
    [eigvecs, eigvals]= eig(ATA);
    
    [eigvals,I]=sort(diag(eigvals),1,'descend');
    csvwrite(strcat(gen_data_loc,'eigvals.csv'),eigvals);
    eigvecs= eigvecs(:,I);
    % eigen vector transformed to N^2 dimension.
    % eigvecs now contains the M best eigen vectors of AAT;
    eigvecs = trainFiles * eigvecs;
    
    % Make the eigen vectors orthonormal;
    eigvecs = bsxfun(@rdivide,eigvecs,sqrt(sum(eigvecs.*eigvecs)));
    csvwrite(strcat(gen_data_loc,'eigenvecs.csv'),eigvecs);
    
    %save the coefficients as column vectors.
    w = eigvecs'*trainFiles; % coefficents of the image in eigen basis.
    csvwrite(strcat(gen_data_loc,'coeff.csv'),w);
    % Finally save the file identifiers in fid.csv as column vector.
    csvwrite(strcat(gen_data_loc,'fid.csv'),fnames);
else
    covmat=csvread(strcat(gen_data_loc,'covmat.csv'));
    eigvals = csvread(strcat(gen_data_loc,'eigvals.csv'));
    eigvecs = csvread(strcat(gen_data_loc,'eigenvecs.csv'));
    w = csvread(strcat(gen_data_loc,'coeff.csv'));
    fnames= csvread(strcat(gen_data_loc,'fid.csv'));
end

assignin('base','covmat',covmat);
assignin('base','eigvals',eigvals);
assignin('base','eigvecs',eigvecs);
assignin('base','coeffs',w);
assignin('base','fids',fnames);
assignin('base','trainFiles',trainFiles);
end


