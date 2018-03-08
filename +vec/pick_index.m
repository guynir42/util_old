function M_out = pick_index(M, ind, dim)
% usage: M_out = pick_index(M, ind, dim=1). 
% If the dim requested inside M is non-singleton, output that slice.
% If the dim requested is singleton (or if M is empty) just return M.
% Use ind as scalar, vector or string (e.g. "end")

    if nargin==0
        help('util.vec.pick_index');
        return;
    end
    
    if nargin<2 || isempty(ind)
        ind = 1;
    end
    
    if nargin<3 || isempty(dim)
        dim = 1;
    end
    
    if isempty(M)
        M_out = M;    
    elseif size(M, dim)<=1
        M_out = M;
    else
        ind_list = cell(1, ndims(M));
        ind_list(:) = {':'};
        ind_list{dim} = ind;
        M_out = M(ind_list{:});
    end
    
end