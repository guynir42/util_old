function I_out = oversample(I, varargin)
% usage: oversample(I, oversampling=2, normalization='sum', memory_limit=10GBs)
% Oversamples an image using FFT and zero padding (equivalent to sinc interpolation). 
% OPTIONAL PARAMETERS
%   -oversampling: by how much to over sample. Must be an integer. Default is 2
%   -normalization: sum or energy (default) keeps the energy/intensity constant, 
%                   mean or surface maintains the same surface brightness of pixels. 

    import util.text.cs;
    
    if nargin==0, help('util.img.oversample'); return; end
    
    input = util.text.InputVars;
    input.use_ordered_numeric = 1;
    input.input_var('oversampling', 2, 'factor');
    input.input_var('norm', 'sum', 'normalization');
    input.input_var('method', 'linear', 'mode');
    input.input_var('offset', [0 0]);
    input.scan_vars(varargin{:});
    
    oversampling = round(input.oversampling);
    
    if oversampling==1 % if no oversampling is needed just get out...
        I_out = I;
        return;
    end
    
    if cs(input.method, 'linear', 'cubic')
        F = griddedInterpolant(double(I'));
        
        S = util.vec.imsize(I);
        res = 1./oversampling;
        xq = res:res:S(2);
        yq = res:res:S(1);
    
        F.Method = input.method;
        F.ExtrapolationMethod = input.method;

        I_out = F({xq,yq})';    
        
    elseif cs(input.method, 'fft')
        I_out = real(util.img.imshift(util.fft.ifft2s(util.img.pad2size(util.fft.fft2s(I), size(I).*oversampling)),oversampling/2, oversampling/2));
    elseif cs(input.method, 'zeros')
        I_out = zeros(size(I).*oversampling);
        off = mod(input.offset, oversampling);
        if isscalar(off), off = [1 1].*off; end
        I_out((1+off(1)):oversampling:end,(1+off(2)):oversampling:end) = I;
    else
        error('Unknown interpolation method "%s". Use "linear" or "cubic" or "fft"...', input.method);
    end
    
    % normalize to constant energy (instead of constant surface brightness)
    if cs(input.norm, 'mean', 'surface')
        I_out = I_out.*oversampling.^2;
    end
    
end