function [ decisionEquation ] = decisionBoundary( x1, x2, a, b , c )
%DECISIONBOUNDARY Summary of this function goes here
%   Detailed explanation goes here

decisionEquation=a(1,1)*x1.^2  + (a(1,2)+a(2,1))*x1*x2 +a(2,2)*x2.^2 ...
                    + b(1)*x1 +b(2) *x2 +c;
end

