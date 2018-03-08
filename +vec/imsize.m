function S = imsize(input)
% Takes a scalar, vector or matrix and returns the 2 element image size 
% If input is scalar, returns [1,1]*input
% If input is a 2 element vector or empty, returns input. 
% If input is a vector, returns first two elements. 
% If input is matrix, return the size of first 2 dimensions. 

    if nargin==0
        help('util.vec.imsize');
        return;
    end

    if isempty(input)
        S = [];
    elseif isscalar(input)
        S = [1,1]*input;
    elseif length(input)==2
        S = input;
    elseif isvector(input)
        S = input(1:2);
    else
        S = size(input);
        S = S(1:2);
    end

end