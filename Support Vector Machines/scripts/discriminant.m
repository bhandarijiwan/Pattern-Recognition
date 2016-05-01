function [ out ] = discriminant( inputVector, discriminantParams )
%DISCRIMINANT Summary of this function goes here
%   Detailed explanation goes here

  inputVector = inputVector';
  out = (inputVector'*discriminantParams.W*inputVector) + ...
         (discriminantParams.w'*inputVector)+discriminantParams.w_i0;

end

