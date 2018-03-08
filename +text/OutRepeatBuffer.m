classdef OutRepeatBuffer < handle
% This object buffers errors or warnings and if the same error comes up too
% many times in a row it is suppressed. 
        
    properties(SetAccess='protected')
       
        str = '';
        num_matches = 0;
        
        max_num;
        
    end
    
    methods % constructor
       
        function obj = OutRepeatBuffer(number)
        
            if nargin<1 || isempty(number)
                number = 3; % default value
            end
            
            obj.max_num = number;                
            
        end
            
    end
    
    methods % setters
       
       function out_str = input(obj, str)
           
            if isempty(str)
                return;
            end
            
            if strcmp(obj.str, str) % if we have a match
               
                obj.num_matches = obj.num_matches + 1;
                
                if obj.num_matches<obj.max_num
                    out_str = str;
                elseif obj.num_matches==obj.max_num
                    num = min([40, length(str)]);
                    out_str = ['after ' num2str(obj.num_matches) ' suppressing: "' str(1:num) '..."'];
                else
                    out_str = '';
                end
                
            else % if a new input arrives
                obj.str = str;
                obj.num_matches = 1;
                out_str = str;
            end
            
        end
        
    end
    
end