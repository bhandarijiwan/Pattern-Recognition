
NUMBER_OF_SAMPLES_PER_CLASS =10000;
NUMBER_OF_FEATURES=2;
TOTAL_SAMPLES=NUMBER_OF_SAMPLES_PER_CLASS*2;
NUMBER_OF_CLASSES=2;


%%%%------ Distribution given in the book-------

%%%%--------set and calculate the parameters for class A
meanA = [1  1]; 
sigmaA   = [2 0; 0 2];
sdA = sqrt(diag(sigmaA)');
priorA =0.5;
classA = discriminantParams(meanA, sigmaA, priorA);



%%%----set and calculate the parameters for class B
meanB = [6 6];
sigmaB = [2 0;0 2];
sdB = sqrt(diag(sigmaB)');
% prior probability for class B. 

priorB = 0.5;

classB = discriminantParams(meanB,sigmaB,priorB);

%%%%%%----- q=1 is for first distribution and q=2 is for second
%%%%%%------ distribution. Change the mean and sigma values as well.

q= 1; 


if(exist(strcat(sprintf('data_q%d',q),'.csv'),'file')~=2)

    disp('Data Not found so regenerating');
    %samples for class_A
    % denoting samples from class A by 1
    samplesA = box_muller(meanA,sdA,NUMBER_OF_SAMPLES_PER_CLASS); 
    samplesA = [samplesA, repmat(1,length(samplesA),1)];

    %samples for class_B
    samplesB = box_muller(meanB,sdB,NUMBER_OF_SAMPLES_PER_CLASS);
    samplesB = [samplesB, repmat(2,length(samplesB),1)];

    % combine the samples from both class
    samples = [samplesA;samplesB];
    csvwrite(sprintf('data_q%d.csv',q),samples);
else
    samples=csvread(sprintf('data_q%d.csv',q));
end


figure(1);
ylim([-10 10]);
xlim([-10 10]);
gscatter(samples(:,1),samples(:,2),samples(:,3),['g' 'b'],'.',15);
legend('Class A','Class B');
title('Data before classification');

% cov(samplesA(:,1:2))
% 
% cov(samplesB(:,1:2))

clear samplesA samplesB;

% classify each vector based on discriminat function
finalClassA=[];
finalClassB=[];
boundaryPoints=[];

for i=1:TOTAL_SAMPLES
    
    gx_A = round(discriminant(samples(i,1:2),classA),2);
    gx_B = round(discriminant(samples(i,1:2),classB),2);
    
    if(gx_A>gx_B)
        finalClassA=vertcat(finalClassA,samples(i,:));
    elseif(gx_B>gx_A)
        finalClassB=vertcat(finalClassB,samples(i,:));
    else
        boundaryPoints=vertcat(boundaryPoints,samples(i,:));
    end
end

a=classA.W-classB.W;
b=classA.w-classB.w;
c=classA.w_i0-classB.w_i0;

figure(2);
 
db=ezplot(@(x1,x2)decisionBoundary(x1,x2,a,b,c),[-10,10,-10,10]);
hndl=get(gca,'Children');
set(hndl,'LineWidth',5,'Color','red');
title('Bayesian Classification of Data');
hold on;
% plot vectors in class A
gsa=gscatter(finalClassA(:,1),finalClassA(:,2),finalClassA(:,3),['g' 'r'],['.'],[15]);

%plot vectors in class B
gsb=gscatter(finalClassB(:,1),finalClassB(:,2),finalClassB(:,3),['r' 'b'],['.'],[15]);
%plot the boundary points

% cb=scatter(boundaryPoints(:,1),boundaryPoints(:,2),20,'black','filled');
% 
% 
legend([db gsa(1) gsb(2) gsa(2)  ], 'Decision Boundary', ...
     'Class A', 'Class B', 'Mis-Classified','Location','NorthWest');

hold off

chernoff=errorBounds('chernoff',classA,classB);
bhatta = errorBounds('bhatt',classA,classB);
ma =sum(finalClassA(:,3)==2);
mb= sum(finalClassB(:,3)==1);

summary=struct('Samples_in_Class_A_after_classification',length(finalClassA),...
        'Samples_in_Class_B_after_classification',length(finalClassB),...
        'Misclassified_Into_class_A',ma,...
        'Misclassified_Into_Class_B',mb,...
        'Total_Misclassified',ma+mb,...
        'Points_on_decision_boundary',length(boundaryPoints),...
        'Chernoff_Error_Bound',chernoff,...
        'Bhattacharyya_Error_Bound',bhatta);
disp(summary);






