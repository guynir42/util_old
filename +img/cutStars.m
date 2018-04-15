function varargout = cutStars(I, varargin)
% Cuts stars from image using iterative maximum and cropping out a square
% (stamp) around each maximum. Can return both the input matrix without the
% stars, and the stars themselves in a 4D matrix. Accepts 2D or 3D
% matrices. 
%
% OPTIONAL ARGUMENTS:
%   -remove stars: put zeros (or another value) in the stamp positions in
%    the input images. Default: 0
%   -extract stars: copy the stamps before removing them, output in a
%    second, 4D matrix. Default 0. 
%   -positions: a vector of positions, dim 1 is the different stars and dim2
%    is the x then y position of the center of each stamp. Default []. 
%   -stamp size: how big the square around each star should be. Default: 32
%   -value: what to put in the stamp? Default: 0 (can also be NaN). 
%   -num stars: how many stars to remove? Default: 0 (automatic). 
%    If the cut_pos is given, this input can override the number of stars. 
%    If no cut_pos is given, automatic number of stars uses the threshold. 
%   -threshold: how bright should the star be to get cut (if num_stars is
%    set to 0). 
%   -absolute value: look for minima and maxima. Default: 0
%   -subtract: subtract the mean from the summed image. Default: 0
%   -smoothing: if you want to do a Gaussian smoothing before finding max. 
%    The number given is the width parameter of the Gaussian. Default: 0
%   -psf: if you want to do the smoothing/match filter with a custom PSF.
%   -bad pixels: if you want to use maskBadPixels on the image. Default: 0
%   -summed image: if you already have a summed, pre-processed image. This
%    will override the "smoothing", "psf" and "bad pixels" commands. 
%   -mex: use the faster mex function to do the subtractions.
%   -thread: how many cores to use in the cutting process (mex only). 
%   -output: specify which outputs you want and in what order (string or
%    cell array of strings). Choose one or more of the following:
%       summed image, (position | cut position), images, (stars | stamps | cutouts)
%    Default is {'summed', 'positions', 'images', 'stars'}.
%
% OUTPUTS: 
%   -summed image: the image after summing and pre-processing and cutting
%    out of all the stars. 
%   -cut position: position (x then y in each row) of the stamp centers.
%   -images cut: individual frames, not pre-processed, with the stars removed
%    and replaced by "value". If "remove_stars" is 0, returns []. 
%   -stars: all the stamps cut from the individual (not pre-processed)
%    frames. If "extract_stars" is 0, returns []. 
%
%   Order of outputs can change using the "outputs" argument.

    import util.text.cs;

    if nargin==0, help('util.img.cutStars'); return; end
        
    input = util.text.InputVars;
    input.input_var('remove_stars', false, 'zero');
    input.input_var('extract_stars', false, 'use_extract', 'copy', 'use_copy');
    input.input_var('positions', [], 'cut_pos');
    input.input_var('stamp_size', 32, 'cut_size', 'size');
    input.input_var('value', 0);
    input.input_var('num_stars', 0, 'number_stars');
    input.input_var('threshold', []);
    input.input_var('absolute_value', false);
    input.input_var('summed_image', []);
    input.input_var('mex', 1, 'use_mex');
    input.input_var('threads', 0);
    input.input_var('output', []);
    input.scan_vars(varargin{:});
    
    % settle the number of stars...
    if isempty(input.num_stars) || input.num_stars==0
        if isempty(input.positions) && isempty(input.threshold)
            input.num_stars = 1;
        elseif ~isempty(input.positions)
            input.num_stars = size(input.positions,1);
        elseif ~isempty(input.threshold)
            input.num_stars = 1000; % upper limit (will break at threshold)...
        end
    end
    
    N = input.num_stars;
    
    % preprocessing
    if isempty(input.summed_image)
        
        S = sum(I,3); % do all the detections on the sum
        S = util.img.preprocess(S, varargin{:});
        
    else
        S = input.summed_image;
    end

    stars_cell{1,1,N} = [];
    I_cut = I;
    
    for ii = 1:N
        
        if ii<=size(input.positions, 1) % use the positions as instructed
            
            idx = fliplr(input.positions(ii,:));
            
        else % N is larger than length of cut_pos, find the maximum yourself... 
            
            if input.absolute_value
                [mx, idx] = util.stat.max2(abs(S));
            else
                [mx, idx] = util.stat.max2(S);
            end
            
%             mx = (mx-M)/V; % normalize to SNR units...
            
            if ~isempty(input.threshold) && mx<input.threshold
                
                N = ii-1;
                
                if size(input.positions,1)>N
                    input.positions = input.positions(1:N,:);
                end
                
                break;
                
            end
            
            input.positions(ii,:) = fliplr(idx); % put the found maximum into cut_pos
            
        end
        
        [x1,x2,y1,y2] = center2bounds(idx(2), idx(1), input.stamp_size);
        
        if input.extract_stars
            stars_cell{1,1,ii} = copyStar(I, x1, x2, y1, y2, input.stamp_size, input.value);
        end
        
        if x1<1, x1 = 1; end
        if x2>size(I_cut,2); x2 = size(I_cut,2); end
        if y1<1, y1 = 1; end
        if y2>size(I_cut,1); y2 = size(I_cut,1); end
        
        if input.remove_stars
            I_cut(y1:y2, x1:x2, :) = input.value;
        end
        
        S(y1:y2, x1:x2) = input.value;
        
    end
    
    if input.extract_stars
        stars = cell2mat(stars_cell);
    else
        stars = [];
    end
    
    if isempty(input.output)        
        input.output = {'summed', 'position', 'images', 'stars'};
    elseif ~iscell(input.output)
        input.output = {input.output};
    end
    
    for ii = 1:length(input.output)
        if cs(input.output{ii}, 'summed image')
            varargout{ii} = S;
        elseif cs(input.output{ii}, 'cut position', 'position')
            varargout{ii} = input.positions;
        elseif cs(input.output{ii}, 'images cut')
            varargout{ii} = I_cut;
        elseif cs(input.output{ii}, 'stars', 'stamps', 'cutouts')
            varargout{ii} = stars;
        else
            error('Unknown option "%s" given as output %d. Use "summed" or "positions" or "images" or "stars"', input.output{ii}, ii);
        end
    end

end

function [x1, x2, y1, y2] = center2bounds(xc,yc,s)
% translate the center coordinates xc and yc and the size s to bounding
% pixels, rounding off so (xc,yc) are as centered as possible. 

    x1 = xc - floor(s/2);
    x2 = xc + ceil(s/2) - 1;
    
    y1 = yc - floor(s/2);
    y2 = yc + ceil(s/2) - 1;
    
end

function stamp = copyStar(M, x1, x2, y1, y2, s, value)
% copies the values in a square around xc, with size s, padding with
% value (=0) if the square is outside the frame. M can be 3D. 
    
    if value==0
        stamp = zeros([s,s,size(M,3)], 'like', M);
    elseif isnan(value)
        stamp = nan([s,s,size(M,3)]);
    else
        stamp = value*ones([s,s,size(M,3)], 'like', M);
    end        
    
    % indices inside "stamp" where we are going to copy...
    xs1 = 1;    
    xs2 = s;
    ys1 = 1;
    ys2 = s;
    
    if x1<=1 % stamp is too much to the left
        d = 1 - x1;
        xs2 = s - d; % copy less than the right edge...
        x1 = 1;
    end
    
    if x2>size(M,2) % stamp is too much to the right
        d = x2 - size(M,2);
        xs1 = 1+d; % copy less than the left edge...
        x2 = size(M,2);
    end
    
    if y1<=1 % stamp is too much to the top
        d = 1 - y1;
        ys2 = s - d; % copy less than the bottom edge...
        y1 = 1;
    end
    
    if y2>size(M,1) % stamp is too much to the bottom
        d = y2 - size(M,1);
        ys1 = 1+d; % copy less than the top edge...
        y2 = size(M,1);
    end
    
%     util.text.print_size(stamp, M);
    stamp(ys1:ys2, xs1:xs2,:) = M(y1:y2,x1:x2,:);
    
end


