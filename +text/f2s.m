function str = f2s(float, decimals)
% Prints a floating point number as string. usage: f2s(float, decimals=2)
% Will format the number, keeping 2 decimal places (can be changed with the
% "decimals" optional parameter). 
% Will use scientific notation if number is more than 3 digits. 
    
    if nargin==0
        help('util.text.f2s');
        return; 
    end

    if nargin<2 || isempty(decimals)
        decimals = 2;
    end
    
    str = '';
    
    if all(float==round(float))
        str = util.text.print_vec(float);
        return;
    end
    
    for ii = 1:length(float)
        
        form = ['%4.' num2str(floor(decimals))];
        if float==0
            str = '0';
        elseif abs(float(ii))<1000 && abs(float(ii))>0.1
            form = [form 'f '];
        else
            form = [form 'e '];
        end

        str = [str sprintf(form, float(ii))];
        
    end

end