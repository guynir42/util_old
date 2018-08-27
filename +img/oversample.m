function I_out = oversample(I, oversampling, normalization)
% usage: oversample(I, oversampling=2, normalization='sum', memory_limit=10GBs)
% Oversamples an image using FFT and zero padding (equivalent to sinc interpolation). 
% OPTIONAL PARAMETERS
%   -oversampling: by how much to over sample. Must be an integer. Default is 2
%   -normalization: sum or energy (default) keeps the energy/intensity constant, 
%                   mean or surface maintains the same surface brightness of pixels. 

    if nargin==0, help('util.img.oversample'); return; end

    if nargin<2 || isempty(oversampling)
        oversampling = 2;
    end
    
    if nargin<3 || isempty(normalization)
        normalization = 'sum';
    end
    
    if oversampling==1 % if no oversampling is needed just get out...
        I_out = I;
        return;
    end
    
    oversampling = round(oversampling);
    
    I_out = util.img.imshift(util.fft.ifft2s(util.img.pad2size(util.fft.fft2s(I), size(I).*oversampling)),oversampling/2, oversampling/2);
        
    if util.text.cs(normalization, 'mean', 'surface')    
        I_out = I_out.*oversampling.^2;
    end
    
end