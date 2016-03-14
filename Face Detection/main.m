
%% FACE DETECTION USING SKIN COLOR DISTRIBUTION
%Prompt Available at : http://www.cse.unr.edu/~bebis/CS479/Ass/Prog2.pdf
%
%
%% Face Detection in Chromatic color Space.
%  Run this block of code for part 3.a of the prompt.

%%%%%%----Training the Model --------%%%%%%%%
% Training data is going to be inside './Data/Training/' folder with in  
% the same directory as this script. Each training image is going to have 
% filename 'Training_#.ppm'. Each such training image will have a mask image
% named as 'ref#.ppm'. 

% Read the images from the training folder.

dirpath = './Data/Training/';

trainFiles = imgIn(dirpath,'training',1);

%%% Apply the mask to the faces %%%%
trainFaces=applyMask(trainFiles);

%Maximum Likelihood Esitmation of parameters.
imgDistModel = mlest(trainFaces(1).face);

thres = mvnpdf(trainFaces(1).face,imgDistModel.mean,...
            imgDistModel.covariance);

% range for threshold.        
minthres = min(thres);
maxthres = max(thres);
step=(maxthres-minthres)/200;
t = minthres:step:maxthres-step;
clear trainFiles;

plotdistribution(imgDistModel.mean,imgDistModel.covariance);

%%%%%%--- Test the model -----%%%%%%% 
%%Test data resides in'./Data/Training/' directory 
% within the sa same directory as this
% script.Each test image is going to have filename 'Test_#.ppm'. Each test
% image will have a mask image named as 'ref#.ppm'.

% Read the image and extract the channels
dirpath = './Data/Test/';
testFiles = imgIn(dirpath,'test',1);
rch = testFiles(1).img(:,:,1);
gch = testFiles(1).img(:,:,2);
[row,col]=size(rch);

% calcuate the pdf for each pixel
rch=rch(:); % reshape red channel as a column vector.
gch=gch(:); % reshape blue channel as a column vector. 
% calculate the pdf for each pixel
gx = mvnpdf([rch gch],imgDistModel.mean,imgDistModel.covariance);
% range for threshold.
% t = 50:0.5:194;
%   120.4147
%%% ---Now threshold each pixel %%%
fp=zeros(size(t));
fn=zeros(size(fp));
i=1;
detectMask = zeros(length(rch),1,'uint8');
for thres=t
    k=gx>=thres;
    detectMask(k)=1;
    detectMask(~k)=0;
    msk = testFiles(1).msk(:);
    %-- false positives
    fp(i)=sum(detectMask>msk)/length(msk);
    %---false negative 
    fn(i)=sum(msk>detectMask)/length(msk);
    i=i+1;
end

figure(2);
hold off;
plot(t,fp,'r--','LineWidth',1.4);
hold on;
plot(t,fn,'G--','Linewidth',1.4);
indxs= round(fn,5)==0.02591;
[val,indxs]=max(indxs);
plot(t(indxs),fn(indxs),'R*');
legend('False Positive','False Negative');

xlabel('threshold','FontWeight','bold','FontSize',15);
ylabel('Error rate ( as % of total pixels)','FontWeight','bold','FontSize',15)
title('ROC (Error rate vs threshold) ','FontWeight','bold','FontSize',15);

sprintf('Threshold %f',t(indxs))
sprintf('False Negatives  %f',fn(indxs))
sprintf('False Positives  %f',fp(indxs))


figure(3)
hold off;
plot(fn,fp,'-','LineWidth',1.4);
xlabel('False Negatives','FontWeight','bold','FontSize',15);
ylabel('False Positives','FontWeight','bold','FontSize',15);
title('ROC false negative vs false positives','FontWeight','bold','FontSize',15);

viz = imread(strcat(dirpath,'Test_1.ppm'),'ppm');


%%%% Analytically find the point po


k=gx>=t(indxs);
detectMask(k)=1;
detectMask(~k)=0;
detectMask=reshape(detectMask,row,col);
viz(:,:,1)=viz(:,:,1).*detectMask;
viz(:,:,2)=viz(:,:,2).*detectMask;
viz(:,:,3)=viz(:,:,3).*detectMask;
figure(4)
imshow(viz);


%% Face Detection YCbCr color space
% Run this block of code for part 3.b of the prompt.
%

% Read the images from the training folder.

dirpath = './Data/Training/';

trainFiles = imgIn(dirpath,'training',0);


%%% Apply the mask to the faces %%%%
trainFaces=applyMask(trainFiles);

% trainFaces(1).face=double(trainFaces(1).face);

imgDistModel = mlest(trainFaces(1).face);

thres = mvnpdf(trainFaces.face,imgDistModel.mean,...
            imgDistModel.covariance);

% range for threshold.        
minthres = min(thres);
maxthres = max(thres);
step=(maxthres-minthres)/100;
t = minthres:step:maxthres-step;



%mean value of thres;
clear trainFiles;
% plotdistribution(imgDistModel.mean,imgDistModel.covariance);
%%%%%%--- Test the model -----%%%%%%% 
% Read the image and extract the channels
dirpath = './Data/Test/';
testFiles = imgIn(dirpath,'test',0);
rch = testFiles(1).img(:,:,1);
gch = testFiles(1).img(:,:,2);
[row,col]=size(rch);

% calcuate the pdf for each pixel
rch=rch(:); % reshape red channel as a column vector.
gch=gch(:); % reshape blue channel as a column vector. 
% calculate the pdf for each pixel
gx = mvnpdf([rch gch],imgDistModel.mean,imgDistModel.covariance);

%%% ---Now threshold each pixel %%%
fp=zeros(size(t));
fn=zeros(size(fp));
i=1;
detectMask = zeros(length(rch),1,'uint8');
for thres=t
    k=gx>=thres;
    detectMask(k)=1;
    detectMask(~k)=0;
    msk = testFiles(1).msk(:);
    %-- false positives
    fp(i)=sum(detectMask>msk)/length(msk);
    %---false negative 
    fn(i)=sum(msk>detectMask)/length(msk);
    i=i+1;
end

figure(2);
hold off;
plot(t,fp,'r--','LineWidth',1.4);
hold on;
plot(t,fn,'G--','Linewidth',1.4);
indxs= round(fn,5)==0.01851;
[val,indxs]=max(indxs);
plot(t(indxs),fn(indxs),'R*');

legend('False Positive','False Negative');
xlabel('threshold');
ylabel('Misclassified (as % of total pixels)')
title('ROC (Error rate vs threshold) ');

sprintf('Threshold %f',t(indxs))
sprintf('False Negatives : %f',fn(indxs))
sprintf('False Positives : %f',fp(indxs))

figure(3)
hold off;
plot(fn,fp,'-','LineWidth',1.4);



xlabel('False Negatives');
ylabel('False Positives');
title('ROC false negative vs false positives');

viz = imread(strcat(dirpath,'Test_1.ppm'),'ppm');

%%% Analytically find the point po
k=gx>=t(indxs);
detectMask(k)=1;
detectMask(~k)=0;

detectMask=reshape(detectMask,row,col);

viz(:,:,1)=viz(:,:,1).*detectMask;
viz(:,:,2)=viz(:,:,2).*detectMask;
viz(:,:,3)=viz(:,:,3).*detectMask;
figure(4)
imshow(viz);



%%





