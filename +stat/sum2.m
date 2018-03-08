function S = sum2(I, outtype)
% usage: sum2(I, outtype='double')
% calculates the sum of images in the input matrix. 
% returns a 3D or 4D (or higher) output. 
% will output double by default. Use outtype to require a different type. 

    if nargin==0
        help('util.stat.sum2');
        return;
    end

    if nargin<2 || isempty(outtype)
        outtype = 'double';
    end
    
    S = sum(sum(I,1, outtype),2, outtype);

end