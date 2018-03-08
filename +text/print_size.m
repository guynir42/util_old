function s_out = print_size(varargin)
% Prints a formatted string with size of matrices. Usage: print_size(M1,[M2, M3,...])
% Will show the name of the inputs as given to print_size.
% Use to make quick debugging checks. 
% If no output is given, printsize just displays the result. 

    import util.text.print_vec;
    import util.text.pipe_append;
    
    if nargin==0
        help('util.text.print_size');
        return;
    end

    s = '';
    
    for ii = 1:length(varargin)

        s = pipe_append(s, print_vec(size(varargin{ii}), 'x', ['size(' inputname(ii) ')= ']));

    end
        
    if nargout==0
        disp(s);
    else
        s_out = s;
    end
    
end