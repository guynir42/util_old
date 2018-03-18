function [X,Y] = centerGrid(M)
% Usage: [X,Y] = centerGrid(M). Makes a "meshgrid" the same size as M (only 
% counting the first 2 dimensions) setting X and Y to be zero at the center 
% of the matrix coordinate system. 

    S = util.vec.imsize(M, 'matrix');

    [X,Y] = meshgrid(-floor(S(2)/2):floor((S(2)-1)/2), -floor(S(1)/2):floor((S(1)-1)/2));
        
end