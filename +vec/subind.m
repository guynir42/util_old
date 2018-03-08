function val = subind(V, index)
% usuage: subind(V,index=1). 
% Takes the vector/object V (e.g. from a function) and selects an index
% from it (default is index=1). 

    if nargin==0
        disp('util.vec.subind');
        return;
    end

    if nargin<2 || isempty(index)
        index = 1;
    end

    val = V(index);

end