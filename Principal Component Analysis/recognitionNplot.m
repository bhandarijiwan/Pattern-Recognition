function [] = recognitionNplot(testFiles,trainFiles,percentInf,coeffs,...
                               eigvecs,eigvals,fids,tstnames,avgFace,...
                               imgRow,imgCol, varargin)
% this function plots CMC graph for N=1:50; 
% takes as parameter the percentage of information to preserve.
%

% Anonymous function to convert double values to grayscale values.
vec2gray =  @(vec) uint8((vec-min(vec))/(max(vec)- min(vec)).*255);

fig1 =23;
fig2 =15;
fig3 =16;
switch nargin
    case 14
        [fig1,fig2,fig3]= deal(varargin{:});
    case 13
        [fig2,fig3]= deal(varargin{:});
end

dim = dimension(percentInf,eigvals);
topEigVecs = eigvecs(:,1:dim);

% project all the training images into this basis;
w = coeffs(1:dim,:);

% % now project all the test images into the reduced(k) dimesion.
w_test = topEigVecs'*testFiles;

% calculate the Mahalanobis between eigen coeffients for each test and train
% pair
% estimate the reduced covariance matrix.
rcovmat = cov(w');
D = pdist2(w_test',w','mahalanobis',rcovmat);

% plotting the cmc curve;
[D, I]= sort(D,2);
mfids  = repmat(fids,size(D,1),1);
mfids = mfids(I);
ycmc = zeros(50,1);
for N=1:50
    matches = sum(any((bsxfun(@eq,mfids(:,1:N),tstnames)),2));
    ycmc(N)=matches/size(D,1);
end
figure(fig1);
plot(1:50,ycmc,'Marker','*');
tt = strcat('CMC Graph N=1:50, Preserving ',sprintf('%d',percentInf*100),'% information');
title(tt);
xlabel('N top matches');
ylabel('Performance ');

% 3 TEST IMAGES THAT WERE CORRECTLY MATCHED ALONGSIDE THEIR BEST MATCHES
% FOR N=1:50

N=1;
subtrain = mfids(:,1:N);
matches  = bsxfun(@eq,subtrain,tstnames);
II=matches==1;
subtrain = subtrain(II);
subtest = tstnames(II);

dTst = arrayfun(@(x)find(tstnames==x,1),subtest(200:202))';
dTrain=arrayfun(@(x)find(fids==x,1),subtrain(200:202))';

figure(fig2);
for j=1:3
dispTest = testFiles(:,dTst(j));
dispTrain = trainFiles(:,dTrain(j));

subplot(3,2,j*2-1);
dispImg = reshape(vec2gray(dispTest+avgFace),imgRow,imgCol);
imshow(dispImg);

subplot(3,2,j*2);
dispImg = reshape(vec2gray(dispTrain+avgFace),imgRow,imgCol);
imshow(dispImg);
end
title('');
% suptitle('3 Test Images with their top matches (Correct)')
suptitle('Top matches (Correct)')


N=1;
subtrain = mfids(:,1:N);
matches  = bsxfun(@eq,subtrain,tstnames);
II=matches==0;
subtrain = subtrain(II);
subtest = tstnames(II);

dTst = arrayfun(@(x)find(tstnames==x,1),subtest(200:202))';
dTrain=arrayfun(@(x)find(fids==x,1),subtrain(200:202))';

figure(fig3);
for j=1:3
dispTest = testFiles(:,dTst(j));
dispTrain = trainFiles(:,dTrain(j));

subplot(3,2,j*2-1);
dispImg = reshape(vec2gray(dispTest+avgFace),imgRow,imgCol);
imshow(dispImg);

subplot(3,2,j*2);
dispImg = reshape(vec2gray(dispTrain+avgFace),imgRow,imgCol);
imshow(dispImg);
end
title('');
% suptitle('3 Test Images with their top matches (Incorrect). ');
suptitle('Top matches (Incorrect). ');
end



