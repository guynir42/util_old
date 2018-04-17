function show_inset(I, varargin)
   
    import util.plot.*;
    import util.text.*;
    
    connector = [1 3];
    line_width = 2;
    parent = [];
    mono = [];
    bias = [];
    dyn = [];
    autodyn = [];    
    source_pos = [];
    inset_pos = [];
    
    for ii = 1:2:length(varargin)
        
        key = varargin{ii};
        val = varargin{ii+1};
        
        if cs(key, 'connector')
            connector = val;
        elseif cs(key, 'line_width')
            line_width = val;
        elseif cs(key, 'parent')
            parent = val;
        elseif cs(key, 'bias')
            bias = val;
        elseif cs(key, 'monochrome')
            mono = val;
        elseif cs(key, 'dyn')
            dyn = val;
        elseif cs(key, 'autodyn')
            autodyn = val;
        elseif cs(key, 'source_position')
            source_pos = val;
        elseif cs(key, 'inset_position')
            inset_pos = val;
        end
        
    end
    
    if isempty(connector)
        connector = [1 3];
    end
    
    if isempty(parent)
        parent = gcf;
    end
    
    if isempty(source_pos)
        source_pos = [0.1 0.1 0.2 0.2];
    elseif length(source_pos)<2
        source_pos = [source_pos source_pos 0.2 0.2];
    elseif length(source_pos)<3
        source_pos = [source_pos 0.2 0.2];
    elseif length(source_pos)<4
        source_pos = [source_pos source_pos(3)];
    end
    
    if isempty(inset_pos)
        inset_pos = [0.4 0.4 0.5 0.5];
    elseif length(inset_pos)<2
        inset_pos = [inset_pos inset_pos 0.5 0.5];
    elseif length(inset_pos)<3
        inset_pos = [inset_pos 0.5 0.5];
    elseif length(inset_pos)<4
        inset_pos = [inset_pos inset_pos(3)*source_pos(4)/source_pos(3)];
    end
    
    % ingest source position
    x_pixels = unit_convert(source_pos(1), size(I,2));
    y_pixels = unit_convert(source_pos(2), size(I,1));
    w_pixels = unit_convert(source_pos(3), size(I,2));    
    h_pixels = unit_convert(source_pos(4), size(I,1));
    
    Sx1 = x_pixels;
    Sx2 = x_pixels+w_pixels;
    if Sx2>size(I,2), Sx2 = size(I,2); end

    Sy1 = y_pixels;
    Sy2 = y_pixels+h_pixels;
    if Sy2>size(I,1), Sy2 = size(I,1); end
        
%     Sx1_norm = x_norm;
%     Sx2_norm = x_norm+w_norm;
%     if Sx2_norm>1, Sx2_norm = 1; end       
%         
%     
%     Sy1_norm = y_norm;
%     Sy2_norm = y_norm+h_norm;
%     if Sy2_norm>1, Sy2_norm = 1; end       
%     
%     % ingest inset position
%     [x_pixels, x_norm] = unit_convert(inset_pos(1), size(I,2));
%     [y_pixels, y_norm] = unit_convert(inset_pos(2), size(I,1));
%     [w_pixels, w_norm] = unit_convert(inset_pos(3), size(I,2));    
%     [h_pixels, h_norm] = unit_convert(inset_pos(4), size(I,1));
%     
%     Ix1 = x_pixels;
%     Ix2 = x_pixels+w_pixels;
%     if Ix2>size(I,2), Ix2 = size(I,2); end
%     
%     Ix1_norm = x_norm;
%     Ix2_norm = x_norm+w_norm;
%     if Ix2_norm>1, Ix2_norm = 1; end       
%         
%     Iy1 = y_pixels;
%     Iy2 = y_pixels+h_pixels;
%     if Iy2>size(I,1), Iy2 = size(I,1); end
%     
%     Iy1_norm = y_norm;
%     Iy2_norm = y_norm+h_norm;
%     if Iy2_norm>1, Iy2_norm = 1; end
    
    %%%%%%%%%%%%%%%%%%%%%% PLOT STARTS HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    delete(parent.Children);
    h=findall(parent,'Tag','scribeOverlay');
    if ~isempty(h)
        delete(h.Children);
    end
    
    ax1 = axes('parent', parent, 'position', [0 0 1 1]);
    show(I, 'ax', ax1, 'monochrome', mono, 'bias', bias, 'dyn', dyn, 'autodyn', autodyn, 'fancy', 'off');
    
    [Sx1_norm, Sy1_norm] = ds2nfu(ax1, Sx1, Sy1);
    [Sx2_norm, Sy2_norm] = ds2nfu(ax1, Sx2, Sy2);
    
    temp = [1-Sy2_norm, 1-Sy1_norm];
    Sy1_norm = temp(1);
    Sy2_norm = temp(2);
    
    annotation(parent, 'rectangle', [Sx1_norm Sy1_norm Sx2_norm-Sx1_norm Sy2_norm-Sy1_norm]);

    Ix1_norm = inset_pos(1);
    Ix2_norm = inset_pos(1)+inset_pos(3);
    Iy1_norm = inset_pos(2);
    Iy2_norm = inset_pos(2)+inset_pos(4);    
    
    temp = [1-Iy2_norm, 1-Iy1_norm];
    Iy1_norm = temp(1);
    Iy2_norm = temp(2);
    inset_pos = [Ix1_norm, Iy1_norm, Ix2_norm-Ix1_norm, Iy2_norm-Iy1_norm];
    
    ax2 = axes('parent', parent, 'position', inset_pos);
    show(I(Sy1:Sy2, Sx1:Sx2), 'ax', ax2, 'monochrome', mono, 'bias', bias, 'dyn', dyn, 'autodyn', autodyn, 'fancy', 'off');
    ax2.LineWidth = line_width;    
    
    for ii = 1:2
        if connector(ii)==1
            annotation(parent, 'line', [Sx2_norm Ix2_norm], [Sy2_norm Iy2_norm], 'LineWidth', line_width);
        elseif connector(ii)==2
            annotation(parent, 'line', [Sx1_norm Ix1_norm], [Sy2_norm Iy2_norm], 'LineWidth', line_width);
        elseif connector(ii)==3
            annotation(parent, 'line', [Sx1_norm Ix1_norm], [Sy1_norm Iy1_norm], 'LineWidth', line_width);
        elseif connector(ii)==4
            annotation(parent, 'line', [Sx2_norm Ix2_norm], [Sy1_norm Iy1_norm], 'LineWidth', line_width);
        else
            error(['Connector values must be between 1 and 4. Input was connector(' num2str(ii) ')= ' num2str(connector(ii))]);
        end
        
    end
    
end

function [pixels, norm] = unit_convert(value, axis_length)
    
    if value<0
        error(['Given value of "' inputname(1) '"= ' num2str(value) ' must be positive!']);
    elseif value<1
        pixels = round(value.*axis_length);
        norm = value;
    elseif value<=axis_length
        pixels = round(value);
        norm = value./axis_length;
    elseif value>axis_length
        error(['Given value of "' inputname(1) '"= ' num2str(value) ' must be lower than axis_length= ' num2str(axis_length)]);
    end
    
end

function varargout = ds2nfu(varargin)
% DS2NFU  Convert data space units into normalized figure units. 
%
% [Xf, Yf] = DS2NFU(X, Y) converts X,Y coordinates from
% data space to normalized figure units, using the current axes.  This is
% useful as input for ANNOTATION.  
%
% POSf = DS2NFU(POS) converts 4-element position vector, POS from
% data space to normalized figure units, using the current axes.  The
% position vector has the form [Xo Yo Width Height], as defined here:
%
%      web(['jar:file:D:/Applications/MATLAB/R2006a/help/techdoc/' ...
%           'help.jar!/creating_plots/axes_pr4.html'], '-helpbrowser')
%
% [Xf, Yf] = DS2NFU(HAX, X, Y) converts X,Y coordinates from
% data space to normalized figure units, on specified axes HAX.  
%
% POSf = DS2NFU(HAX, POS) converts 4-element position vector, POS from
% data space to normalized figure units, using the current axes. 
%
% Ex.
%       % Create some data
% 		t = 0:.1:4*pi;
% 		s = sin(t);
%
%       % Add an annotation requiring (x,y) coordinate vectors
% 		plot(t,s);ylim([-1.2 1.2])
% 		xa = [1.6 2]*pi;
% 		ya = [0 0];
% 		[xaf,yaf] = ds2nfu(xa,ya);
% 		annotation('arrow',xaf,yaf)
%
%       % Add an annotation requiring a position vector
% 		pose = [4*pi/2 .9 pi .2];
% 		posef = ds2nfu(pose);
% 		annotation('ellipse',posef)
%
%       % Add annotations on a figure with multiple axes
% 		figure;
% 		hAx1 = subplot(211);
% 		plot(t,s);ylim([-1.2 1.2])
% 		hAx2 = subplot(212);
% 		plot(t,-s);ylim([-1.2 1.2])
% 		[xaf,yaf] = ds2nfu(hAx1,xa,ya);
% 		annotation('arrow',xaf,yaf)
% 		pose = [4*pi/2 -1.1 pi .2];
% 		posef = ds2nfu(hAx2,pose);
% 		annotation('ellipse',posef)

% Michelle Hirsch
% mhirsch@mathworks.com
% Copyright 2006-2014 The MathWorks, Inc

%% Process inputs
error(nargchk(1, 3, nargin))

% Determine if axes handle is specified
if length(varargin{1})== 1 && ishandle(varargin{1}) && strcmp(get(varargin{1},'type'),'axes')	
	hAx = varargin{1};
	varargin = varargin(2:end);
else
	hAx = gca;
end;

errmsg = ['Invalid input.  Coordinates must be specified as 1 four-element \n' ...
	'position vector or 2 equal length (x,y) vectors.'];

% Proceed with remaining inputs
if length(varargin)==1	% Must be 4 elt POS vector
	pos = varargin{1};
	if length(pos) ~=4, 
		error(errmsg);
	end;
else
	[x,y] = deal(varargin{:});
	if length(x) ~= length(y)
		error(errmsg)
	end
end

	
%% Get limits
axun = get(hAx,'Units');
set(hAx,'Units','normalized');
axpos = get(hAx,'Position');
axlim = axis(hAx);
axwidth = diff(axlim(1:2));
axheight = diff(axlim(3:4));


%% Transform data
if exist('x','var')
	varargout{1} = (x-axlim(1))*axpos(3)/axwidth + axpos(1);
	varargout{2} = (y-axlim(3))*axpos(4)/axheight + axpos(2);
else
	pos(1) = (pos(1)-axlim(1))/axwidth*axpos(3) + axpos(1);
	pos(2) = (pos(2)-axlim(3))/axheight*axpos(4) + axpos(2);
	pos(3) = pos(3)*axpos(3)/axwidth;
	pos(4) = pos(4)*axpos(4)/axheight;
	varargout{1} = pos;
end


%% Restore axes units
set(hAx,'Units',axun)

end
