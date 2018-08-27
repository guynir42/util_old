function I = paraboloid2(varargin)
% usage: paraboloid2(a_x, a_y=a_x, rot_frac=0, S=auto)
% Generates an image of a 2D paraboloid at the center. 
% PARAMETERS:
%   -a_x: the width parameter in the X direction. 
%   -a_y: the width parameter in Y. Default is same as X. 
%   -rot_frac: rotation angle in units of 0 to 1 (=90 degrees). 
%   -S: size of image (assumed square). Default is ceil(max(a_x,a_y)*10),
%       adjusted to be an odd-number.1. 
%
% Parameters can be given in order or as keyword-value pairs...

    if nargin==0, help('util.img.paraboloid2'); return; end

    input = util.text.InputVars;
    input.input_var('ax', []);
    input.input_var('ay', []);
    input.input_var('rot_frac', 0);
    input.input_var('S', [], 'size', 'imsize');
    input.use_ordered_numeric = 1;
    input.scan_vars(varargin{:});
    
    if isempty(input.ax) && isempty(input.ay)
        error('Must supply a width of the paraboloid...');
    elseif ~isempty(input.ax) && isempty(input.ay)
        input.ay = input.ax;
    elseif isempty(input.ax) && ~isempty(input.ay)
        input.ax = input.ay;
    end
        
    if isempty(input.S)
        input.S = ceil((max(input.ax, input.ay)*10));
        input.S = input.S+mod(input.S+1,2);
    end
                
    [x,y] = meshgrid(-floor((input.S)/2):floor((input.S-1)/2));
    
    if isempty(input.rot_frac)
        x2 = x;
        y2 = y;
    else
        x2 = +x*cos(pi/2*input.rot_frac)+y*sin(pi/2*input.rot_frac);
        y2 = -x*sin(pi/2*input.rot_frac)+y*cos(pi/2*input.rot_frac);
    end
    
    I = input.ax.*x.^2+input.ay.*y.^2;
            
end