function obj = save_defaults(obj)
% takes the values of an instance object and copies each property XXXX to
% each "default_XXXX" property. Should be used in the constructor. 
% This allows the user to change the default values after instantiating an
% object, which is useful for GUI inputs and such. 

    list = util.oop.list_props(obj);
    
    for ii = 1:length(list)
        
        name = ['default_' list(ii).Name];
        if isprop(obj, name)
            obj.(name) = obj.(list(ii).Name);
        end
        
    end


end