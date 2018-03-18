function [I_subtracted, images_cut, connected_properties] = cutConnected(I, varargin)
% Finds and cuts out the connected regions in image I, where each region is
% defined to be connected if all its parts are above 50% of the maximum. 
% 
% Input: an image or 3D image matrix (iterative finder)
% 
% OUTPUTS: 
%   -I_subtracted is the image(s) with the connected regions removed
%    (replaced with "value"). 
%   -images_cut is a cell array of images or cell array of cell arrays of 
%    images of the minimal areas of the connected regions. Pixel values in 
%    each image are the same as the original, but pixels under the 
%    threshold are zeroed out. 
%   -connected_properties: a struct or cell array of struct arrays (same 
%    size as images_cut) with some properties of each image:
%       *xc: centroid_x (relative to the entire image!)
%       *yc: centroid_y (relative to the entire image!)
%       *m2x: second moment in x (relative to centroid_x)
%       *m2y: second moment in y (relative to centroid_y)
%       *mxy: cross term in xy (relative to the centroids)
%       *max: maximum value. 
%       *thresh: threshold*fraction (defines region)
%     
%   The outputs will be cell array of cell array and cell array of structs, 
%   one cell for each frame in I. If I is just one image, the output will 
%   be a cell array of images and a struct array (unless "cell" is chosen). 
%
% OPTIONAL ARGUMENTS:
%   -threshold: what minimal value still counts as a local maximum.
%    Default is 10.
%   -delta: how much below the threshold counts as same region. Default is 1.
%   -fraction: what fraction of local maximum is considered connected. Will 
%    override the "delta" parameter. 
%   -relative: Check if "delta" or "fraction" should be used relative to 
%    the maximum found or relative to the set threshold. Default: 1
%   -value: what to put in the stamp? Default: 0 (can also be NaN). 
%   -num peaks: how many regions should be found in each image. Default: 100
%   -subtract: remove the mean from the summed image. Default: 0
%   -smoothing: if you want to do a Gaussian smoothing before finding max. 
%    The number given is the width parameter of the Gaussian. Default: 0
%   -psf: if you want to do the smoothing/match filter with a custom PSF.
%   -bad pixels: if you want to use maskBadPixels on the image. Default: 0
%   -cell: use this to force output as cell of cell and cell of struct even 
%    when input is 2D matrix. 
%

    import util.stat.sum2;

    if nargin==0, help('util.img.cutStars'); return; end
        
    input = util.text.InputVars;

    input.input_var('threshold', 10);
    input.input_var('delta', 1);
    input.input_var('fraction', []);
    input.input_var('relative', 1);
    input.input_var('value', 0);
    input.input_var('num_peaks', 100);
    input.input_var('cell', 0);
    
    input.scan_vars(varargin{:});
            
    I_subtracted = I;
    images_cut = {};
    connected_properties = {};
    I = util.img.preprocess(I, varargin{:});
    
    for ii = 1:size(I,3)
       
        images_cut{ii} = {};
        connected_properties{ii} = struct('xc',{}, 'yc', {}, 'm2x', {}, 'm2y', {}, 'mxy', {}, 'max', {}, 'thresh', {});

        for jj = 1:input.num_peaks
            
            mx = util.stat.max2(I_subtracted(:,:,ii));
            
            if mx<input.threshold % leave this image alone, if no points are left above threshold
                break;
            end

            if input.relative

                if isempty(input.fraction)
                    lower_thresh = mx-input.delta;
                else
                    lower_thresh = mx*input.fraction;
                end
            
            else
            
                if isempty(input.fraction)
                    lower_thresh = input.threshold-input.delta;
                else
                    lower_thresh = input.threshold*input.fraction;
                end
                
            end
            
            BW = I(:,:,ii)>=lower_thresh;
            
            stats = regionprops(BW, 'FilledImage', 'BoundingBox', 'PixelIdxList', 'Area');
            
            num_pixels = [stats.Area];            
            [~,idx] = max(num_pixels); % find the biggest area            
            
            % extracting the region from the image
            pos = ceil(stats(idx).BoundingBox);
            x1 = pos(1);
            x2 = pos(1)+pos(3)-1;
            y1 = pos(2);
            y2 = pos(2)+pos(4)-1;

            I_region = I(y1:y2,x1:x2,ii).*stats(idx).FilledImage; % store the peak region, masking out what is not included
            images_cut{ii}{jj} = I_region;
            
            % calculating the statistics
            [X,Y] = util.vec.centerGrid(I_region);
            S = sum2(I_region);
            xc = sum2(I_region.*X)./S; % relative to region
            yc = sum2(I_region.*Y)./S; % relative to region
            m2x = sum2(I_region.*(X-xc).^2)./S;
            m2y = sum2(I_region.*(Y-yc).^2)./S;
            mxy = sum2(I_region.*(Y-yc).*(X-xc))./S;
            xc = xc + x1 + ceil(pos(3)/2) - 1;
            yc = yc + y1 + ceil(pos(4)/2) - 1;

            connected_properties{ii}(jj) = struct('xc', xc, 'yc', yc, 'm2x', m2x, 'm2y', m2y, 'mxy', mxy, 'max', mx, 'thresh', lower_thresh);
            
            % removing the region from the image
            I_subtracted(stats(idx).PixelIdxList) = input.value; % get rid of this area from the final image
            I(stats(idx).PixelIdxList) = input.value; % get rid of this area from the processed image
            
        end
        
    end
    
    if size(I,3)==1 && ~input.cell
        images_cut = images_cut{1};
        connected_properties = connected_properties{1};
    end

end