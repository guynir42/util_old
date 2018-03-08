function output = compare_size(M1, M2, dims, scalars_allowed)
% usage: compare_size(M1,M2,dims,scalars_allowed=0)
% checks if the selected dimensions are the same for M1 and M2. 
% specify which dimensions in 'dims' (e.g. dims=[1,3,4]). 
% the default for 'dims' is all dimensions. 
% if 'scalars_allowed==1' then singleton dimensions are allowed. 
% if no output variable is given, compare_size will throw an error if the
% sizes do not match. 

    if nargin==0
        help('util.vec.compare_size');
        return;
    end        

    if nargin<2
        error('must input 2 matrices to "compare_size"');
    end
        
    if isempty(M1) && isempty(M2) 
        error('both inputs to "compare_size" are empty!');
    elseif isempty(M1)
        error('input 1 to "compare_size" is empty!');
    elseif isempty(M2)
        error('input 2 to "compare_size" is empty!');
    end
    
    if nargin<3 || isempty(dims)
        dims = 1:max(ndims(M1), ndims(M2));
    end
    
    if nargin<4 || isempty(scalars_allowed)
        scalars_allowed = 0;
    end
    
    success = 1; % positive approach
    
    if scalars_allowed
        
        for ii = 1:length(dims)
            
            if size(M1, dims(ii))>1 && size(M2, dims(ii))>1 && size(M1, dims(ii))~=size(M2, dims(ii))
                success = 0;
                break;
            end
            
        end
        
    else
        
        for ii = 1:length(dims)
            
            if size(M1, dims(ii))~=size(M2, dims(ii))
                success = 0;
                break;
            end
            
        end
        
    end
    
    if nargout>0
        output = success;
    else
        if success==0
            error(['size(' inputname(1) ')= ' num2str(size(M1)) ' | size(' inputname(2) ')= ' num2str(size(M2))]);
        end
    end
    
end

