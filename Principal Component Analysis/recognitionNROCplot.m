function []=recognitionNROCplot(testFiles,percentInf,coeffs,...
                               eigvecs,eigvals,fids,tstnames)

                           % Anonymous function to convert double values to grayscale values.
vec2gray =  @(vec) uint8((vec-min(vec))/(max(vec)- min(vec)).*255);



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

[D, I]= sort(D,2);
mfids  = repmat(fids,size(D,1),1);
mfids = mfids(I);

step = 1:0.5:25;
Pos = zeros(size(step));
TP = zeros(size(step));
Neg = zeros(size(step));
FP=  zeros(size(step));
matches = bsxfun(@eq,mfids(:,1:1),tstnames);
ATP = matches==1;
ANP = matches==0;
C = D(:,1);
indxk=1;
for j=step
    II = C<j;
    Pos(indxk) =sum(II); 
    Neg(indxk) =sum(~II);
    TP(indxk) = sum(II(ATP));
    FP(indxk) = sum(II(ANP));
    indxk=indxk+1;
end
figure(20)
plot(FP,TP,'LineStyle','-','LineWidth',1.0);
xlabel('False Positives');
ylabel('True Positives');
title('ROC Curve FP VS TP');


