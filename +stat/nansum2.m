function S = nansum2(I)
% calculates the sum of images in the input matrix, ignoring NaNs. 
% output is 3D or 4D (or higher). 
    
    if nargin==0
        help('util.stat.nansum2');
        return;
    end

    S = nansum(nansum(I,1),2);

end