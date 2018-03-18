function I_new = centering(I, varargin)
% usage: centering(I, varargin). Centers stars in the middle of frame. 
% OPTIONAL ARGUMENTS:
%   -finder: Want to find max (default) or second moments ("moments").
%   -shift: Type of shift, zero pad (default) or circshift ("circ"). 
%   -pixels: Use maskBadPixels on input (default is true).
%   -smoothing: 0 (default) means don't smooth, otherwise use as size of
%    gaussian filter (in pixels).
%   -subtraction: Subtract mean, median or none (default).
    
    import util.img.centering;
    import util.img.imshift;
    import util.img.gaussian2;
    import util.stat.corner_mean;
    import util.stat.sum2;
    import util.stat.max2;
    import util.stat.median2;
    
    import util.text.cs;
    
    if nargin==0, help('util.img.centering'); return; end
    
    if size(I,4)>1 % revert to loop if 4D
        I_new = zeros(size(I), 'like', I);
        for ii = 1:size(I,4)
            I_new(:,:,:,ii) = centering(I(:,:,:,ii), varargin{:});
        end
        return;
    end
    
    if size(I,3)>1 % revert to loop if 3D
        I_new = zeros(size(I), 'like', I);
        for ii = 1:size(I,3)
            I_new(:,:,ii) = centering(I(:,:,ii), varargin{:});
        end
        return;
    end
    
    %%%%%%%% must be a 2D matrix %%%%%%%%%
    
    input = util.text.InputVars;
    input.input_var('finder', 'max', 'peak'); % can also choose moment
    input.input_var('shift', 'zeros', 'shift_type'); % can also choose circshift
    input.input_var('pixels', true, 'bad_pixels'); % want to use maskBadPixels?
    input.input_var('smoothing', 0); % size of gaussian to smooth with. 
    input.input_var('subtraction', 'none'); % can choose median or corner to
    input.scan_vars(varargin{:});
    
    I_finder = I;
    S = size(I_finder);
        
    if input.pixels
        I_finder = util.img.maskBadPixels(I_finder);
    end
    
    if cs(input.subtraction, 'median')
        I_finder = I_finder - median2(I_finder);
    elseif cs(input.subtraction, 'corner')
        I_finder = I_finder - corner_mean(I_finder);
    elseif cs(input.subtraction, 'none')
        % pass
    else
        error(['unknown subtraction method: "' input.subtraction '", use median, corner or none...']);
    end
    
    if input.smoothing
        I_finder = filter2(gaussian2(input.smoothing), I_finder, 'same');
    end
    
    if cs(input.finder, 'max')
        
        [~, idx] = max2(I_finder);
        shift_x = round(-idx(2) + S(2)/2);
        shift_y = round(-idx(1) + S(1)/2);
        
    elseif cs(input.finder, 'moments')
        
        [x,y] = meshgrid((1:S(1)) - S(1)/2, (1:S(2)) - S(2)/2);
        shift_x = -sum2(I_finder.*x)./sum2(I_finder);
        shift_y = -sum2(I_finder.*y)./sum2(I_finder);
        
    else
        error(['unknown finder method: "' input.finder '", use max or moments...']);      
    end
    
    if cs(input.shift, 'zeros')
        I_new = imshift(I, shift_y, shift_x);
    elseif cs(input.shift, 'circ')
        I_new = circshift(I, [shift_y, shift_x]);
    else
        error(['unknown shift type: "' input.shift '", use zeros or circ...']);
    end
    
end