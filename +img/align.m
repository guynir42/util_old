function N_aligned = align(N, R, varargin)
% usage: N_aligned = align(N, R, varargin)
% Align the new image N to the reference image R.
% By default uses the maximum of the cross correlation between the images. 
% OPTIONAL ARGUMENTS:

    import util.text.cs;
    import util.stat.max2;
    import util.stat.min2;
    import util.stat.sum2;
    import util.img.pad2size;
    import util.img.crop2size;
    import util.img.imshift;
    import util.img.downsample;
    import util.img.oversample;
    import util.fft.conv_f;
    import util.fft.fft2s;
    import util.fft.ifft2s;
    
    if nargin==0, help('util.img.align'); return; end
    if nargin==1, error('Must input two images, new and reference, to "align" function...'); end
    
    method = 'correlation';
    corr_map = [];
    oversampling = 1;
    
    for ii = 1:2:length(varargin)
        key = varargin{ii};
        val = varargin{ii+1};
        if cs(key, 'method')
            method = val;
        elseif cs(key, 'correlation map', 'corr map')
            corr_map = val;
        elseif cs(key, 'oversampling', 'oversample')
            oversampling = val;
        end
    end
    
    % make sure the two arrays are of the same size
    N1 = pad2size(N, size(R));
    R1 = pad2size(R, size(N1));
    
    % oversample the arrays
%     N2 = ifft2s(pad2size(fft2s(N1), size(N1)*oversampling));
%     R2 = ifft2s(pad2size(fft2s(R1), size(R1)*oversampling));
    N2 = oversample(N1, oversampling);
    R2 = oversample(R1, oversampling);
    
    if cs(method, 'correlation', 'cross correlation', 'xcorr')
        
        if isempty(corr_map)
            corr_map = util.fft.conv_f(N2, R2, 'conj', 1);
        end
        
        [~, idx] = max2(corr_map);
%         util.plot.show(corr_map);
        
        delta = (idx-size(N)*oversampling);
        
%         if nnz(delta)
%             disp(['delta= ' num2str(delta)]);
%         end
        
        N_aligned = downsample(imshift(N2, delta(1), delta(2)), oversampling);

    elseif cs(method, 'scan')
        
        dx = (-5*oversampling):(5*oversampling);
        dy = dx;
                
        min_diff = zeros(length(dy), length(dx));
        
        for ii = 1:length(dy)
            for jj = 1:length(dx)
                
                min_diff(ii,jj) = sum2((circshift(N, [dy(ii), dx(jj)])-R).^2);
                                
            end
        end
        
        [mn, idx] = min2(min_diff);
        
%         disp(['mn= ' num2str(mn) ' | dx= ' num2str(dx(idx(2))) ' | dy= ' num2str(dy(idx(1)))]);
        
        N_aligned = downsample(imshift(N2, dy(idx(1)), dx(idx(2))), oversampling);
        
    end
    
end


