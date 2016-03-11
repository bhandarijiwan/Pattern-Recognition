function [ finalClassA,finalClassB,boundaryPoints ] = classifier( bayesParamA,...
                                                                  bayesParamB,...
                                                                  samples )
%CLASSIFIER classify the samples using 'discriminant'
%           returns final classification results for each class.
%           For the timebeing will only handle 2 class classification.
finalClassA=[];
finalClassB=[];
boundaryPoints=[];
for i=1:length(samples)
    
    gx_A = round(discriminant(samples(i,1:2),bayesParamA),2);
    gx_B = round(discriminant(samples(i,1:2),bayesParamB),2);
     
%     gx_A = discriminant(samples(i,1:2),bayesParamA);
%     gx_B = discriminant(samples(i,1:2),bayesParamB);
    if(gx_A>gx_B)
        finalClassA=vertcat(finalClassA,samples(i,:));
    elseif(gx_B>gx_A)
        finalClassB=vertcat(finalClassB,samples(i,:));
    else
        boundaryPoints=vertcat(boundaryPoints,samples(i,:));
    end
end

disp(size(finalClassA));
disp(size(finalClassB));
% plot the samples and decision boundaries.

a=bayesParamA.W-bayesParamB.W;
b=bayesParamA.w-bayesParamB.w;
c=bayesParamA.w_i0-bayesParamB.w_i0;

figure(2);
 
db=ezplot(@(x1,x2)decisionBoundary(x1,x2,a,b,c),[-10,10,-10,10]);
hndl=get(gca,'Children');
set(hndl,'LineWidth',5,'Color','red');
title('Bayesian Classification of Data');
hold on;
% plot vectors in class A
gsa=gscatter(finalClassA(:,1),finalClassA(:,2),finalClassA(:,3),['g' 'r'],'.',15);

%plot vectors in class B
gsb=gscatter(finalClassB(:,1),finalClassB(:,2),finalClassB(:,3),['r' 'b'],'.',15);
%plot the boundary points

cb=scatter(boundaryPoints(:,1),boundaryPoints(:,2),20,'black','filled');
% 
% 
legend([db gsa(1) gsb(2) gsa(2) cb ], 'Decision Boundary', ...
     'Class A', 'Class B', 'Mis-Classified', 'Boundary Points','Location','NorthWest');

hold off
% end of plot

end

