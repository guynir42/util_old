function numbers = extract_numbers(str)
% extracts all numeric values from a string into a cell array. 

    if nargin==0
        help('util.text.extract_numbers');
        return;
    end

    if isnumeric(str)
        numbers = str;
        return;
    end

    if ischar(str)
        str = {str};
    end

    numbers{length(str)} = [];
    
    for ii = 1:length(str) % go over all strings
        
        string = str{ii};
        temp_numbers = [];
        temp_extraction = '';
             
        for jj = 1:length(str{ii}) % go over the letters in one string
                       
            if (string(jj)>='0' && string(jj)<='9') || string(jj)=='.' || string(jj)=='-' || string(jj)=='+' ||...
                    (~any(temp_extraction=='e') && ~any(temp_extraction=='E') && jj~=1 && jj~=length(string) && string(jj)=='e') ||...
                    (~any(temp_extraction=='e') && ~any(temp_extraction=='E') && jj~=1 && jj~=length(string) &&string(jj)=='E')
            
                temp_extraction(end+1) = string(jj);
                
            else
                
                if ~isempty(temp_extraction)
                    
                    a = sscanf(temp_extraction, '%f');
                    if ~isempty(a), temp_numbers(end+1) = a; end
                    
                end
                
                temp_extraction = '';
                
            end
            
        end %% end jj
        
        if ~isempty(temp_extraction)
            
            a = sscanf(temp_extraction, '%f');
            if ~isempty(a), temp_numbers(end+1) = a; end
            
        end
        
        numbers{ii} = temp_numbers;
            
    end % end ii

end