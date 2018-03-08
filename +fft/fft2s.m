function I_f = fft2s(I)
% applies fftshift2, then fft2, then fftshift2. 

    import util.fft.fftshift2;

    if nargin==0
        help('util.fft.fft2s')
        return;
    end
    
    I_f = fftshift2(fft2(fftshift2(I)));

end