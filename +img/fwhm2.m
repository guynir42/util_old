function val = fwhm2(I, varargin)
% usage: val = fwwm2(I, varargin)
% Calculates the Full Width at Half Maximum of an image, assuming the image
% has a single, fairly smooth and circular-symmetric peak (does not need to 
% be centered), without taking into account negative values. 

    N = nnz(I>=0.5*util.stat.max2(I)); % number of pixels above half the maximum

    val = 2*sqrt(N/pi); % assumes the area above the threshold is in a perfect disk. 

end