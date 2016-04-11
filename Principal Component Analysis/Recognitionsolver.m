%% (S1) SETUP BLOCK
% Run this block to setup the parameters for running the experiment on
% subsequent blocks.
% Running setup() will populate the base workspace with required data.
setup('./Data/Train/fa_H/','./Data/Train/gen/');

% Anonymous function to convert double values to grayscale values.
vec2gray =  @(vec) uint8((vec-min(vec))/(max(vec)- min(vec)).*255);

%%  VERIFICATION THAT THE PROGRAM IS WORKING CORRECTLY
%  To verify the programi is working correctly we read in training images,
%  project them into the eigen basis and calculate the coefficients. We
%  again resuse these coefficients to reconstruct the image using the eigen
%  basis. The reconstructed image should look visually similar to the
%  original image and the distance (euclidean) to the orginal image should
%  be very small. We plot the distance for each image at the end.

figure(10);
hold on;

xlim([0 200]);
ylim([0 500]);

xlim manual;
ylim manual;

% representing each face in othnoromal eigen basis using all the eigen
% vectors.
d=zeros(files_to_use,1);

for i=1:files_to_use
w = eigvecs'*trainFiles(:,i); % coefficents of the image in eigen basis.
% Reconstructing back to original space.
i_h = eigvecs * w;
d(i)=(eucliddist(i_h, trainFiles(:,i)));
end
eucliddist = @(X,Y) abs(sqrt(sum((X-Y).^2)));
plot(d);
%% EXPERIMENT :1 DISPLAY THE AVERAGE FACE AND TOP 10 AND BOTTOM 10 EIGEN FACES.
%Display the Average Face:
figure(9);
dispImg = vec2gray(avgFace);
dispImg = reshape(dispImg,imgRow,imgCol);
subplot(3,3,5);
imshow(dispImg);
title('Average Face');
% Display the Top 10 eigen faces:
figure(10);
for i=1:10
    dispImg = eigvecs(:,i);
    % transform to the grayscale;
    dispImg = vec2gray(dispImg);
    % reshape the column vector;
    dispImg = reshape(dispImg,imgRow,imgCol);
    subplot(2,5,i);
    imshow(dispImg);
    title(i);
end
suptitle('TOP 10 EIGEN FACES');

% Display the Last 10 eigen faces:
figure(12);
j=1;
for i=size(eigvecs,2)-9:size(eigvecs,2)
    dispImg = eigvecs(:,i);
    % transform to the grayscale;
    dispImg = vec2gray(dispImg);
    % reshape the column vector;
    dispImg = reshape(dispImg,imgRow,imgCol);
    subplot(2,5,j);
    imshow(dispImg);
    title(j);
    j=j+1;
end
suptitle('10 SMALLEST EIGEN FACES');
%% (S2) Run this part before the following;

default_Test_Loc='./Data/Test/fb_H/';
[testFiles, tstnames,s] = imgIn(default_Test_Loc);
testFiles = bsxfun(@minus,testFiles,avgFace);

%% Part (3.a.II) Recognition:
% Make sure you have run S1 & S2 once before running this block.

% Preserve 80% of the information.
recognitionNplot(testFiles,trainFiles,0.8,coeffs,...
                               eigvecs,eigvals,fids,tstnames,avgFace,imgRow,imgCol);

%% Part (3.a.V)
% Make sure you have run S1 & S2 once before running this block.

% Preserve 90% of the information.
recognitionNplot(testFiles,trainFiles,0.9,coeffs,...
    eigvecs,eigvals,fids,tstnames,avgFace,imgRow,imgCol);

% Preserve 95% of the information.
recognitionNplot(testFiles,trainFiles,0.95,coeffs,...
    eigvecs,eigvals,fids,tstnames,avgFace,imgRow,imgCol);

%% (S3) Setup for part 3.B;


setup('./Data/Train/fa_H2/','./Data/Train/gen1/');

default_Test_Loc='./Data/Test/fb_H/';
[testFiles, tstnames,s] = imgIn(default_Test_Loc);
testFiles = bsxfun(@minus,testFiles,avgFace);



%% Part 3.B test the performance of the eigenface approach on faces not in... 
   % the gallery set (i.e., intruders)

recognitionNROCplot(testFiles,0.95,coeffs,...
                               eigvecs,eigvals,fids,tstnames);   
  

                           
                           
%% Experimenting with Low resolution images: (SETUP Parameters)
% 
setup('./Data/Train/fa_L/','./Data/Train/genL/');

default_Test_Loc='./Data/Test/fb_L/';
[testFiles, tstnames,s] = imgIn(default_Test_Loc);
testFiles = bsxfun(@minus,testFiles,avgFace);

% Anonymous function to convert double values to grayscale values.
vec2gray =  @(vec) uint8((vec-min(vec))/(max(vec)- min(vec)).*255);

%% EXPERIMENT :1_L DISPLAY THE AVERAGE FACE AND TOP 10 AND BOTTOM 10 EIGEN FACES.
%Display the Average Face:
figure(9);
dispImg = vec2gray(avgFace);
dispImg = reshape(dispImg,imgRow,imgCol);
subplot(3,3,5);
imshow(dispImg);
title('Average Face');
% Display the Top 10 eigen faces:
figure(10);
for i=1:10
    dispImg = eigvecs(:,i);
    % transform to the grayscale;
    dispImg = vec2gray(dispImg);
    % reshape the column vector;
    dispImg = reshape(dispImg,imgRow,imgCol);
    subplot(2,5,i);
    imshow(dispImg);
    title(i);
end
suptitle('TOP 10 EIGEN FACES');

% Display the Last 10 eigen faces:
figure(12);
j=1;
for i=size(eigvecs,2)-9:size(eigvecs,2)
    dispImg = eigvecs(:,i);
    % transform to the grayscale;
    dispImg = vec2gray(dispImg);
    % reshape the column vector;
    dispImg = reshape(dispImg,imgRow,imgCol);
    subplot(2,5,j);
    imshow(dispImg);
    title(j);
    j=j+1;
end
suptitle('10 SMALLEST EIGEN FACES');

%% Experiment (3.a.II_L) Recognition:
% Make sure you have run S1 & S2 once before running this block.

% Preserve 80% of the information.
recognitionNplot(testFiles,trainFiles,0.8,coeffs,...
                               eigvecs,eigvals,fids,tstnames,avgFace,imgRow,imgCol);


%% Part (3.a.V)
% Make sure you have run S1 & S2 once before running this block.

% Preserve 90% of the information.
recognitionNplot(testFiles,trainFiles,0.9,coeffs,...
    eigvecs,eigvals,fids,tstnames,avgFace,imgRow,imgCol);

% Preserve 95% of the information.
recognitionNplot(testFiles,trainFiles,0.95,coeffs,...
    eigvecs,eigvals,fids,tstnames,avgFace,imgRow,imgCol,31,32,33);

%% Part 3.B test the performance of the eigenface approach on faces not in... 
   % the gallery set (i.e., intruders)

setup('./Data/Train/fa_L2/','./Data/Train/genL/');

default_Test_Loc='./Data/Test/fb_L/';
[testFiles, tstnames,s] = imgIn(default_Test_Loc);
testFiles = bsxfun(@minus,testFiles,avgFace);

recognitionNROCplot(testFiles,0.95,coeffs,...
                               eigvecs,eigvals,fids,tstnames);   
  























