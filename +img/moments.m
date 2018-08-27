function [first_xy, second_x2y2xy] = moments(I, varargin)
% usage: [first_xy, second_xy] = moments(I, varargin)
% calculate the first and second moment of an image. 
% can handle 3D matrices. 
%
% OPTIONAL ARGUMENTS:
%
%
%
%
% OUTPUTS:
% -first_xy: a matrix, with 1st colum containing the first moment in x, 
%            the second column the 1st moment in y. Each row is for a
%            different image (if I is 3D, otherwise returns just a 2
%            element row vector). 
% -second_x2y2xy: the same as "first_xy" only with three columns, one for
%                 x^2, one for y^2 and one for xy.
%

    import util.stat.sum2;

    if nargin==0, help('util.img.moments'); return; end
    
    % add reading of varargin 
    
    
    % these should be optional! 
    I = util.img.maskBadPixels(I);
    I = I - util.stat.corner_mean(I);

    [x,y] = util.vec.centerGrid(zeros(size(I)));
    
    N = size(I,3);
    
    M1x = zeros(N,1);
    M1y = zeros(N,1);
    M2x = zeros(N,1);
    M2y = zeros(N,1);
    Mxy = zeros(N,1);
    first_xy = zeros(N,2);
    second_x2y2xy = zeros(N,3);
    
    for ii = 1:N
        
        S = sum2(I(:,:,ii));
        M1x(ii) = sum2(I(:,:,ii).*x)/S;
        M1y(ii) = sum2(I(:,:,ii).*y)/S;
        first_xy(ii,:) = [M1x(ii), M1y(ii)];
        
        M2x(ii) = sum2(I(:,:,ii).*x.^2)/S;
        M2y(ii) = sum2(I(:,:,ii).*y.^2)/S;
        Mxy(ii) = sum2(I(:,:,ii).*x.*y)/S;
        
        second_x2y2xy(ii,:) = [M2x(ii), M2y(ii), Mxy(ii)];
        
    end
                    

end