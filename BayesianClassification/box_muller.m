function [z_x_y] = box_muller(mean, sd, n)
%BOX_MULLER Summary of this function goes here
%   Detailed explanation goes here
z_x_y = zeros(n,length(mean));
for i=1:length(mean)
    if(mod(i,2)==0)  
       z_x_y(:,i)=r.* sin(theta);
    else
        x_y= rand(n,2);
        r=sqrt(-2*log(x_y(:,1)));
        theta=2*pi*x_y(:,2);
        z_x_y(:,i)=r.* cos(theta);
    end 
    z_x_y(:,i)=z_x_y(:,i).*sd(i)+mean(i);
end 
   
end
