function str = time2str(time)
% turns a datetime object into a string (FITS format compliant)
    
    if nargin==0
        help('util.text.time2str');
        return;
    end

    if builtin('isempty', time)
        str = '';
        return;
    end

    vec = datevec(time);

    str = sprintf('%4d-%02d-%02dT%02d:%02d:%06.3f', vec(1), vec(2), vec(3), vec(4), vec(5), vec(6)); 

end