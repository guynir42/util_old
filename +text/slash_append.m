function str = slash_append(varargin)
% Shortcut function from the evidently ever so useful sa (slash append). 

    if length(varargin)==0
        help('util.text.slash_append');
        disp('slash_append: ');
        help('util.text.sa');
        return;
    end

    str = util.text.sa(varargin{:});

end