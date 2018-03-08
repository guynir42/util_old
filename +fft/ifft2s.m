function I_f = ifft2s(I)
% applies fftshift2, then ifft2, then fftshift2. 

    import util.fft.fftshift2;

    if nargin==0
        help('util.fft.ifft2s')
        return;
    end
    
    I_f = fftshift2(ifft2(fftshift2(I)));

end