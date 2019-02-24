function ax_vec = split_screen(number, varargin)
% usage: ax_vec = split_screen(number, varargin)
% creates a vector of axes objects in a square. 

    xsize = ceil(sqrt(number));
    ysize = xsize;
    
    % parse varargin to be added
    % add optional margin widths
    
    for ii = 1:number
        ax_vec(ii) = subplot(ysize, xsize, ii, 'align');
    end
    
end