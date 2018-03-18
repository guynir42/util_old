function I = preprocess(I, varargin)
% does basic pre-processing on image I
% If no optional arguments are used, will not change the image!
%
% OPTIONAL ARGUMENTS:
%   -subtract: remove the mean from the summed image. Default: 0
%   -smoothing: if you want to do a Gaussian smoothing before finding max. 
%    The number given is the width parameter of the Gaussian. Default: 0
%   -psf: if you want to do the smoothing/match filter with a custom PSF.
%   -bad pixels: if you want to use maskBadPixels on the image. Default: 0


    if nargin==0, help('util.img.preprocess'); return; end
    
    input = util.text.InputVars;
    
    input.input_var('subtract', false);    
    input.input_var('smoothing', 0, 'filter', 'gaussian filter');
    input.input_var('psf', []);
    input.input_var('bad_pixels', false, 'mask bad pixels');
    input.scan_vars(varargin{:});
    
    if input.subtract
        I = I - util.stat.mean2(I);
    end
    
    if input.bad_pixels
        I = util.img.maskBadPixels(I);
    end
    
    if input.smoothing>0 || ~isempty(input.psf)
    
        if isempty(input.psf)
            p = util.img.gaussian2(input.smoothing);
        else
            p = input.psf;
        end
        
        p = p./sqrt(util.stat.sum2(p.^2));
        
        I = util.fft.conv_f(p, I, 'crop', 'same');
        
    end


end