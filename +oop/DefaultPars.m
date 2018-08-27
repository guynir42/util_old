classdef DefaultPars < dynamicprops

    properties % objects
        
    end
    
    properties % inputs/outputs
        
        evalin_mode = 'caller'; % can also choose "base"
        list_vars;
        
    end
    
    properties % switches/controls
        
        debug_bit = 1;
        
    end
    
    properties(Dependent=true)
        
        
        
    end
    
    properties(Hidden=true)
       
        version = 1.00;
        
    end
    
    methods % constructor
        
        function obj = DefaultPars(varargin)
            
            if ~isempty(varargin) && isa(varargin{1}, 'util.oop.DefaultPars')
                if obj.debug_bit, fprintf('DefaultPars copy-constructor v%4.2f\n', obj.version); end
                obj = util.oop.full_copy(varargin{1});
            else
                if obj.debug_bit, fprintf('DefaultPars constructor v%4.2f\n', obj.version); end
            
            end
            
        end
        
    end
    
    methods % reset/clear
        
    end
    
    methods % calculations
        
        function addProp(obj, name, value)
           
            if nargin<3
                value = [];
            end
            
            addprop(obj, name);
            obj.(name) = value;
            
        end
        
        function addProps(obj, varargin)
           
            for ii = 1:length(varargin)
               
                obj.addProp(varargin{ii});
                
            end
            
        end
        
        function readGlobals(obj)
           
            obj.list_vars = evalin(obj.evalin_mode, 'who');
            
            props = properties(obj);
            
            for ii = 1:length(props)
               
                idx = strcmp(props{ii}, obj.list_vars);
                if nnz(idx)
                    
                    obj.(props{ii}) = evalin(obj.evalin_mode, obj.list_vars{find(idx, 1, 'first')});
                    
                end
                
            end
            
        end
        
    end
    
    methods % plotting tools / GUI
        
    end    
    
end

