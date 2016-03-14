function [  ] = plotdistribution( mean, Sigma )
%PLOTDISTRIBUTION Summary of this function goes here
%   Detailed explanation goes here

% Mesh-Plot the distribution:
x1=0:.02:1;
x2=0:.02:1;
figure(1);
hold off;
[X,Y]=meshgrid(x1,x2);
Z=mvnpdf([X(:) Y(:)],mean,Sigma);
Z = reshape(Z,length(x2),length(x1));
surf(X,Y,Z);

caxis([min(Z(:))-.5*range(Z(:)),max(Z(:))]);

xlabel('r','FontWeight','bold','FontSize',15); 
ylabel('g','FontWeight','bold','FontSize',15); 
zlabel('pdf','FontWeight','bold','FontSize',15);

title('Skin Color Distribution For Training Face  ');


end

% temp=mvnrnd(mean,Sigma,1000);
% 
% mint=min(temp(:,1));
% maxt=max(temp(:,1));
% 
% mint1=min(temp(:,2));
% maxt1=max(temp(:,2));
% 
% x= min(mint,mint1):0.5:max(maxt,maxt1);
% y= x;
% 
% [X,Y]=meshgrid(x,y);
% Z=mvnpdf([X(:) Y(:)],mean,Sigma);
% Z = reshape(Z,length(x),length(y));
% surf(X,Y,Z);
% % caxis([min(Z(:))-.5*range(Z(:)),max(Z(:))]);
% 
% xlabel('r','FontWeight','bold','FontSize',15); 
% ylabel('g','FontWeight','bold','FontSize',15); 
% zlabel('pdf','FontWeight','bold','FontSize',15);
% Z= mvnpdf(temp,mean,Sigma);

% [X,Y]=meshgrid(temp(:,1),temp(:,2));
