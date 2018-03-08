function h = scale_bar(varargin)

    import util.text.cs;

    ax = [];
    pixel_length = []; % pixel length
    user_length = [];
    location = 'SouthWest';
    position = [];
    line_offset = [];
    edge_length = [];
    color = 'Black';
    font_size = [];
    str = '';
    ps = [];    
    binning = 1;
        
    for ii = 1:2:length(varargin)
        if cs(varargin{ii}, {'axis', 'axes'})
            ax = varargin{ii+1};
        elseif cs(varargin{ii}, {'length'})
            user_length = varargin{ii+1};
        elseif cs(varargin{ii}, {'location'})
            location = varargin{ii+1};
        elseif cs(varargin{ii}, {'position'})
            position = varargin{ii+1};
        elseif cs(varargin{ii}, {'offset', 'lineoffset'})
            line_offset = varargin{ii+1};
        elseif cs(varargin{ii}, 'edgelength')
            edge_length = varargin{ii+1};
        elseif cs(varargin{ii}, 'color')
            color = varargin{ii+1};
        elseif cs(varargin{ii}, 'fontsize')
            font_size = varargin{ii+1};
        elseif cs(varargin{ii}, 'text')
            str = varargin{ii+1};
        elseif cs(varargin{ii}, {'platescale', 'ps'})
            ps = varargin{ii+1};
        elseif cs(varargin{ii}, {'binning'})
            binning = varargin{ii+1};
        end
    end
    
    if ~isempty(ps)
        if isempty(user_length)
            user_length = 1;
        end
        
        if ischar(ps) && cs(ps, 'nyquist')
            
            if user_length==1
                str = '\lambda/D';
            else
                str = [num2str(user_length) '\lambda/D'];
            end
            
            pixel_length = 2*binning*user_length;
            edge_length = 1;
            
        else
        
            pixel_length = user_length/ps;
            if isempty(str)
                str = sprintf('%.0f"', user_length);
            end
            
        end
    else
        if isempty(user_length)
            pixel_length = 10;
        else
            pixel_length = user_length;
        end
        
        if isempty(str)
            str = sprintf('%dpx',pixel_length);
        end
    end
    
    if isempty(edge_length)
        edge_length = 2;
    end
    
    if isempty(ax)
        ax = gca;
    end
    
    h_image = findobj(ax, 'type', 'image');
    if isempty(h_image), return; end
    h_image = h_image(1);
    I = h_image.CData;
    
    if isempty(line_offset)
        line_offset = ceil(0.1*min(size(I)));
    end
       
    if isempty(position)
       if cs(location, {'southwest','sw'})
           position(1) = line_offset;
           position(2) = -line_offset + size(I,1);
           text_offset = 1.2*pixel_length;
           text_align = 'Left';
       elseif cs(location, {'northwest', 'nw'})
           position(1) = line_offset;
           position(2) = line_offset;
           text_offset = 1.2*pixel_length;
           text_align = 'Left';
       elseif cs(location, {'southeast', 'se'})
           position(1) = -line_offset + size(I,2);
           position(2) = -line_offset + size(I,1);
           text_offset = -0.2*pixel_length;
           text_align = 'Right';
       elseif cs(location, {'northeast', 'ne'})
           position(1) = -line_offset + size(I,2);
           position(2) = line_offset;
           text_offset = -0.2*pixel_length;
           text_align = 'Right';       
       else
           warning(['unknown location specifier: ' location ' using SouthWest instead'])
           position(1) = line_offset;
           position(2) = -line_offset + size(I,1);
       end
    else
        text_offset = 1.2*pixel_length;
        text_align = 'Left';
    end
    
    line(position(1)+[0 pixel_length], position(2)*[1 1], 'Color', color);
    line(position(1)*[1 1], position(2)+[-1 1]*edge_length, 'Color', color);
    line(position(1)*[1 1]+pixel_length, position(2)+[-1 1]*edge_length, 'Color', color);
    
    if isempty(font_size)
        font_size = get(0, 'DefaultTextFontSize');
    end
    
    text(position(1)+text_offset, position(2), str, 'Color', color, 'FontSize', font_size, 'HorizontalAlignment', text_align);
        

end