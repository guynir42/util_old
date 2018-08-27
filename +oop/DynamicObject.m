classdef DynamicObject < dynamicprops
% This class expands the "dynamicprops" class so that it saves aliases and 
% keeps track of the new property objects so you can also easily delete
% them. Will be used as base class for some the classes in +file and +img.
    
    properties(Hidden=true)
        
        list_added_properties = {}; % a list of all the new properties added (in order) to this object. 
        list_added_properties_objects = {};
        list_added_aliases = {}; % a cell of cell arrays of aliases for each of the added properties in the first list
        
    end
    
    methods % constructor
        
        function obj = DynamicObject(varargin)
            
            
            
        end
        
    end
    
    methods % add / remove properties 
        
        function p = addprop(obj, propname, value, varargin)
            
            if ~isprop(obj, propname)
                p = addprop@dynamicprops(obj, propname);
                obj.list_added_properties{end+1} = propname;
                obj.list_added_properties_objects{end+1} = p;
                obj.list_added_aliases{end+1} = {};
                idx = length(obj.list_added_properties);
            elseif any(strcmp(obj.list_added_properties, propname))
                idx = find(strcmp(obj.list_added_properties, propname), 1, 'first');
                p = obj.list_added_properties_objects{idx};
            else
                error('new property %s is part of the object but not part of "list_added_properties"!', propname);
            end
            
            if nargin>2
                obj.(propname) = value;
            end
            
            for ii = 1:length(varargin)
                if ~any(strcmp(obj.list_added_aliases{idx}, varargin{ii}))
                    obj.list_added_aliases{idx}{end+1} = varargin{ii};
                end
            end
            
        end
        
        function remprop(obj, propname)
            
            idx = find(strcmp(obj.list_added_properties, propname), 1, 'first');
            if ~isempty(idx)
                obj.rempropindex(idx);
            else
                % do we want to do a warning or anything??
            end
            
        end
        
        function rempropindex(obj, idx)
            
            p = obj.list_added_properties_objects{idx};
            obj.list_added_properties(idx) = [];
            obj.list_added_properties_objects(idx) = [];
            obj.list_added_aliases(idx) = [];
            delete(p);
            
        end
        
        function removeAllProperties(obj)
            
            for ii = 1:length(obj.list_added_properties_objects)
                delete(obj.list_added_properties_objects{ii})
            end
            
            obj.list_added_properties = {};
            obj.list_added_properties_objects = {};
            obj.list_added_aliases = {};
            
        end
        
    end
    
end