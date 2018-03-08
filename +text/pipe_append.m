function str_out = pipe_append(str_in, format, varargin)
% Usage: pipe_append(str_in, format, varargin)
% Adds a pipe | to the input string (unless it is empty) then appends the output of sprintf.
% OPTIONAL ARGUMENTS: parameters passed directly to sprintf
 
    if nargin==0, help('util.text.pipe_append'); return; end

    if ~isempty(str_in)
        str_in = [str_in ' | '];
    end
    
    str_out = [str_in sprintf(format, varargin{:})];
    
end