function time = str2time(str, timezone)
% parses a time string (FITS format compliant) into a datetime object
% usage: str2time(str, timezone='UTC')
% Optional argument defines the timezone (default: UTC); 

    if nargin==0
        help('util.text.str2time');
        return;
    end

    if isempty(str) || strcmp(str, '[]')
        time = datetime.empty;
        return;
    end
    
    if nargin<2 || isempty(timezone)
        timezone = 'UTC';
    end
    
    vec = sscanf(str, '%4d-%2d-%2dT%2d:%2d:%f')';

    time = datetime(vec, 'TimeZone', timezone);
    
end