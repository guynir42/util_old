function M_out = pad2size(M_in, size_needed)
% usage: pad2size(M_in, size_needed)
% pads the given array M_in to size size_needed, putting it in the middle. 
% Won't shrink the array... can handle 3D matrices (expands only first 2 dims)
    
    if nargin==0, help('util.img.pad2size'); return; end

    size_needed = util.vec.imsize(size_needed);
    
    S_in = util.vec.imsize(M_in);
    
    if size_needed(1)>S_in(1) || size_needed(2)>S_in(2)
        
        M_out = zeros(max(size_needed(1), S_in(1)), max(size_needed(2), S_in(2)), size(M_in,3));

        gap = (size_needed-S_in)/2;
        
        y1 = 1+ceil(gap(1));
        y2 = size_needed(1)-floor(gap(1));
        x1 = 1+ceil(gap(2));
        x2 = size_needed(2)-floor(gap(2));
        
        M_out(y1:y2, x1:x2,:) = M_in;
        
    else
        M_out = M_in;
    end
    
end