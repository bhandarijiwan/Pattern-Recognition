%%
% Maximum Likelihood Estimation Solver .
% Follow this link (http://www.cse.unr.edu/~bebis/CS479/Ass/Prog2.pdf) 
% for more details.
%
%% INITILIZATION BLOCK FOR PROBLEM 1

samples = csvread('data_q1.csv');

samplesA = samples(samples(:,3)==1,1:3);

samplesB = samples(samples(:,3)==2,1:3);

clear samples;
%%
% RUN THIS BLOCK TO SOLVE PART 1.A

% Setting up parameters
priorA=0.5;
% mlest, given samples returns mean and covariance matrix.
MLEparamsA = mlest (samplesA(:,1:2));
% sigmaA = (diag(MLEparamsA.covariance))';
% once we estimate the distribution paramters, 
% we need to calcuate the discriminant parameters for 
% bayesian classifier.
bayesParamA = discriminantParams(MLEparamsA.mean,...
                                MLEparamsA.covariance,...
                                priorA);
% Do the same class A for class B;
priorB = 0.5;
MLEparamsB = mlest (samplesB(:,1:2));
% sigmaB = (diag(MLEparamsB.covariance))';
bayesParamB = discriminantParams(MLEparamsB.mean,...
                                 MLEparamsB.covariance,...
                                priorB);
% Classify the samples, plot and obtain the results                            
[ finalClassA,finalClassB,boundaryPoints ] = classifier(bayesParamA,...
                                                        bayesParamB,...
                                                        [samplesA;samplesB]);                            
% Display the summary of classification.                           
ma =sum(finalClassA(:,3)==2);
mb= sum(finalClassB(:,3)==1);
summary=struct('Samples_in_Class_A_after_classification',length(finalClassA),...
        'Samples_in_Class_B_after_classification',length(finalClassB),...
        'Misclassified_Into_class_A',ma,...
        'Misclassified_Into_Class_B',mb,...
        'Total_Misclassified',ma+mb,...
        'Points_on_decision_boundary',length(boundaryPoints));
disp(summary);
%%
% RUN THIS BLOCK TO SOLVE PART 1.B

% set the seed so that we can regenerate the same random numbers.
mySeed = 37;
rng(mySeed,'twister');
N=  length(samplesA);
indx = randperm(N,N/10);


priorA = 0.5;
MLEparamsA = mlest(samplesA(indx,1:2));
sigmaA = (diag(MLEparamsA.covariance));
bayesParamA = discriminantParams(MLEparamsA.mean,...
                                MLEparamsA.covariance,...
                                priorA);

                            
priorB = 0.5;
MLEparamsB = mlest (samplesB(indx,1:2));
sigmaB = (diag(MLEparamsB.covariance))';
bayesParamB = discriminantParams(MLEparamsB.mean,...
                                 MLEparamsB.covariance,...
                                priorB);
                            
  % Classify the samples, plot and obtain the results                            
[ finalClassA,finalClassB,boundaryPoints ] = classifier(bayesParamA,...
                                                        bayesParamB,...
                                                        [samplesA;samplesB]);                            
% Display the summary of classification.                           
ma =sum(finalClassA(:,3)==2);
mb= sum(finalClassB(:,3)==1);
summary=struct('Samples_in_Class_A_after_classification',length(finalClassA),...
        'Samples_in_Class_B_after_classification',length(finalClassB),...
        'Misclassified_Into_class_A',ma,...
        'Misclassified_Into_Class_B',mb,...
        'Total_Misclassified',ma+mb,...
        'Points_on_decision_boundary',length(boundaryPoints));
disp(summary);
                          


%% Initilization Block for Problem 2.

samples = csvread('data_q2.csv');
samplesA = samples(samples(:,3)==1,1:3);

samplesB = samples(samples(:,3)==2,1:3);

clear samples;
%%
% RUN THIS BLOCK TO SOLVE PART 2.A
% Setting up parameters
priorA=0.5;
% mlest, given samples returns mean and covariance matrix.
MLEparamsA = mlest (samplesA(:,1:2));
% sigmaA = (diag(MLEparamsA.covariance))';
% once we estimate the distribution paramters, 
% we need to calcuate the discriminant parameters for 
% bayesian classifier.
bayesParamA = discriminantParams(MLEparamsA.mean,...
                                MLEparamsA.covariance,...
                                priorA);
% Do the same class A for class B;
priorB = 0.5;
MLEparamsB = mlest (samplesB(:,1:2));
% sigmaB = (diag(MLEparamsB.covariance))';
bayesParamB = discriminantParams(MLEparamsB.mean,...
                                 MLEparamsB.covariance,...
                                priorB);
% Classify the samples, plot and obtain the results                            
[ finalClassA,finalClassB,boundaryPoints ] = classifier(bayesParamA,...
                                                        bayesParamB,...
                                                        [samplesA;samplesB]);                            
% Display the summary of classification.                           
ma =sum(finalClassA(:,3)==2);
mb= sum(finalClassB(:,3)==1);
summary=struct('Samples_in_Class_A_after_classification',length(finalClassA),...
        'Samples_in_Class_B_after_classification',length(finalClassB),...
        'Misclassified_Into_class_A',ma,...
        'Misclassified_Into_Class_B',mb,...
        'Total_Misclassified',ma+mb,...
        'Points_on_decision_boundary',length(boundaryPoints));
disp(summary);

%%
% RUN THIS BLOCK TO SOLVE PART 2.B

% set the seed so that we can regenerate the same random numbers.
mySeed = 37;
rng(mySeed,'twister');
N=  length(samplesA);
indx = randperm(N,N/10);


priorA = 0.5;
MLEparamsA = mlest(samplesA(indx,1:2));
sigmaA = (diag(MLEparamsA.covariance));
bayesParamA = discriminantParams(MLEparamsA.mean,...
                                MLEparamsA.covariance,...
                                priorA);

                            
priorB = 0.5;
MLEparamsB = mlest (samplesB(indx,1:2));
sigmaB = (diag(MLEparamsB.covariance))';
bayesParamB = discriminantParams(MLEparamsB.mean,...
                                 MLEparamsB.covariance,...
                                priorB);
                            
  % Classify the samples, plot and obtain the results                            
[ finalClassA,finalClassB,boundaryPoints ] = classifier(bayesParamA,...
                                                        bayesParamB,...
                                                        [samplesA;samplesB]);                            
% Display the summary of classification.                           
ma =sum(finalClassA(:,3)==2);
mb= sum(finalClassB(:,3)==1);
summary=struct('Samples_in_Class_A_after_classification',length(finalClassA),...
        'Samples_in_Class_B_after_classification',length(finalClassB),...
        'Misclassified_Into_class_A',ma,...
        'Misclassified_Into_Class_B',mb,...
        'Total_Misclassified',ma+mb,...
        'Points_on_decision_boundary',length(boundaryPoints));
disp(summary);
                          


%%
















