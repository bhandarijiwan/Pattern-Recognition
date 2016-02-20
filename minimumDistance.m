%%%---------------Example from the book-------- 
NUMBER_OF_SAMPLES_PER_CLASS =10000;
NUMBER_OF_FEATURES=2;
TOTAL_SAMPLES=NUMBER_OF_SAMPLES_PER_CLASS*2;
NUMBER_OF_CLASSES=2;


%%%%------ Distribution given in the book-------

%%%%--------set and calculate the parameters for class A
meanA = [1  1]; 
sdA = [2 2];
sigmaA   = [2 0; 0 2];
priorA =0.5;




%%%----set and calculate the parameters for class B
meanB = [6 6];
sdB = [4 8];
sigmaB = [4 0;0 8];
priorB = 0.5;



%samples for class_A
% denoting samples from class A by 1
samplesA = box_muller(meanA,sdA,NUMBER_OF_SAMPLES_PER_CLASS); 
samplesA = [samplesA, repmat(1,length(samplesA),1)];

%samples for class_B
samplesB = box_muller(meanB,sdB,NUMBER_OF_SAMPLES_PER_CLASS);
samplesB = [samplesB, repmat(2,length(samplesB),1)];

% combine the samples from both class
samples = [samplesA;samplesB];

figure(1);
gscatter(samples(:,1),samples(:,2),samples(:,3),['g' 'b'],['.'],[15]);
ylim([-10 10]);
xlim([-10 10]);
legend('Class A','Class B');
title('Data before classification');

clear samplesA samplesB;

% classify each vector based on discriminat function
finalClassA=[];
finalClassB=[];
boundaryPoints=[];

for i=1:TOTAL_SAMPLES
    
    gx_A = round(abs(samples(i,1:2)-meanA),2);
    gx_B = round(abs(samples(i,1:2)-meanB),2);
    if(gx_A>gx_B)
        finalClassA=vertcat(finalClassA,samples(i,:));
    elseif(gx_B>gx_A)
        finalClassB=vertcat(finalClassB,samples(i,:));
    else
        boundaryPoints=vertcat(boundaryPoints,samples(i,:));
    end
end
figure(4);
hold on;
gsa=gscatter(finalClassA(:,1),finalClassA(:,2),finalClassA(:,3),['g' 'r'],['.'],[15]);

%plot vectors in class B
gsb=gscatter(finalClassB(:,1),finalClassB(:,2),finalClassB(:,3),['r' 'b'],['.'],[15]);
%plot the boundary points

cb=scatter(boundaryPoints(:,1),boundaryPoints(:,2),20,'black','filled');
% 
% 
ylim([-10 10]);
xlim([-10 10]);
legend( [gsa(1) gsb(2) gsa(2) cb ], ...
     'Class A', 'Class B', 'Mis-Classified', 'Boundary Points','Location','NorthWest');

title('Minimum distance classifier')
hold off;
ma= sum(finalClassA(:,3)==2);
mb= sum(finalClassB(:,3)==1);

summary=struct('misclassified_form_class_A',ma,...
        'Misclassified_from_class_B',mb,...
        'Total_Misclassified',ma+mb);

disp(summary);


