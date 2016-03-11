function params = mlest( samples )
%Maxium Likelihood Estimation
%   Input the samples as column vectors.
%   Output parameter of the distribution (mu and sigma/covariance matrix).
%   
    sampleSize = size(samples);
    mu = round(mean(samples),2);
    covMatrix = zeros(sampleSize(2),sampleSize(2));
    for i=1:sampleSize(2)
        for j=i:sampleSize(2)
             c1 = samples(:,i)-mu(i);
             c2 = samples(:,j)-mu(j);
             covMatrix(i,j)=round((c1'*c2)/(sampleSize(1)-1),2);
             covMatrix(j,i)=round((c1'*c2)/(sampleSize(1)-1),2);
        end
    end
    
    params = struct('mean',mu ,...
                    'covariance',covMatrix);
end

