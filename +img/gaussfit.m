function [pars_out, residuals, gaussian] = gaussfit(I, varargin)
% Takes an image I (and optional parameters) and fits a 2D Gaussian to the
% image. The optional arguments are used to select initial parameters to
% the fit. Any parameter left empty is not treated as a free parameter,
% except the width (if CX and CY are both left empty, the width would 
% default to 2 for both. 
% OPTIONAL ARGUMENT:
%   -sigma_x: initial guess for the sigma parameter of the Gaussian in the 
%    X axis. If sigma_y is not defined this parameter also sets the width 
%    in the Y axis. Input 0 to allow gaussfit to find an initial guess. 
%   -sigma_y: width along the y axis. Use this option if you want to fit a
%    Gaussian with different widths. Input 0 to allow gaussfit to find an
%    initial guess. 
%   -rot_frac: intial guess for how much the axes are rotated (1 is 90 
%    degrees). Use this option if you want to allow the axes to be rotated 
%    in the fit. 
%   -amplitude: initial guess for the overall normalization of the PSF
%    (assume the Gaussian is normalized to unity, multiplied by amplitude). 
%    Input 0 to allow gaussfit to find an initial guess. 
%   -shift: initial guess of the shift of the center of the Gaussian. Given
%    as a 2 element vector (in x then y order). 
%
%  OUTPUTS: 
%   -pars_out: a vector of outputs in the same order as the list of inputs, 
%    only instead of initial guesses we get the fit results. 
%    Note that the shifts are returned as two elements in the vector, x
%    then y, if a shift is given to the fitter. 
%   -residuals: the value of the normalized merit function r, given by:
%       r = ((G-I).^2/I.^2); where G is the fit model and I is the input. 
%   -gaussian: optional output, the image of the model gaussian.
%  
    
    if nargin==0, help('util.img.gaussfit'); return; end
    
    if isempty(I) || isscalar(I) || isvector(I)
        error('Cannot fit without an input image!');
    end
    
    input = util.text.InputVars;
    input.input_var('sigma_x', 0, 'CX', 'width');
    input.input_var('sigma_y', [], 'CY');    
    input.input_var('amplitude', [], 'normalization');
    input.input_var('rot_frac', []);
    input.input_var('shift', []);
    input.use_ordered_numeric = 1;
    input.scan_vars(varargin{:});
%     input.printout;
        
    S = util.vec.imsize(I); % image size

    % automatically find some crude initial guesses
    if ~isempty(input.sigma_x) && input.sigma_x==0
        input.sigma_x = util.img.fwhm2(I)/2.355;
    end
    
    if ~isempty(input.amplitude) && input.amplitude==0
        input.amplitude = util.stat.sum2(I);
    end
    
    % parse the inputs into a single vector
    b_initial = input.sigma_x;
    if ~isscalar(input.sigma_x)
        error('input sigma_x must be a scalar!');
    end
    
    if ~isempty(input.sigma_y)
        if ~isscalar(input.sigma_y)
            error('input sigma_y must be a scalar!');
        end
        b_initial = [b_initial, input.sigma_y];
    end
    
    if ~isempty(input.amplitude)
        if ~isscalar(input.amplitude)
            error('input amplitude must be a scalar!');
        end
        b_initial = [b_initial, input.amplitude];
    end
    
    N = length(b_initial); % how many parameters go into the gaussian, the rest go into coordinates x and y
    
    if ~isempty(input.rot_frac)
        if ~isscalar(input.rot_frac)
            error('input rot_frac must be a scalar!');
        end
        b_initial = [b_initial, input.rot_frac];
    end
    
    if ~isempty(input.shift)
        if length(input.shift)~=2
            error('input shift must be a 2 element vector!');
        end
        b_initial = [b_initial, input.shift];
    end
    
    % choose how many parameters are used for the fit...
    if N==1 % only a width is given to the gaussian...
        g_func = @(b) exp(-0.5*((make_x(b(N+1:end), S(2))./b(1)).^2 + (make_y(b(N+1:end), S(1))./b(1)).^2))/(2*pi*b(1).^2);
    elseif N==2 && isempty(input.amplitude) % the width in x and y are given to the gaussian
        g_func = @(b) exp(-0.5*((make_x(b(N+1:end), S(2))./b(1)).^2 + (make_y(b(N+1:end), S(1))./b(2)).^2))/(2*pi*b(1)*b(2));
    elseif N==2 && isempty(input.sigma_y) % given amplitude and the width in x (symmetric gaussian)
        g_func = @(b) b(2)*exp(-0.5*((make_x(b(N+1:end), S(2))./b(1)).^2 + (make_y(b(N+1:end), S(1))./b(1)).^2))/(2*pi*b(1).^2);
    elseif N==3 % given amplitude and width in x and y
        g_func = @(b) b(3)*exp(-0.5*((make_x(b(N+1:end), S(2))./b(1)).^2 + (make_y(b(N+1:end), S(1))./b(2)).^2))/(2*pi*b(1)*b(2));
    end
    
    min_func = @(b) util.stat.sum2(((g_func(b)-I).^2)./I.^2);
    
    % do the minimization! 
    b_final = fminsearch(min_func, b_initial);
    
    % load the results back into the "input" object
    input.sigma_x = b_final(1);
    if ~isempty(input.sigma_y)
        input.sigma_y = b_final(2);
    end
    
    if isempty(input.sigma_y) && ~isempty(input.amplitude)
        input.amplitude = b_final(2);
    elseif ~isempty(input.sigma_y) && ~isempty(input.amplitude)
        input.amplitude = b_final(3);
    end
    
    if ~isempty(input.rot_frac)
        input.rot_frac = b_final(N+1);
    end
    
    if ~isempty(input.shift)
        if isempty(input.rot_frac)
            input.shift = b_final(N+1:N+2);
        else
            input.shift = b_final(N+2:N+3);
        end
    end
        
%     util.plot.show(g_func(b_final));
    
    for ii = 1:length(input.list_scan_properties)
        name = input.list_scan_properties{ii};
        if length(input.(name))==1
            pars_out(ii) = input.(name);
        elseif length(input.(name))==2
            pars_out(ii:ii+1) = input.(name); % for the 2-element shifts
        end
    end

    % add the residual result
    if nargout>1
        residuals = min_func(b_final);
    end
    
    if nargout>2
        gaussian = g_func(b_final);
        
    end
    
end

function x = make_x(par_vec, s)

    [x,y] = meshgrid(-floor((s)/2):floor((s-1)/2));
    
    if ~isempty(par_vec)
        [rot, shift_x, shift_y] = parse_par_vec(par_vec);
        x = x - shift_x;
        y = y - shift_y;
        x = x*cos(pi/2*rot)+y*sin(pi/2*rot);
    end
        
end

function y = make_y(par_vec, s)

    [x,y] = meshgrid(-floor((s)/2):floor((s-1)/2));
    
    if ~isempty(par_vec)
        [rot, shift_x, shift_y] = parse_par_vec(par_vec);
        x = x - shift_x;
        y = y - shift_y;
        y = -x*sin(pi/2*rot)+y*cos(pi/2*rot);
    end
        
end

function [rot, shift_x, shift_y] = parse_par_vec(par_vec)

    if length(par_vec)==1
        rot = par_vec(1);
        shift_x = 0;
        shift_y = 0;
    elseif length(par_vec)==2
        rot = 0;
        shift_x = par_vec(1);
        shift_y = par_vec(2);
    elseif length(par_vec)==3
        rot = par_vec(1);
        shift_x = par_vec(2);
        shift_y = par_vec(3);
    else
        error('par_vec must be 1 to 3 elements long. ');
    end

end
