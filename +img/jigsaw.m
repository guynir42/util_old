function [cutouts, positions] = jigsaw(Im, varargin)

    input = util.text.InputVars;
    input.input_var('tile', 128, 'tile_size', 'size');
    input.input_var('pad_value', 0);
    input.input_var('overlap', []);
    input.input_var('squeeze', 1);
    input.scan_vars(varargin{:});
    
    t = input.tile;
    if isscalar(t)
        t = [t t];
    end
    
    S = util.vec.imsize(Im);
    
    if all(t>=S) % if the tile is larger than image return single cutout/position
        cutouts = Im;
        positions = flip(floor(S/2)+1);
        return;
    end
    
    Nx = ceil(S(2)./t(2));
    Ny = ceil(S(1)./t(1));
    
    if input.overlap
        Nx = Nx.*input.overlap;
        Ny = Ny.*input.overlap;
    end
    
    positions = zeros(Nx.*Ny,2);
    
    if input.pad_value==0
        cutouts = zeros(t(1),t(2),size(Im,3),Nx.*Ny);
    elseif isnan(input.pad_value) || (ischar(input.pad_value) && isnan(input.pad_value))
        cutouts = nan(t(1),t(2),size(Im,3),Nx.*Ny);
    elseif isnumeric(input.pad_value)
        cutouts = ones(t(1),t(2),size(Im,3),Nx.*Ny).*input.pad_value;
    end
        
    
    counter = 1;
    
    for ii = 1:Ny
        for jj = 1:Nx
            
            start_y = (ii-1)*t(1)+1;
            end_y = ii*t(1);
            if end_y>S(1), end_y = S(1); end
            
            start_x = (jj-1)*t(2)+1;
            end_x = jj*t(2);
            if end_x>S(2), end_x = S(2); end
            
            C = Im(start_y:end_y,start_x:end_x,:);
            cutouts(1:size(C,1),1:size(C,2),:,counter) = C;
            positions(counter,1) = (end_x+start_x)/2;
            positions(counter,2) = (end_y+start_y)/2;
                        
            counter = counter + 1;
            
        end
    end

    if input.squeeze
        cutouts = squeeze(cutouts);
    end
    
end