% Run this file inside of 'Support Vector Machines/scripts/' directory.
%% SETUP BLOCK
    % Run this block to setup the data and paths and all.
    % The original data isn't in format required by LIBSVM so needs
    % conversion to the LIBSVM format.

    % Experimenting with the high res(48*60) images.
% trainData path;
vec2gray =@(vec)uint8((vec-min(vec))/(max(vec)-min(vec)).*255);


% Reading in the raw training data and writing back in LIBSVM format.
fold=1;
resolution='res_16_20';
if (~exist(strcat('../Data/res_16_20/LibData/',resolution),'dir'))
    mkdir(strcat('../Data/res_16_20/LibData/',resolution));
end
for fold=1:3
    trainDataFilePath = sprintf('../Data/res_48_60/trPCA_0%i.txt',fold);
    delimeter=' ';
    rawCoeffs = dlmread(trainDataFilePath,delimeter);
    % only use the coefficients corresponding top 30 eigen vectors
    rawCoeffs = rawCoeffs(1:30,:);
    % class label filepath
    classLabelFilePath = sprintf('../Data/res_48_60/TtrPCA_0%i.txt',fold);
    classlabels = dlmread(classLabelFilePath,delimeter);
    % write the data to a directory  'LibData'
    trainData = formatLibSVM(rawCoeffs,'res_48_60',fold,classlabels,'train');
end

% Reading in the raw test data and writing back in LIBSVM Format.
for fold=1:3
    trainDataFilePath = sprintf('../Data/res_48_60/tsPCA_0%i.txt',fold);
    delimeter=' ';
    rawCoeffs = dlmread(trainDataFilePath,delimeter);
    trainDataFilePath = sprintf('../Data/res_48_60/valPCA_0%i.txt',fold);
    rawCoeffs = [rawCoeffs dlmread(trainDataFilePath,delimeter)];
    % only use the coefficients corresponding top 30 eigen vectors
    rawCoeffs = rawCoeffs(1:30,:);
    % class label filepath
    classLabelFilePath = sprintf('../Data/res_48_60/TtsPCA_0%i.txt',fold);
    classlabels = dlmread(classLabelFilePath,delimeter);
    
    classLabelFilePath = sprintf('../Data/res_48_60/TvalPCA_0%i.txt',fold);
    classlabels = [classlabels dlmread(classLabelFilePath,delimeter)];
    % write the data to a directory  'LibData'
    trainData = formatLibSVM(rawCoeffs,'res_48_60',fold,classlabels,'test');
end
%%  Experimenting with Polynomial Kernel;
%
%trying out the following dimensions 
ktype='poly';
t=1;
d = [1 2 3];
gamma = 1;
c0=0;
C = [1 10 100 1000];
folds = [1 2 3];
modelfilepath = '../Data/res_16_20/LibData/';
libpath='../scripts/libsvm-3.21/';
resultAccuracy = zeros(size(c,2),size(d,2));
resultErrorRate = resultAccuracy;
ci=1;
for c = C
    for dim = d
        cumAccuracyRate=0;
        cumErrorRate=0;
        for fold = folds
            trainFile= strcat(modelfilepath,'/',...
                sprintf('train_fold_%i.txt',fold));
            testFile = strcat(modelfilepath,'/',...
                sprintf('test_fold_%i.txt',fold));
            ouptputFile=strcat(modelfilepath,'/',...
                sprintf('output_fold_%i.txt',fold));
            modelFile = strcat(modelfilepath,'/',...
                sprintf('%s%d_C%i_fold%d.model',ktype,dim,c,fold));
            svmtrainCmd=sprintf('svm-train -t %i -c %d -d %i -g %d  %s  %s',t,c,dim,gamma,...
                trainFile,modelFile);
            [~, ~]=system(strcat(libpath,svmtrainCmd));
            svmpredictCmd = sprintf('svm-predict %s %s %s',testFile,modelFile,ouptputFile);
            [status, output]=system(strcat(libpath,svmpredictCmd));
            [s,e]=regexp(output,'(\d+)(\.)(\d+)');
            cumAccuracyRate = cumAccuracyRate+str2double(output(s:e)); 
            cumErrorRate = cumErrorRate+100-str2double(output(s:e));
        end
        resultAccuracy(ci,dim) = cumAccuracyRate/size(folds,2);
        resultErrorRate(ci,dim)= cumErrorRate/size(folds,2);
    end
    ci=ci+1;
end
displayResults(resultAccuracy,resultErrorRate,t,d);

%% Experimenting with RBF Kernel
ktype='RBF';
t=2; % kernel type - RBF
sigmas = [1 10 100];
c0=0;
C = [1 10 100 1000];
folds = [1 2 3];
modelfilepath = '../Data/res_16_20/LibData/';
libpath='../scripts/libsvm-3.21/';
resultAccuracy = zeros(size(c,2),size(d,2));
resultErrorRate = resultAccuracy;
ci=1;
for c = C
    si=1;
    for sigma = sigmas
        cumAccuracyRate=0;
        cumErrorRate=0;
        gamma =  1/ (2*sigma*sigma);
        for fold = folds
            trainFile= strcat(modelfilepath,'/',...
                sprintf('train_fold_%i.txt',fold));
            testFile = strcat(modelfilepath,'/',...
                sprintf('test_fold_%i.txt',fold));
            ouptputFile=strcat(modelfilepath,'/',...
                sprintf('output_fold_%i.txt',fold));
            modelFile = strcat(modelfilepath,'/',...
                sprintf('%s_sigma%d_C%i_fold%d.model',ktype,sigma,c,fold));
            svmtrainCmd=sprintf('svm-train -t %i -c %d -g %d  %s  %s',t,c,gamma,...
                trainFile,modelFile);
            [~, ~]=system(strcat(libpath,svmtrainCmd));
            svmpredictCmd = sprintf('svm-predict %s %s %s',testFile,modelFile,ouptputFile);
            [status, output]=system(strcat(libpath,svmpredictCmd));
            [s,e]=regexp(output,'(\d+)(\.)(\d+)');
            cumAccuracyRate = cumAccuracyRate+str2double(output(s:e)); 
            cumErrorRate = cumErrorRate+100-str2double(output(s:e));
        end
        resultAccuracy(ci,si) = cumAccuracyRate/size(folds,2);
        resultErrorRate(ci,si)= cumErrorRate/size(folds,2);
        si=si+1;
    end
    ci=ci+1;
end
displayResults(resultAccuracy,resultErrorRate,t,sigmas);

%%
%% Bayesian Classification

delimeter=' ';
error_rate=0;
accuracy_rate=0;
folds = [1 2 3];
for fold=folds
    trainDataFilePath = sprintf('../Data/res_48_60/trPCA_0%i.txt',fold);
    delimeter=' ';
    rawtrainCoeffs = dlmread(trainDataFilePath,delimeter);
    % only use the coefficients corresponding top 30 eigen vectors
    rawtrainCoeffs = rawtrainCoeffs(1:30,:);
    rawtrainCoeffs = rawtrainCoeffs';
    
    classLabelFilePath = sprintf('../Data/res_48_60/TtrPCA_0%i.txt',fold);
    
    trainclasslabels = dlmread(classLabelFilePath,delimeter);
    trainclasslabels=trainclasslabels';
    
    trainDataFilePath = sprintf('../Data/res_48_60/tsPCA_0%i.txt',fold);
    delimeter=' ';
    rawtestCoeffs = dlmread(trainDataFilePath,delimeter);
    trainDataFilePath = sprintf('../Data/res_48_60/valPCA_0%i.txt',fold);
    rawtestCoeffs = [rawtestCoeffs dlmread(trainDataFilePath,delimeter)];
    
    % only use the coefficients corresponding top 30 eigen vectors
    rawtestCoeffs = rawtestCoeffs(1:30,:);
    
    rawtestCoeffs = rawtestCoeffs';
    
    classLabelFilePath = sprintf('../Data/res_48_60/TtsPCA_0%i.txt',fold);
    testclasslabels = dlmread(classLabelFilePath,delimeter);
    
    classLabelFilePath = sprintf('../Data/res_48_60/TvalPCA_0%i.txt',fold);
    testclasslabels = [testclasslabels dlmread(classLabelFilePath,delimeter)];

    testclasslabels=testclasslabels';
    
    maleCoeffs = rawtrainCoeffs(trainclasslabels==1,:);
    femaleCoeffs = rawtrainCoeffs(trainclasslabels==2,:);
    
    mu_male = mean(maleCoeffs,1);
    mu_female = mean(femaleCoeffs,1);
    male_Sigma= cov(maleCoeffs);
    female_Sigma= cov(femaleCoeffs);
    
    Params_male = discriminantParams(mu_male,male_Sigma,0.5);
    Params_female=discriminantParams(mu_female,female_Sigma,0.5);
 
    finallabels = zeros(size(testclasslabels));
    
    for i =1:size(rawtestCoeffs,1)
        gx_male = discriminant(rawtestCoeffs(i,:),Params_male);
        gx_female = discriminant(rawtestCoeffs(i,:),Params_female);
        if gx_male>gx_female
            finallabels(i)=1;
        else
            finallabels(i)=2;
        end
    end
    arate = (sum(finallabels==testclasslabels)/length(testclasslabels))*100;
    accuracy_rate=accuracy_rate+arate;
    error_rate = error_rate+100-arate;
end
disp('Average Accuracy and error rate using 3-fold cross validation');
fprintf('Bayesian Classification Accuracy=%.2f \n',accuracy_rate/size(folds,2));
fprintf('Bayesian Classification Error rate=%.2f \n',error_rate/size(folds,2));

























