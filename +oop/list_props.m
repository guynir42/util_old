function props = list_props(obj)
% gets the list of properties of an object, including the dynamic ones... 

    class_def = metaclass(obj);
    propnames = {class_def.PropertyList.Name}';
    props = class_def.PropertyList;
    
    if isa(obj, 'dynamicprops') % add any dynamic properties not appearing in metaclass (but appear in "properties")
        propnames_public = properties(obj);
        for ii = 1:length(propnames_public)

            if ~any(strcmp(propnames, propnames_public{ii}))
                props(end+1) = findprop(obj, propnames_public{ii});
            end

        end
    end
    

end