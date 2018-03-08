function c = tocell(input)
% if input is not a cell-array, tocell turns it to a cell-array. 

    if nargin==0
        help('util.vec.tocell');
        return;
    end
    
    if iscell(input)
        c = input;
    else
        c = {input};
    end
    
end