function [ bound ] = errorBounds( type, classA, classB, varargin)
%ERRORBOUNDS Summary of this function goes here
    
     v= classB.mu-classA.mu;
     d1 = classA.det;
     d2 = classB.det;
    
     switch type 
         
         case 'chernoff'
             m=2;
             ek=[];
             k=0;
             for i=0:0.01:1
                 n=errorfunc(i);
                 ek = [ek n];
                 if(n<m)
                     m=n;
                     k=i;
                 end 
             end
             figure(3);
             xlim([0 1])
             ylim([0 1]);
           
             plot(0:0.01:1,ek);
             hold on
             p=plot(k,m,'r*','color','red');
             xlabel('beta');
             ylabel('e^-k(beta)');
             legend(p,'Chernoff Bound');
             title('Error Bounds')
             bound =m;
             hold off;
             
         case 'bhatt'
            bound = sqrt(classA.prior*classB.prior)*errorfunc(1/2);
            
     end

    function e = errorfunc(b)
        
        b1= 1-b;
        b2=(b*b1)/2;
        sigma1 = b * classA.sigma;
        sigma2 = b1 * classB.sigma;
        kb=b2 * v' * inv(sigma1+sigma2)*v + 1/2*...
           log(det(sigma1+sigma2)/(d1^b * d2^b1));
        e=exp(-kb);
        
        
    end



end

