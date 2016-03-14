function [ chromImg ] = toChormatic( inputImg )
% Takes as input an RGB image and converts it to 
%   a chormatic image.
  k = size(inputImg);
  chromImg = zeros(k(1),k(2),2,'single');
  rCH = single(inputImg(:,:,1));
  gCH = single(inputImg(:,:,2));
  bCH = single(inputImg(:,:,3));
  chromeRGB = rCH+gCH+bCH;
  chromImg(:,:,1)=rCH./chromeRGB;
  chromImg(:,:,2)=bCH./chromeRGB;
end

