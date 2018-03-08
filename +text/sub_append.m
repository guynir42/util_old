function str_out = sub_append(str1, str2, ext)
% append two strings, making sure there is a '_' between them. 
% Usage: sub_append(str1, str2, [ext])
% Optional argument "ext" adds an extension (as in, ".ext" to the string).

    if nargin==0
        help('util.text.sub_append');
        return;
    end

    if isempty(str1)
        str_out = str2;
        return;
    end
    
    if nargin<3 || isempty(ext)
        ext = [];
    end
    
    if isa(str1, 'util.WorkingDirectory')
        str1 = str1.pwd;
    end
    
    if nargin<2 || isempty(str2)
        str_out = str1;
        return;
    end
    
    if str2(1)=='_'
        str2 = str2(2:end);
    end
    
    if str1(end)=='_'
        str_out = [str1 str2];
    else
        str_out = [str1 '_' str2];
    end
    
    if ~isempty(ext)
        if ext(1)~='.'
            ext = ['.' ext];
        end
        str_out = [str_out ext];
    end
    
end