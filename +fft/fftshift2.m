function Ishift = fftshift2(I)
% applies fftshift on the first two dimensions only. 

    if nargin==0
        help('util.fft.fftshift2');
        return;
    end

    Ishift = fftshift(fftshift(I,1),2);

end