function [ out ] = discriminantParams( mu, sigma , prior )
%BAYESIANCLASSIFIER Summary of this function goes here
%   mu -- mean of the distribution as a row vector
%   sigma  -- covariance matrix (square matrix)
%   prior_i -- prior probabiltiy for this distribution.
%


  mu = mu';

  sigma_inverse = inv(sigma);

  W = -1/2.*sigma_inverse;
  
  w = sigma_inverse*mu;
  w_i0= (-1/2 .* mu' * sigma_inverse* mu) - (1/2 * log(det(sigma))) +log (prior);
  
  out=struct('W',W,'w',w,'w_i0',w_i0,...
              'mu',mu,'sigma',sigma,'sigmaInverse','sigma_inverse'...
               ,'det',det(sigma),'prior',prior);
  
end

